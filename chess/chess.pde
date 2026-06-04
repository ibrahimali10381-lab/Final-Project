color lightbrown = #FFFFC3;
color darkbrown  = #D8864E;
PImage wrook, wbishop, wknight, wqueen, wking, wpawn;
PImage brook, bbishop, bknight, bqueen, bking, bpawn;
boolean firstClick;
int row1, col1, row2, col2;
boolean tactile;


char grid[][] = {
  {'R', 'N', 'B', 'Q', 'K', 'B', 'N', 'R'},
  {'P', 'P', 'P', 'P', 'P', 'P', 'P', 'P'},
  {' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '},
  {' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '},
  {' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '},
  {' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '},
  {'p', 'p', 'p', 'p', 'p', 'p', 'p', 'p'},
  {'r', 'n', 'b', 'q', 'k', 'b', 'n', 'r'}
};

void setup() {
  size(800, 800);

  firstClick = true;

  brook = loadImage("blackRook.png");
  bbishop = loadImage("blackBishop.png");
  bknight = loadImage("blackKnight.png");
  bqueen = loadImage("blackQueen.png");
  bking = loadImage("blackKing.png");
  bpawn = loadImage("blackPawn.png");

  wrook = loadImage("whiteRook.png");
  wbishop = loadImage("whiteBishop.png");
  wknight = loadImage("whiteKnight.png");
  wqueen = loadImage("whiteQueen.png");
  wking = loadImage("whiteKing.png");
  wpawn = loadImage("whitePawn.png");
}

void draw() {
  stroke(0);
  strokeWeight(0);

  drawBoard();
  drawPieces();
}

void drawBoard() {
  for (int r = 0; r < 8; r++) {
    for (int c = 0; c < 8; c++) {
      if ( (r%2) == (c%2) ) {
        fill(lightbrown);
      } else {
        fill(darkbrown);
      }
      rect(c*100, r*100, 100, 100);
    }
  }
}

void drawPieces() {
  tactilePiece();
  for (int r = 0; r < 8; r++) {
    for (int c = 0; c < 8; c++) {
      if (grid[r][c] == 'r') image (wrook, c*100, r*100, 100, 100);
      if (grid[r][c] == 'R') image (brook, c*100, r*100, 100, 100);
      if (grid[r][c] == 'b') image (wbishop, c*100, r*100, 100, 100);
      if (grid[r][c] == 'B') image (bbishop, c*100, r*100, 100, 100);
      if (grid[r][c] == 'n') image (wknight, c*100, r*100, 100, 100);
      if (grid[r][c] == 'N') image (bknight, c*100, r*100, 100, 100);
      if (grid[r][c] == 'q') image (wqueen, c*100, r*100, 100, 100);
      if (grid[r][c] == 'Q') image (bqueen, c*100, r*100, 100, 100);
      if (grid[r][c] == 'k') image (wking, c*100, r*100, 100, 100);
      if (grid[r][c] == 'K') image (bking, c*100, r*100, 100, 100);
      if (grid[r][c] == 'p') image (wpawn, c*100, r*100, 100, 100);
      if (grid[r][c] == 'P') image (bpawn, c*100, r*100, 100, 100);
    }
  }
}

void mouseReleased() {
  if (firstClick) {
    row1 = mouseY/100;
    col1 = mouseX/100;
    firstClick = false;
    tactile = true;
  } else {
    row2 = mouseY/100;
    col2 = mouseX/100;
    if (!(row2 == row1 && col2 == col1)) {
      grid[row2][col2] = grid[row1][col1];
      grid[row1][col1] = ' ';
      firstClick = true;
      tactile = false;
    }
  }
}

void tactilePiece() {
  if (tactile == true) {
    noFill();
    stroke(255, 0, 0);
    strokeWeight(5);
    rect(col1*100, row1*100, 100, 100);
  }
}
