boolean leftPressed;
boolean rightPressed;
boolean upPressed;
boolean downPressed;
float[] xDotPrev;
float[] yDotPrev;
color backgroundColor;
float xPredictR;
float xPredictL;
float yPredictT;
float yPredictB;
PImage background;
int yInt;
int xInt;
boolean moved;
boolean flip;

Player player;

float[] xDot;
float[] yDot;

boolean jumpAvalible;
int tick;

void setup() {
  tick=0;
  backgroundColor=-1;
  background=loadImage("img/Backgrounds/background1.png");
  pixelDensity(1);
  xDot=new float[144];
  yDot=new float[144];
  xDotPrev=new float[144];
  yDotPrev=new float[144];
  player= new Player(0, 0, 10, 14, 10, 6);
  player.loadAllImages();
  player.shadowArray=new PImage[143];
  frameRate(48);
  fullScreen();
}

void draw() {
  drawBackground();
  player.engine();
  player.displayPlayer();
  drawArrowen();
  text(player.yAccel, width/2+200, height/2+20);
}

void mousePressed() {
  flip=true;
}

void mouseReleased() {
  flip=false;
  player.swapPos();
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
    player.playerAY();
    flip =true;
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
    flip =false;
  }
  if (keyCode == DOWN) {
    downPressed = false;
  }
}

void drawBackground(){
   image(background,-10,-50);
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
