class Player {
  int x;
  int y;
  int xAccel;
  int yAccel;
  float accelerationLimit = 10;
  int friction = 1;
  int enff;
  int xPosPoint1;
  int xPosPoint2;
  int yPosPoint1;
  int yPosPoint2;
  boolean swapPosFlip=true;
  float swapPosTimer;
  int xDotLast;
  int yDotLast;
  int yPredictTInt;
  int yPredictBInt;
  int xPredictRInt;
  int xPredictLInt;

  int animationIndex; //idle=0, fall=1, run=2, jump=3

  int idlenumFrames;  // The number of frames in the animation
  int idlecurrentFrame;
  PImage[] idle;

  int fallnumFrames;  // The number of frames in the animation
  int fallcurrentFrame;
  PImage[] fall;

  int runnumFrames;  // The number of frames in the animation
  int runcurrentFrame;
  PImage[] run;

  int jumpnumFrames;  // The number of frames in the animation
  int jumpcurrentFrame;
  PImage[] jump;

  PImage[] shadowArray;

  PImage frame;

  Player(int x, int y, int idlenumFrames, int fallnumFrames, int runnumFrames, int jumpnumFrames) {
    this.x=x;
    this.y=y;

    this.idlenumFrames=idlenumFrames;
    this.idlecurrentFrame=0;

    this.fallnumFrames=fallnumFrames;
    this.fallcurrentFrame=0;

    this.runnumFrames=runnumFrames;
    this.fallcurrentFrame=0;

    this.jumpnumFrames=jumpnumFrames;
    this.jumpcurrentFrame=0;
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

  void loadJump() {
    jump = new PImage[jumpnumFrames];
    for (int i=0; i<jumpnumFrames; i++) {
      jump[i]=loadImage("img/Character/individual_sheets/jump/"+i+".gif");
    }
  }

  void idleAnimation() {
    idlecurrentFrame = (idlecurrentFrame+1) % idlenumFrames;  // Use % to cycle through frames
    frame=idle[idlecurrentFrame];
  }
  void fallAnimation() {
    fallcurrentFrame = (fallcurrentFrame+1) % fallnumFrames;  // Use % to cycle through frames
    frame=fall[fallcurrentFrame];
  }

  void runAnimation() {
    runcurrentFrame = (runcurrentFrame+1) % runnumFrames;  // Use % to cycle through frames
    frame=run[runcurrentFrame];
  }

  void jumpAnimation() {
    jumpcurrentFrame = (jumpcurrentFrame+1) % jumpnumFrames;
    frame=jump[jumpcurrentFrame];
  }

  void playerAX() { // Player Axis X acceleration
    if (keyPressed==true&&leftPressed==true&&xAccel>-accelerationLimit) {//left
      xAccel-=2;
    } else if (leftPressed==false&&xAccel<0) {
      xAccel=xAccel+friction;
    }
    if (keyPressed==true&&rightPressed==true&&xAccel<accelerationLimit) {//right
      xAccel+=2;
    } else if (rightPressed==false&&xAccel>0) {
      xAccel=xAccel-friction;
    }

    //Brake with down arrow
    if (keyPressed==true&&downPressed==true) {//brake
      xAccel=xAccel-friction;
    }
  }

  // Player Axis Y Acceleration
  void playerAY() {
    if (tick==2) {
      jumpAvalible=false;
    }
    if (keyPressed==true&&upPressed==true&&jumpAvalible==true&&flip==false) {
      yAccel=0;
      yAccel-=20;
      if (yAccel<-20) {
        yAccel=-20;
      }
      tick++;
    }
  }

  void displayPlayer() {
    if (yAccel!=0) {//vælger først animation
      if (yAccel>0) {
        fallAnimation();
      } else {
        jumpAnimation();
      }
    } else if (xAccel==0) {
      idleAnimation();
    } else {
      runAnimation();
    }
    if (xAccel < 0) {//vælger enten at flip eller at ikke flip
      pushMatrix();
      translate(x + frame.width/2, y);
      scale(-1, 1);
      image(frame, -frame.width/2, 0);
      popMatrix();
    } else {
      image(frame, x, y);
    }
  }


  void loadAllImages() {
    loadIdle();
    loadFall();
    loadRun();
    loadJump();
  }

  void drawBez() {
    strokeWeight(1);
    stroke(60, 120, 255);
    if (enff==143) {
      if (frameCount>swapPosTimer+144) {
        image(idle[0], xDot[0], yDot[0]);//tegner skyggen
      }
      enff=0;
      if (frameCount<swapPosTimer+144) {
        image(idle[0], xDot[0], yDot[0]);
      }
    } else {
      if (frameCount>swapPosTimer+144) {
        image(idle[0], xDot[enff+1], yDot[enff+1]);//tegner skyggen
      }
      enff++;
      if (frameCount<swapPosTimer+144) {
        image(idle[0], xDot[enff], yDot[enff]);
      }
    }
    xDot[enff]=x;
    yDot[enff]=y;
    //enff er indekset for den værdi som mest nyligt blev opbevaret
    if (millis()>100) {
      for (int i=0; i<143; i++) {
        if (enff!=0) {
          xDot[enff-1]=xDot[enff];
        } else {
          xDotLast=xDot[143];
        }
        if (i>0) {
          xDotPrev[i]=xDot[i-1];
          yDotPrev[i]=yDot[i-1];
        } else {
          xDotPrev[i]=xDot[0];
          yDotPrev[i]=yDot[0];
        }

        fill(255);
        int xC=idle[1].width/2;
        int yC=idle[1].height/2;
        xPosPoint1 = xDot[i]+xC;
        xPosPoint2 = xDotPrev[i]+xC;
        yPosPoint1 = yDot[i]+yC;
        yPosPoint2 = yDotPrev[i]+yC;
        float offShootXP1=xPosPoint1+random(-3, 3);
        float offShootXP2=xPosPoint2+random(-3, 3);
        float offShootYP1=yPosPoint1+random(-3, 3);
        float offShootYP2=yPosPoint2+random(-3, 3);

        if (i!=143) {
          xDotLast=xDot[i+1];
          yDotLast=yDot[i+1];
        } else {
          xDotLast=xDot[0];
          yDotLast=yDot[0];
        }

        noFill();
        if (i-1==enff) {
          bezier(xDot[143]+xC, yDot[143]+yC, xDot[143]+xC+random(-3, 3), yDot[143]+yC+random(-3, 3), xDot[142]+xC+random(-3, 3), yDot[142]+yC+random(-3, 3), xDot[142]+xC, yDot[142]+yC);
          bezier(xDot[0]+xC, yDot[0]+yC, xDot[0]+xC+random(-3, 3), yDot[0]+yC+random(-3, 3), xDot[143]+xC+random(-3, 3), yDot[143]+yC+random(-3, 3), xDot[143]+xC, yDot[143]+yC);
        } else {
          bezier(xPosPoint1, yPosPoint1, offShootXP1, offShootYP1, offShootXP2, offShootYP2, xPosPoint2, yPosPoint2);
        }
        //eksempel på bez kurve connect fra last til first bezier(xDot[1]+xC, yDot[1]+yC, xDot[1]+xC+random(-5,5), yDot[1]+yC+random(-5,5), xDot[0]+xC+random(-5,5), yDot[0]+yC+random(-5,5), xDot[0]+xC, yDot[0]+yC); heraf skal enff være = 1
        fill(0);
      }
    }
  }

  void predictions() {
    yPredictT = y+idle[0].height/4 + yAccel;

    yPredictB = y+idle[1].height-51 + yAccel;

    xPredictR = x+idle[0].width/2 + xAccel;

    xPredictL = x + xAccel;
  }

  void xMove() {
    yInt=int(y);
    xPredictRInt=int(xPredictR);
    xPredictLInt=int(xPredictL);
    if (getPixelSafe(xPredictRInt, yInt+idle[0].height/2)==backgroundColor&&getPixelSafe(xPredictRInt, yInt+idle[0].height-51)==backgroundColor&&moved==false) {
      x=x+xAccel;
      moved=true;
    } else {
      xAccel=0;
      //print(" x stop: " +" R: " + get(xPredictRInt, yInt+idle[0].height-51));
    }
    if (getPixelSafe(xPredictLInt, yInt+idle[0].height/2)==backgroundColor&&getPixelSafe(xPredictLInt, yInt+idle[0].height-51)==backgroundColor&&moved==false) {
      x=x-xAccel;
      moved=true;
    } else if(moved==false) {
      xAccel=0;
      //print("L: " + get(xPredictLInt, yInt+idle[0].height-51));
    }
    //circle(xPredictR, yInt, 20);
    //circle(xPredictL, yInt+idle[0].height-51, 20);
    moved=false;
  }

  void yMove() {
    yPredictBInt=int(yPredictB);
    yPredictTInt=int(yPredictT);
    xInt=int(x);
    if(getPixelSafe(xInt+idle[0].width/2, yPredictTInt)!=backgroundColor){
      yAccel=0;
    }
    if (getPixelSafe(xInt+idle[0].width/2, yPredictBInt)==backgroundColor) {
      y=y+yAccel;
    } else {
      yAccel=0;
      tick=0;
      jumpAvalible=true;
    }
    if (getPixelSafe(xInt+idle[0].width/2, yPredictBInt+1)==backgroundColor) {
      yAccel+=1;
    }
    if (getPixelSafe(xInt+idle[0].width/2, yPredictTInt)!=backgroundColor) {
      yAccel+=1;
    }
    //(til at teste med)circle(xInt+idle[0].width/2, yPredictTInt, 5);
    //(til at teste med)circle(xInt+idle[0].width/2, yPredictBInt, 5);
  }

  void swapPos() {
    //print(" backspace pressed: ");
    //print(backspacePressed);
    //print(" flip: ");
    //print(swapPosFlip);

    if (frameCount>swapPosTimer+144) {
      swapPosFlip=true;
      if (backspacePressed==true&&swapPosFlip==true) {
        if (enff==143) {
          //print("               swapPos             ");
          swapPosTimer=frameCount;
          x=xDot[0];
          y=yDot[0];
          swapPosFlip=false;
        } else {
          //print("               swapPos             ");
          swapPosTimer=frameCount;
          x=xDot[enff+1];
          y=yDot[enff+1];
          swapPosFlip=false;
        }
        Switch.play(0.5, 1.0);
      }
    }
  }

  void engine() {
    playerAX();
    predictions();
    xMove();
    yMove();
    swapPos();
    drawBez();
    x = constrain(x, 0, background.width - 1);
    y = constrain(y, 0, background.height - 1);
    fill(255);
    /*
    text(x, width/2, height/2);
     text(xAccel, width/2+200, height/2);
     text(yAccel, width/2+200, height/2+20);
     text(jumpcurrentFrame, width/2+200, height/2+40);
     text(runcurrentFrame, width/2+200, height/2+60);
     fill(0);
     */
  }
}
