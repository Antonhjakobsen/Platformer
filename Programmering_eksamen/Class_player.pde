class Player {
  float x1;
  float y1;
  float xAccel;
  float yAccel;
  float accelerationLimit = 10;
  float friction = 0.60;

  int idlenumFrames;  // The number of frames in the animation
  int idlecurrentFrame;
  PImage[] idle;

  int fallnumFrames;  // The number of frames in the animation
  int fallcurrentFrame;
  PImage[] fall;

  int runnumFrames;  // The number of frames in the animation
  int runcurrentFrame;
  PImage[] run;

  Player(float x1, float y1, int idlenumFrames, int fallnumFrames, int runnumFrames) {
    this.x1=x1;
    this.y1=y1;

    this.idlenumFrames=idlenumFrames;
    this.idlecurrentFrame=0;

    this.fallnumFrames=fallnumFrames;
    this.fallcurrentFrame=0;

    this.runnumFrames=runnumFrames;
    this.fallcurrentFrame=0;
  }

  void loadDesign() {
    design=loadImage("img/Character/individual_sheets/design.png");
  }

  void loadIdle() {
    idle = new PImage[idlenumFrames];
    for (int i=0; i<idlenumFrames; i++) {
      idle[i]=loadImage("img/Character/individual_sheets/idle/"+i+".gif");
    }
  }

  void loadFall() {
    fall = new PImage[fallnumFrames];
    for (int i=0; i<fallnumFrames; i++) {
      fall[i]=loadImage("img/Character/individual_sheets/fall/"+i+".gif");
    }
  }

  void loadRun() {
    run = new PImage[runnumFrames];
    for (int i=0; i<runnumFrames; i++) {
      run[i]=loadImage("img/Character/individual_sheets/run/"+i+".gif");
    }
  }

  void idleAnimation() {
    idlecurrentFrame = (idlecurrentFrame+1) % idlenumFrames;  // Use % to cycle through frames
    int offset = width/2;
    for (int i = 0; i < width; i += width) {
      image(idle[(idlecurrentFrame+offset) % idlenumFrames], x1, y1);
    }
  }
  void fallAnimation() {
    fallcurrentFrame = (fallcurrentFrame+1) % fallnumFrames;  // Use % to cycle through frames
    int offset = width/2;
    for (int i = 0; i < width; i += width) {
      image(fall[(fallcurrentFrame+offset) % fallnumFrames], x1, y1);
    }
  }

  void runAnimation() {
    runcurrentFrame = (runcurrentFrame+1) % runnumFrames;  // Use % to cycle through frames
    int offset = width/2;
    for (int i = 0; i < width; i += width) {
      image(run[(runcurrentFrame+offset) % runnumFrames], x1, y1);
    }
  }

  void playerAX() { // Player Axis X acceleration
    if (keyPressed==true&&leftPressed==true&&xAccel>-accelerationLimit) {//left
      xAccel-=2;
    } else if (leftPressed==false&&xAccel<0) {
      xAccel=xAccel*friction;
    }
    if (keyPressed==true&&rightPressed==true&&xAccel<accelerationLimit) {//right
      xAccel+=2;
    } else if (rightPressed==false&&xAccel>0) {
      xAccel=xAccel*friction;
    }

    //Brake with down arrow
    if (keyPressed==true&&downPressed==true) {//brake
      xAccel=xAccel*friction;
    }
  }

  // Player Axis Y Acceleration
  void playerAY() {
    if (keyPressed==true&&upPressed==true&&y1>height/1.2) {
      yAccel-=25;
    }
  }

  void grav() {
    if (y1<height/1.2) {
      yAccel+=1;
    }
  }

  void displayPlayer() {
      if (xAccel<0&&xAccel>-1) {//Left
        pushMatrix();
        translate(idle[idlecurrentFrame].width+x1*2, 0);
        scale(-1, 1);
        player.idleAnimation();
        popMatrix();
        text("Left", width/2, height/1.5);
      } else if (xAccel>=0&&xAccel<1) {//Right
        pushMatrix();
        scale(1, 1);
        player.idleAnimation();
        popMatrix();
        text("Right", width/2, height/1.5);
      }
      else if (xAccel<0&&yAccel!=0) {
      pushMatrix();
      translate(fall[fallcurrentFrame].width+x1*2, 0);
      scale(-1, 1);
      player.fallAnimation();
      popMatrix();
      print("fall ");
    } else if (yAccel!=0) {
      player.fallAnimation();
      print("fall ");
    } else if (xAccel<1) {
      pushMatrix();
      translate(fall[fallcurrentFrame].width+x1*2, 0);
      scale(-1, 1);
      player.runAnimation();
      popMatrix();
      print("running ");
    } else {
      player.runAnimation();
      print("running 2 ");
    }
  }

  void movePlayer() {
    x1+=xAccel;
    y1+=yAccel;
  }

  void loadAllImages() {
    loadDesign();
    loadIdle();
    loadFall();
    loadRun();
  }

  void collision() {
    if (y1>=height/1.2&&yAccel>=0) {
      yAccel=0;
      y1=height/1.2+1;
    }
  }

  void engine() {
    collision();
    grav();
    playerAX();
    playerAY();
    movePlayer();
    displayPlayer();
    fill(255);
    text(x1, width/2, height/2);
    text(xAccel, width/2+200, height/2);
    text(yAccel, width/2+200, height/2+20);
    fill(0);
  }
}