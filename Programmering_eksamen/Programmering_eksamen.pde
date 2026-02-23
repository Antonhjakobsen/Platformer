PImage design;

boolean flip;

int fallnumFrames = 14;  // The number of frames in the animation
int fallcurrentFrame = 0;
PImage[] fall;

int idlenumFrames = 10;  // The number of frames in the animation
int idlecurrentFrame = 0;
PImage[] idle;

void setup() {
  
  design=loadImage("img/Character/individual_sheets/design.png");
  fall = new PImage[fallnumFrames];
  for (int i=0; i<14; i++) {
    fall[i]=loadImage("img/Character/individual_sheets/Fall/"+i+".gif");
  }
  
  idle = new PImage[idlenumFrames];
  for (int i=0; i<10; i++) {
    idle[i]=loadImage("img/Character/individual_sheets/idle/"+i+".gif");
  }
  
  frameRate(24);
  fullScreen();
}

void draw() {
  background(0);
  if(flip==false){
  idleAnimation();
  } else{
   fallAnimation(); 
  }
}

void mousePressed() {
  flip=true;
}

void mouseReleased() {
  flip=false;
}

void fallAnimation() {
  fallcurrentFrame = (fallcurrentFrame+1) % fallnumFrames;  // Use % to cycle through frames
  int offset = width/2;
  for (int i = 0; i < width; i += width) {
    image(fall[(fallcurrentFrame+offset) % fallnumFrames], i, height/2-design.height/2);
  }
}

void idleAnimation() {
  idlecurrentFrame = (idlecurrentFrame+1) % idlenumFrames;  // Use % to cycle through frames
  int offset = width/2;
  for (int i = 0; i < width; i += width) {
    image(idle[(idlecurrentFrame+offset) % idlenumFrames], i, height/2-design.height/2);
  }
}
