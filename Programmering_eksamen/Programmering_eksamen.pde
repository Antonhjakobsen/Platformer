PImage design;

boolean leftPressed;
boolean rightPressed;
boolean upPressed;
boolean downPressed;

boolean flip;

Player player;

void setup() {
  pixelDensity(1);
  player= new Player(0,0,10,14);
  player.loadAllImages();
  frameRate(48);
  fullScreen();
}

void draw() {
  background(55);
  player.engine();
  drawArrowen();
}

void mousePressed() {
  flip=true;
}

void mouseReleased() {
  flip=false;
}

void keyPressed() {
  if (keyCode == LEFT) {
    leftPressed = true;
  }
  if (keyCode == RIGHT) {
    rightPressed = true;
  }
  if (keyCode == UP) {
    upPressed = true;
  }
  if (keyCode == DOWN) {
    downPressed = true;
  }
}

void keyReleased() {
  if (keyCode == LEFT) {
    leftPressed = false;
  }
  if (keyCode == RIGHT) {
    rightPressed = false;
  }
  if (keyCode == UP) {
    upPressed = false;
  }
  if (keyCode == DOWN) {
    downPressed = false;
  }
}

void drawArrowen() {
  int padding = 15;
  int middle = 225;
  int lineL = 30;
  int boxSize = lineL+padding;
  int baseHeight = 130;
  strokeWeight(2);
  stroke(55);
  fill(255);

  if (leftPressed==true) {
    fill(155);
  }
  square(middle-boxSize*2, baseHeight, boxSize);
  fill(255);
  drawArrow(middle-boxSize-padding/2, 150, lineL, 179.5);//left^


  if (upPressed==true) {
    fill(155);
  }
  square(middle-boxSize/2, baseHeight-boxSize-padding, boxSize);
  fill(255);
  drawArrow(middle+1, baseHeight-padding-padding/2, lineL, 270);//^up



  if (rightPressed==true) {
    fill(155);
  }
  square(middle+boxSize+padding/2, baseHeight, boxSize);
  fill(255);
  drawArrow(middle+boxSize+padding, baseHeight+boxSize/2, lineL, 0);//right^


  if (downPressed==true) {
    fill(155);
  }
  square(205, baseHeight, boxSize);
  fill(255);
  drawArrow(middle+1, 135+padding-padding+padding/4, lineL, 89.75);//^down

  stroke(0);
  strokeWeight(1);
  fill(0);
}

void drawArrow(int cx, int cy, int len, float angle) {
  pushMatrix();
  translate(cx, cy);
  rotate(radians(angle));
  line(0, 0, len, 0);
  line(len, 0, len - 8, -8);
  line(len, 0, len - 8, 8);
  popMatrix();
}
