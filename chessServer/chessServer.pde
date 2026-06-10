import processing.net.*;

Server myServer;

color lightbrown = #FFFFC3;
color darkbrown  = #D8864E;
PImage wrook, wbishop, wknight, wqueen, wking, wpawn;
PImage brook, bbishop, bknight, bqueen, bking, bpawn;
boolean firstClick;
int row1, col1, row2, col2;
boolean tactile;
boolean correctPiece;
boolean turn = true;
boolean kingMoved   = false;
boolean rookLMoved  = false;
boolean rookRMoved  = false;
boolean enPassent;

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
  size(1200, 800);
  myServer = new Server(this, 1234);
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
  correctPiece = checkPiece();
  recieveMove();
}

void recieveMove() {
  Client myClient = myServer.available();
  if (myClient != null) {
    String incoming = myClient.readString();
    int r1 = int(incoming.substring(0, 1));
    int c1 = int(incoming.substring(2, 3));
    int r2 = int(incoming.substring(4, 5));
    int c2 = int(incoming.substring(6, 7));
    char movingPiece = grid[r1][c1];
    
    for (int r = 0; r < 8; r++) {
      for (int c = 0; c < 8; c++) {
        if (grid[r][c] == 'e' || grid[r][c] == 'E') grid[r][c] = ' ';
      }
    }
    
    if (movingPiece == 'K' && r1 == 0 && c1 == 4 && c2 == 6) {
      grid[0][5] = 'R';
      grid[0][7] = ' ';
    }
    if (movingPiece == 'K' && r1 == 0 && c1 == 4 && c2 == 2) {
      grid[0][3] = 'R';
      grid[0][0] = ' ';
    }
    if (movingPiece == 'P' && r2 - r1 == 2) {
      grid[2][c1] = 'E';
    }
    if (movingPiece == 'P' && r2 - r1 == 1 && abs(c2 - c1) == 1 && grid[r2][c2] == ' ') {
      grid[r2 - 1][c2] = ' ';
    }
    
    grid[r2][c2] = grid[r1][c1];
    grid[r1][c1] = ' ';
    turn = true;
  }
}

