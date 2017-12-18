void initializeLevel() {
  initializeBoxes();
}

void renderLevel() {
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