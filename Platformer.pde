import processing.sound.*;
SoundFile Switch;
SoundFile BGmusic;
SoundFile Jump;
boolean held=false;
boolean leftPressed;
boolean rightPressed;
boolean upPressed;
boolean downPressed;
boolean backspacePressed;
boolean swapPosFlip2;
int[] xDotPrev;
int[] yDotPrev;
color backgroundColor;
int xPredictR;
int xPredictL;
int yPredictT;
int yPredictB;
PImage background;
int yInt;
int xInt;
boolean moved;
boolean flip;

Player player;

int[] xDot;
int[] yDot;

boolean jumpAvalible;
int tick;

void setup() {
  tick=0;
  background=loadImage("img/Backgrounds/level_map.jpg");
  background.loadPixels();

  Switch = new SoundFile(this, "Sound/TPSound2.wav");
  BGmusic = new SoundFile(this, "Sound/BGmusic.wav");
  Jump = new SoundFile(this, "Sound/Jump.wav");

  BGmusic.loop();
  BGmusic.amp(0.05);
  Jump.play(1, 0.1);

  pixelDensity(1);
  xDot=new int[144];
  yDot=new int[144];
  xDotPrev=new int[144];
  yDotPrev=new int[144];
  player= new Player(20, background.height-350, 10, 14, 10, 6);
  backgroundColor=getPixelSafe(player.x,player.y);
  player.loadAllImages();
  player.shadowArray=new PImage[143];
  frameRate(48);
  fullScreen();
}

void draw() {
  background(0);
  pushMatrix();
  translate(width/2 - player.x, height/2 - player.y);
  drawBackground();
  player.engine();
  player.displayPlayer();
  popMatrix();
  //drawArrowen();
  //text(player.yAccel, width/2+200, height/2+20);
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
    flip = true;
  }
  if (keyCode == DOWN) {
    downPressed = true;
  }
  if (keyCode==BACKSPACE) {
    backspacePressed=true;
    //print("backspacePressed");
    //print(backspacePressed);
  } else {
    backspacePressed=false;
  }
  if (keyCode == BACKSPACE && !held) {
    held=true;
  }
  /* Denne sektion er til test
  if(keyCode==TAB){
   print(" frameCount: " + frameCount);
   print(" x: " + player.x);
   print(" y: " + player.y);
  }
  */
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
    if (swapPosFlip2==true) {
      downPressed = false;
      swapPosFlip2=false;
    }
  }
  if (keyCode == BACKSPACE) {
    if (swapPosFlip2==false) {
      swapPosFlip2=true;
    }
    held=false;
  }
}

color getPixelSafe(int x, int y) {
  x = constrain(x, 0, background.width - 1);
  y = constrain(y, 0, background.height - 1);
  return background.pixels[y * background.width + x];
}

void drawBackground() {
  image(background, 0, 0);
}