void drawBoard() {
  for (int r = 0; r < 8; r++) {
    for (int c = 0; c < 8; c++) {
      if ((r%2) == (c%2)) {
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
      if (grid[r][c] == 'r') image(wrook, c*100, r*100, 100, 100);
      if (grid[r][c] == 'R') image(brook, c*100, r*100, 100, 100);
      if (grid[r][c] == 'b') image(wbishop, c*100, r*100, 100, 100);
      if (grid[r][c] == 'B') image(bbishop, c*100, r*100, 100, 100);
      if (grid[r][c] == 'n') image(wknight, c*100, r*100, 100, 100);
      if (grid[r][c] == 'N') image(bknight, c*100, r*100, 100, 100);
      if (grid[r][c] == 'q') image(wqueen, c*100, r*100, 100, 100);
      if (grid[r][c] == 'Q') image(bqueen, c*100, r*100, 100, 100);
      if (grid[r][c] == 'k') image(wking, c*100, r*100, 100, 100);
      if (grid[r][c] == 'K') image(bking, c*100, r*100, 100, 100);
      if (grid[r][c] == 'p') image(wpawn, c*100, r*100, 100, 100);
      if (grid[r][c] == 'P') image(bpawn, c*100, r*100, 100, 100);
    }
  }
}

void mouseReleased() {
  if (firstClick && correctPiece && turn) {
    row1 = mouseY/100;
    col1 = mouseX/100;
    if (row1 >= 0 && row1 < 8 && col1 >= 0 && col1 < 8 && grid[row1][col1] != ' ') {
      firstClick = false;
      tactile = true;
    }
  } else if (!firstClick && turn) {
    row2 = mouseY/100;
    col2 = mouseX/100;
    if (row2 >= 0 && row2 < 8 && col2 >= 0 && col2 < 8) {
      if ((row2 != row1 || col2 != col1) && isValidMove(row1, col1, row2, col2)) {
        char movingPiece = grid[row1][col1];
        
        for (int r = 0; r < 8; r++) {
          for (int c = 0; c < 8; c++) {
            if (grid[r][c] == 'e') grid[r][c] = ' ';
          }
        }
        
        if (movingPiece == 'k' && col1 == 4 && col2 == 6) {
          grid[7][5] = 'r';
          grid[7][7] = ' ';
        }
        if (movingPiece == 'k' && col1 == 4 && col2 == 2) {
          grid[7][3] = 'r';
          grid[7][0] = ' ';
        }
        if (movingPiece == 'k') kingMoved = true;
        if (movingPiece == 'r' && row1 == 7 && col1 == 0) rookLMoved = true;
        if (movingPiece == 'r' && row1 == 7 && col1 == 7) rookRMoved = true;
        
        if (movingPiece == 'p' && row1 == 6 && row1 - row2 == 2) {
          grid[5][col1] = 'e';
        }
        if (movingPiece == 'p' && grid[row2][col2] == 'E') {
          grid[row2 + 1][col2] = ' ';
        }
        
        grid[row2][col2] = grid[row1][col1];
        grid[row1][col1] = ' ';
        myServer.write(row1 + "," + col1 + "," + row2 + "," + col2);
        firstClick = true;
        tactile = false;
        turn = false;
      } else {
        firstClick = true;
        tactile = false;
      }
    }
  }
}

void tactilePiece() {
  if (tactile == true) {
    noFill();
    stroke(255, 0, 0);
    makeStrokeWeightSafe(5);
    rect(col1*100, row1*100, 100, 100);
  }
}

void makeStrokeWeightSafe(int w) {
  strokeWeight(w);
}

boolean checkPiece() {
  int r = mouseY/100;
  int c = mouseX/100;
  if (r < 0 || r >= 8 || c < 0 || c >= 8) return false;
  if (grid[r][c] == 'r' || grid[r][c] == 'b' || grid[r][c] == 'n' || grid[r][c] == 'q' || grid[r][c] == 'k' || grid[r][c] == 'p') {
    return true;
  } else {
    return false;
  }
}

boolean isValidMove(int r1, int c1, int r2, int c2) {
  char piece = grid[r1][c1];
  char target = grid[r2][c2];
  int rowDiff = abs(r2 - r1);
  int colDiff = abs(c2 - c1);
  if (target != ' ' && target != 'e' && target != 'E') {
    boolean whitePiece = Character.isLowerCase(piece);
    boolean whiteTarget = Character.isLowerCase(target);
    if (whitePiece == whiteTarget) return false;
  }
  int checkRow;
  if (r2 == r1) {
    checkRow = 0;
  } else if (r2 > r1) {
    checkRow = 1;
  } else {
    checkRow = -1;
  }
  int checkCol;
  if (c2 == c1) {
    checkCol = 0;
  } else if (c2 > c1) {
    checkCol = 1;
  } else {
    checkCol = -1;
  }
  char type = Character.toLowerCase(piece);
  if (type == 'p') {
    if (r1 - r2 == 1 && c1 == c2 && target == ' ') {
      return true;
    } else if (r1 == 6 && r1 - r2 == 2 && c1 == c2 && target == ' ') {
      return isPathClear(r1, c1, r2, c2, checkRow, checkCol);
    } else if (r1 - r2 == 1 && colDiff == 1 && (target != ' ' || target == 'E')) {
      return true;
    }
    return false;
  } else if (type == 'r') {
    if (r1 == r2 || c1 == c2) {
      return isPathClear(r1, c1, r2, c2, checkRow, checkCol);
    } else {
      return false;
    }
  } else if (type == 'b') {
    if (rowDiff != colDiff) {
      return false;
    }
    return isPathClear(r1, c1, r2, c2, checkRow, checkCol);
  } else if (type == 'q') {
    if (r1 == r2 || c1 == c2) {
      return isPathClear(r1, c1, r2, c2, checkRow, checkCol);
    }
    if (rowDiff != colDiff) {
      return false;
    }
    return isPathClear(r1, c1, r2, c2, checkRow, checkCol);
  } else if (type == 'n') {
    if ((rowDiff == 2 && colDiff == 1) || (colDiff == 2 && rowDiff == 1)) {
      return true;
    } else {
      return false;
    }
  } else if (type == 'k') {
    if ((rowDiff == 1 && colDiff == 1) || (rowDiff + colDiff == 1)) {
      return true;
    }
    if (!kingMoved && r1 == 7 && c1 == 4 && r2 == 7) {
      if (c2 == 6 && !rookRMoved) {
        return isPathClear(7, 4, 7, 7, 0, 1);
      }
      if (c2 == 2 && !rookLMoved) {
        return isPathClear(7, 4, 7, 0, 0, -1);
      }
    }
    return false;
  } else {
    return false;
  }
}

boolean isPathClear(int r1, int c1, int r2, int c2, int checkRow, int checkCol) {
  int currR = r1 + checkRow;
  int currC = c1 + checkCol;
  while (currR != r2 || currC != c2) {
    if (grid[currR][currC] != ' ' && grid[currR][currC] != 'e' && grid[currR][currC] != 'E') return false;
    currR += checkRow;
    currC += checkCol;
  }
  return true;
}
