// <1> Set the range of Hue values for our filter
int prevX = -1;
int prevY = -1;

float eyeX = 0, eyeY = 0, eyeZ = 1.0;
float centerX = 0, centerY = 0, centerZ = 0;
float upX = 0, upY = 1, upZ = 0;
int BOX_W = 100, BOX_H = 100, BOX_D = 25;
int PLAYER_W = 50, PLAYER_H = 100, PLAYER_D = 25;
int NUM_BOXES = 500;
int DEPTH_TO_APPEAR = -20000;
int DEPTH_TO_DISAPPEAR = 100; 
float MIN_GAP = 500;
float MAX_GAP = 1000;
float LEADING_GAP = 100;
float gameSpeed = 2.0;

float playerX = 0;
Box[] boxes = new Box[NUM_BOXES];
boolean shouldCaptureFace = true;
boolean shouldRunGame = false;

class Box {
  int x, z; 
  Box (int xpos, int zpos) {  
    x = xpos;
    z = zpos;
  } 
  void update() { 
    z += gameSpeed; 
  }
  void render() {
    camera(eyeX, eyeY, eyeZ, centerX, centerY, centerZ, upX, upY, upZ);
    translate(x - playerX, 75, z);
    fill(255, 255, 100, 255);
    box(BOX_W, BOX_H, BOX_D);
    for(int i = 1; i < 8; i++) {
      camera(eyeX, eyeY, eyeZ, centerX, centerY, centerZ, upX, upY, upZ);
      translate(x - playerX, 125, z + (LEADING_GAP * i));
      fill(255, 255, 100, 100 - i * 10);
      box(BOX_W, 1, 70 / i);
    }
  }
}

void setup() {
  fullScreen(P3D);
  
  background(255,255,255);
  smooth();
  noStroke();
  initializeBoxes();
  initializeCaptureScreen();
}

void draw() {
  if (shouldCaptureFace) {
    captureFace();
  }
  if (shouldRunGame) {
    renderLevel();
  }
}