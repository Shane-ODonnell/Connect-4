int w;
Map map;
boolean turn;
PImage Frame;

void setup() {
  turn = false;
  size(800, 800);
  map = new Map(8);
  map.show();
  Frame = loadImage("Frame.png");
}

void draw() {
  map.show();
  image(Frame, 0, 0, width, height);
}

class Tile {
  int i, j;
  boolean empty = true;
  boolean red;

  Tile(int I, int J) {
    i = I;
    j = J;
  }

  boolean mouseOver() {
    int x1 = i*w;
    int x2 = x1 + w;

    int y1 = j*w;
    int y2 = y1 + w;

    if (x1 <= mouseX && mouseX <= x2 && y1 <= mouseY && mouseY <= y2)
      return true;

    return false;
  }

  void show() {
    if (empty)
      fill(100);

    else if (red)
      fill(200, 0, 0);

    else
      fill(255, 235, 59); //if not red or empty then yellow

    rect(i*w, j*w, w, w);
  }

  void yellow(boolean temp) {
    if (empty) {
      red = !temp; //if yellow(true) then red = false;
      empty = false;
      turn = !turn;
    }
  }
}

class Map {
  Tile [] grid; // declare array of tiles called grid
  int size;

  Map(int S) {
    size = S;
    w = floor(width / size) ;
    grid = new Tile [size*size];                    // initialise grid as an array of tiles of size S


    int iterator = 0;
    for (int i = 0; i < size; i++) {
      for (int j = 0; j < size; j++) {
        grid[iterator] = new Tile(i, j);
        iterator++;
      }
    }
  }

  //------------------------------------------------------------------------------

  int getIndex(int i, int j) {//provided a unique i and j value
    int it = 0;

    for (int ip = 0; ip < size; ip++) {
      for (int jp = 0; jp < size; jp++) {
        if (grid[it].i == i && grid[it].j == j) {
          return it;//return the position of the tile with that i and j value
        }
        it++;
      }
    }

    return -1;// unless no such tile exists.
  }

  //------------------------------------------------------------------------------

  void show() {
    for (int iterator = 0; iterator < size*size; iterator++) {
      grid[iterator].show();         //initalise every tile in the grid
    }
  }//close show

  //------------------------------------------------------------------------------

  void addPiece(boolean red) {
    // min: (0,0)
    // max: (7,7)

    int i, j;
    int index = 0;
    while (!grid[index].mouseOver()) {              //increase index till weve found the right tile
      index++;
    }

    i = grid[index].i;
    j = grid[index].j;

    if (j < 7) {
      for ( int J = j; J < size; J++) {
        if (!grid[getIndex(i, J + 1)].empty || J + 1 == 7) {//if the tile below the one under investigation isnt empty
          j = J; //set j for adding tile to be current pos
          J = size; // to break loop
        }
      }
      if (grid[getIndex(i, j+1)].empty )
        j++;
    }

    grid[getIndex(i, j)].yellow(red);
  }//close add

  //------------------------------------------------------------------------------

  boolean full() {
    for (int it = 0; it < size*size; it++) {
      if (grid[it].empty)
        return false;
    }
    return true;
  }
}

void mousePressed() {
  map.addPiece(turn);
}

void keyPressed() {
  if (key == 'r')
    setup();
}
