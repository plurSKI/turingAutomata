int individualsX = 8; // How many automata across
int individualsY = 8; // How many automata down
int pixelSize = 5;

// Colors to represent the symbols
int[] colorsR = { 255, 0, 0, 255 };
int[] colorsG = { 0, 255, 0, 255 };
int[] colorsB = { 0, 0, 255, 255 };

int symbols = 4;
int states = symbols * symbols;
int horizontalLen = states * individualsX;
int verticalLen = states * individualsX;


//  Layout of an individual turing machine
// 0   |  1     |   2      |  3
// DIR | SYMBOL | STATE_A  | STATE_B

int[][] indX = new int[individualsX][individualsY];
int[][] indY = new int[individualsX][individualsY];
int[][] indState = new int[individualsX][individualsY];

int[][] grid = new int[horizontalLen][verticalLen];

void setup()
{
  size(horizontalLen*pixelSize, verticalLen*pixelSize, P2D);
  frameRate(30);
  //noLoop();
  background(0);
  
  // Randomly set a starting symbol state
  for(int i = 0; i < horizontalLen; i ++)
  {
    for( int j = 0; j < verticalLen; j ++)
    {
      grid[i][j] = int(random(symbols));
    }
  }

  // Randomly set positions for individuals
  for(int i = 0; i < individualsX; i ++)
  {
    for( int j = 0; j < individualsY; j ++)
    {
      indX[i][j] = int(random(horizontalLen));
      indY[i][j] = int(random(verticalLen));
      indState[i][j] = int(random(states));
    }
  }
  
  
}

void draw()
{
  background(0);

  // Draw the pixels
  for(int i = 0; i < horizontalLen; i ++)
  {
    for( int j = 0; j < verticalLen; j ++)
    {
      int curVal = grid[i][j];
      stroke(0);
      fill( colorsR[curVal], colorsG[curVal], colorsB[curVal]);
      rect(i * pixelSize, j * pixelSize, pixelSize, pixelSize);
    }
  }  

  // Evaluate each individual
  for(int i = 0; i < individualsX; i ++)
  {
    for( int j = 0; j < individualsY; j ++)
    {
      int cX = indX[i][j];
      int cY = indY[i][j];
      int cState = indState[i][j];
      int cSym = grid[ cX ][ cY ]; 
      int xLookup = i * states + 4 * cSym;
      int yLookup = j * states + cState;
      
      //println("(" + cX + "," + cY + ") -- " + cState + " " + cSym);
      // Write the symbol and change the state
      grid[ cX ] [ cY ] = grid [xLookup + 1][ yLookup ];
      indState[i][j] = symbols * (grid [xLookup + 2][ yLookup ]) + grid [xLookup + 3][ yLookup ];
      
      // Move to new location
      switch(grid [xLookup][yLookup])
      {
        case 0: // Move up
          if( --cY < 0 ) cY = verticalLen - 1;
          break;
        case 1: // Move down
          if( ++cY >= verticalLen ) cY = 0;
          break;
        case 2: // Move left
          if( --cX < 0 ) cX = horizontalLen - 1;
          break;
        case 3: // Move right
          if( ++cX >= horizontalLen ) cX = 0;
          break;
        default:
          println("Unknown direction");
      }
      indX[i][j] = cX;
      indY[i][j] = cY;
    }
  }
}

void mousePressed()
{
  redraw();
}

