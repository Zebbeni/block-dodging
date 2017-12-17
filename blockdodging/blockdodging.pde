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

float BODY_IMG_HW_RATIO = 2.3182;
PShape bodyImage;
int timeToCapture = 300;

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
    //translate(0, 50, 0);
    for(int i = 1; i < 8; i++) {
      camera(eyeX, eyeY, eyeZ, centerX, centerY, centerZ, upX, upY, upZ);
      translate(x - playerX, 125, z + (LEADING_GAP * i));
      fill(255, 255, 100, 100 - i * 10);
      box(BOX_W, 1, 70 / i);
    }
  }
}

void setup() {
  frameRate(30);
  background(255,255,255);
  size(1200, 800, P3D);
  smooth();
  noStroke();
  initializeBoxes();
  bodyImage = loadShape("bodyImage3.svg");
}

void draw() {
  if (shouldCaptureFace) {
    drawFaceCaptureScreen();
  }
  if (shouldRunGame) {
    if (keyPressed) {
      if (key == CODED) {
        if (keyCode == RIGHT) {
          playerX += 5;
        }
        if (keyCode == LEFT) {
          playerX -= 5;
        } 
      }
    }
    gameSpeed += 0.01;
    beginCamera();
    directionalLight(255, 255, 255, 1, 4, -2);
    spotLight(255, 1000, 0, width/2, height/2, 400, 0, 0, -1, PI/4, 2);
    background(0);
    drawBoxes();
    drawPlayer();
    endCamera();
  }
}

void initializeBoxes() {
  int prev_lane = 1;
  int depth_to_start = 0;
  for (int i = 0; i < NUM_BOXES; i++) {
    int lane = prev_lane;
    lane += random(1) > 0.5 ? 1 : -1;
    lane = abs(lane) % 3;
    prev_lane = lane;
    boxes[i] = new Box((lane - 1) * (BOX_W + 5), depth_to_start);
    depth_to_start -= MIN_GAP + round(random((MAX_GAP - MIN_GAP)));
  }
}

void drawBoxes() {
  for (int i = NUM_BOXES - 1; i >= 0; i--) {
    boxes[i].update();
    Box box = boxes[i];
    if (box.z > DEPTH_TO_APPEAR && box.z < DEPTH_TO_DISAPPEAR) {
      box.render();
    }
  }
}

void drawPlayer() {
    camera(eyeX, eyeY, eyeZ, centerX, centerY, centerZ, upX, upY, upZ);
    translate(0, 75, -100);
    fill(155, 150, 255, 200);
    box(PLAYER_W, PLAYER_H, PLAYER_D);
}

void drawFaceCaptureScreen() {
    fill(0, 0, 0);
    rect(0, 0, width, height);
    int imgHeight = int(height * 0.9);
    int imgWidth = int(imgHeight / BODY_IMG_HW_RATIO);
    int imgX = (width / 2) - (imgWidth / 2);
    int imgY = (height / 2) - (imgHeight / 2);
    noFill();
    stroke(255,255,255,100);
    for (int i = 0; i < 4; i++) {
      int faceX = imgX + int(imgWidth * 0.5);
      int faceY = imgY + int(imgHeight * (0.05 + 0.01 * i));
      ellipse(faceX, faceY, 2, 2);
    }
    bodyImage.disableStyle();
    shape(bodyImage, imgX, imgY, imgWidth, imgHeight);
    int secondsLeft = int(timeToCapture / 30);
    timeToCapture--;
    String message = "Player 1 stand in frame. " + secondsLeft + "...";
    fill(255,255,255,100);
    textSize(32);
    text(message, 10, 30);
    if (timeToCapture <= 0) {
      captureFace();
    }
}

void captureFace() {
  
}