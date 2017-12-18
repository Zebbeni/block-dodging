import gab.opencv.*;
import processing.video.*;
import java.awt.Rectangle;

Capture video;
OpenCV opencv;
PImage src, colorFilteredImage;
ArrayList<Contour> contours;

float BODY_IMG_HW_RATIO = 2.3182;
PShape bodyImage;
int timeToCapture = 300;
int[] faceHues = new int[5];
int prevFaceX = 0;
int prevFaceY = 0;
int faceX = 0;
int faceY = 0;
int hueTolerance = 2;

class Rectangle {
  int x, y, w, h;
  Rectangle(int x, int y, int w, int h) {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
  }
}

void initializeCaptureScreen() {
  video = new Capture(this, int(height * 1.3333), height);
  video.start();
  
  opencv = new OpenCV(this, video.width, video.height);
  contours = new ArrayList<Contour>();
  bodyImage = loadShape("bodyImage3.svg");
}

void captureFace() {    
    // Read last captured frame
  if (video.available()) {
    video.read();
  }
  // <2> Load the new frame of our movie in to OpenCV
  opencv.loadImage(video);
  
  // Tell OpenCV to use color information
  opencv.useColor();
  src = opencv.getSnapshot();
  // <8> Display background images
  image(src, 0, 0, width, height);
  //image(colorFilteredImage, src.width, 0);

  if (faceHues[0] > 0) {
    // <3> Tell OpenCV to work in HSV color space.
    opencv.useColor(HSB);
    
    // <4> Copy the Hue channel of our image into 
    //     the gray channel, which we process.
    opencv.setGray(opencv.getH().clone());
    
    // <5> Filter the image based on the range of 
    //     hue values that match the object we want to track.
    opencv.inRange(faceHues[0] - hueTolerance, faceHues[0] + hueTolerance);
    
    // <6> Get the processed image for reference.
    colorFilteredImage = opencv.getSnapshot();
    
    ///////////////////////////////////////////
    // We could process our image here!
    // See ImageFiltering.pde
    ///////////////////////////////////////////
    
    // <7> Find contours in our range image.
    //     Passing 'true' sorts them by descending area.
    contours = opencv.findContours(true, true);
    
    // <9> Check to make sure we've found any contours
    if (contours.size() > 0) {
      // <9> Get the first contour, which will be the largest one
      Contour biggestContour = contours.get(0);
      
      // <10> Find the bounding box of the largest contour,
      //      and hence our object.
      Rectangle r = biggestContour.getBoundingBox();
      
      // <11> Draw the bounding box of our object
      noFill(); 
      strokeWeight(2); 
      stroke(255, 0, 0);
      rect(r.x, r.y, r.width, r.height);
      
      // <12> Draw a dot in the middle of the bounding box, on the object.
      noStroke(); 
      fill(255, 0, 0);
      ellipse(r.x + r.width/2, r.y + r.height/2, 30, 30);
    }
  }
    
  int imgHeight = int(height * 1.2);
  int imgWidth = int(imgHeight / BODY_IMG_HW_RATIO);
  int imgX = (width / 2) - (imgWidth / 2);
  int imgY = int(height * 0.1);
  noFill();
  stroke(255,255,255,200);
  faceX = imgX + int(imgWidth * 0.5);
  faceY = imgY + int(imgHeight * (0.07));
  bodyImage.disableStyle();
  shape(bodyImage, imgX, imgY, imgWidth, imgHeight);
  int secondsLeft = int(timeToCapture / 60);
  timeToCapture--;
  String message = "Player 1 stand in frame. " + secondsLeft + "...";
  fill(255,255,255,200);
  textSize(25);
  text(message, 20, (height / 2) - 15);
  if (timeToCapture == 0) {
    captureFaceHues();
    //shouldCaptureFace = false;
    //shouldRunGame = true;
  }
}

void captureFaceHues() {
  int dist = int(height * 0.02);
  faceHues[0] = getHue(faceX, faceY);
  faceHues[1] = getHue(faceX - dist, faceY - dist);
  faceHues[2] = getHue(faceX + dist, faceY - dist);
  faceHues[3] = getHue(faceX + dist, faceY + dist);
  faceHues[4] = getHue(faceX + dist, faceY - dist);
}

int getHue(int x, int y) {
  color c = get(x, y);
  return int(map(hue(c), 0, 255, 0, 180));
}