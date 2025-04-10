import de.bezier.guido.*;
public final static int NUM_ROWS = 20;
public final static int NUM_COLS = 20;
private boolean isLose = false;
private MSButton[][] buttons; 
private ArrayList <MSButton> mines;
public void setup () {
  loop();
  size(400, 400);
  textAlign(CENTER, CENTER);
  Interactive.make( this );
  buttons = new MSButton[NUM_ROWS][NUM_COLS];
  for (int i = 0; i < NUM_ROWS; i++) {
    for (int j = 0; j < NUM_COLS; j++) {
      buttons[i][j] = new MSButton(i, j);
    }
  }
  mines = new ArrayList<MSButton>();
  for (int i = 0; i < 50; i++) {
    setMines();
  }
}
public void setMines() {
  int row = (int)(Math.random()*NUM_ROWS);
  int col = (int)(Math.random()*NUM_COLS);
  if (mines.contains(buttons[row][col])) {
    setMines();
  } 
  else {
    mines.add(buttons[row][col]);
  }
}

public void draw () {
  background( 0 );
  if (isWon()) {
    displayWinningMessage();
    noLoop();
  }
  if(isLose) {
    displayLosingMessage();
    noLoop();
  }
}
public boolean isWon() {
  for (int i = 0; i < NUM_ROWS; i++) {
    for (int j = 0; j < NUM_COLS; j++) {
      if (!mines.contains(buttons[i][j]) && buttons[i][j].isClicked() == false) {
        return false;
      }
    }
  }
  return true;
}
public void displayLosingMessage() {
  buttons[9][6].setLabel("Y");
  buttons[9][7].setLabel("O");
  buttons[9][8].setLabel("U");
  buttons[9][9].setLabel(" ");
  buttons[9][10].setLabel("L");
  buttons[9][11].setLabel("O");
  buttons[9][12].setLabel("S");
  buttons[9][13].setLabel("E");
  for (int i = 6; i < 14; i++) {
    buttons[9][i].setColor(0);
  }
}
public void displayWinningMessage() {
  buttons[9][6].setLabel("Y");
  buttons[9][7].setLabel("O");
  buttons[9][8].setLabel("U");
  buttons[9][9].setLabel(" ");
  buttons[9][10].setLabel("W");
  buttons[9][11].setLabel("I");
  buttons[9][12].setLabel("N");
  buttons[9][13].setLabel("!");
  for (int i = 6; i < 14; i++) {
    buttons[9][i].setColor(0);
  }
}

public class MSButton {
  private int r, c;
  private float x, y, width, height;
  private boolean clicked, marked;
  private String label;
  private color textColor;
  public MSButton ( int rr, int cc ) {
    width = 400/NUM_COLS;
    height = 400/NUM_ROWS;
    r = rr;
    c = cc; 
    x = c*width;
    y = r*height;
    label = "";
    marked = clicked = false;
    textColor = 0;
    Interactive.add( this ); 
  }
  public boolean isMarked() {
    return marked;
  }
  public boolean isClicked() {
    return clicked;
  }
  public void setColor(color tc) {
    textColor = tc;
  }
  private void setClicked(boolean joy) {
    clicked = joy; 
  }
    
public void mousePressed () {
    if (mouseButton == RIGHT) { 
        marked = !marked;
        return; 
    }

    if (marked) return; 

    clicked = true;
    marked = false;

    if (mines.contains(this)) {
        for (int i = 0; i < mines.size(); i++) {
            mines.get(i).setClicked(true);
        }
        isLose = true;
    } 
    else if (countMines(r, c) > 0) {
        setLabel(str(countMines(r, c)));
    } 
    else {
        for (int row = r-1; row < r+2; row++) {
            for (int col = c-1; col < c+2; col++) {
                if (isValid(row, col) && !buttons[row][col].isClicked()) {
                    buttons[row][col].mousePressed();
                }
            }
        }
    }
}

public void draw () {  
    if (isLose && mines.contains(this)) {
        fill(255, 0, 0); 
    }
    else if (marked) {
        fill(0); 
    }
    else if (clicked) {
        fill(225, 242, 167); 
    }
    else { 
        fill(170, 215, 81); 
    }
    rect(x, y, width, height);
    
    if (marked) { 
        fill(255, 0, 0);
        float midX = x + width / 2;
        float midY = y + height / 3;
        triangle(midX - 5, y + height - 5, midX + 5, y + height - 5, midX, midY);
    }

    fill(textColor);
    text(label, x+width/2, y+height/2);
}



  public void setLabel(String newLabel) {
    label = newLabel;
  }
  public boolean isValid(int r, int c) {
    if (r >= 0 && r < NUM_ROWS && c >= 0 && c < NUM_COLS) {
      return true;
    } 
    else {
      return false;
    }
  }
  public int countMines(int row, int col) {
    int numMines = 0;
    for (int i = row-1; i < row+2; i++) {
      for (int j = col-1; j < col+2; j++) {
        if (isValid(i, j) && mines.contains(buttons[i][j])) {
          numMines+=1;
        }
      }
    }
    return numMines;
  }
}
