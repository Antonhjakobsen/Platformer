class Player {
  float x;
  float y;
  float xAccel;
  float yAccel;
  float accelerationLimit = 10;
  float friction = 0.60;
  float baseLine = height/1.2;
  int enff;
  float xPosPoint1;
  float xPosPoint2;
  float yPosPoint1;
  float yPosPoint2;

  float xDotLast;
  float yDotLast;

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

  Player(float x, float y, int idlenumFrames, int fallnumFrames, int runnumFrames, int jumpnumFrames) {
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
    int offset = width/2;
    for (int i = 0; i < width; i += width) {
      image(idle[(idlecurrentFrame+offset) % idlenumFrames], x, y);
    }
  }
  void fallAnimation() {
    fallcurrentFrame = (fallcurrentFrame+1) % fallnumFrames;  // Use % to cycle through frames
    int offset = width/2;
    for (int i = 0; i < width; i += width) {
      image(fall[(fallcurrentFrame+offset) % fallnumFrames], x, y);
    }
  }

  void runAnimation() {
    runcurrentFrame = (runcurrentFrame+1) % runnumFrames;  // Use % to cycle through frames
    int offset = width/2;
    for (int i = 0; i < width; i += width) {
      image(run[(runcurrentFrame+offset) % runnumFrames], x, y);
    }
  }

  void jumpAnimation() {
    jumpcurrentFrame = (jumpcurrentFrame+1) % jumpnumFrames;
    int offset=width/2;
    for (int i = 0; i < width; i += width) {
      image(jump[(jumpcurrentFrame+offset) % jumpnumFrames], x, y);
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
    if (tick==2) {
      jumpAvalible=false;
    }
    if (keyPressed==true&&upPressed==true&&jumpAvalible==true&&flip==false) {
      yAccel-=20;
      if (yAccel<-20) {
        yAccel=-20;
      }
      tick++;
    }
  }

  void displayPlayer() {
    if (xAccel<0&&xAccel>-1&&yAccel==0) {//Left
      pushMatrix();
      translate(idle[idlecurrentFrame].width+x*2, 0);
      scale(-1, 1);
      player.idleAnimation();
      animationIndex=0;
      popMatrix();
      text("Left", width/2, height/1.5);
    } else if (xAccel>=0&&xAccel<1&&yAccel==0) {//Right
      pushMatrix();
      scale(1, 1);
      player.idleAnimation();
      animationIndex=0;
      popMatrix();
      text("Right", width/2, height/1.5);
    } else if (xAccel<0&&yAccel!=0) {
      pushMatrix();
      if (yAccel>0) {
        translate(fall[fallcurrentFrame].width+x*2, 0);
        scale(-1, 1);
        player.fallAnimation();
        animationIndex=1;
        //print("fall ");
      } else if (yAccel<0) {
        translate(jump[jumpcurrentFrame].width+x*2, 0);
        scale(-1, 1);
        player.jumpAnimation();
        animationIndex=2;
        //print("jump ");
      }
      popMatrix();
    } else if (yAccel!=0) {
      if (yAccel>0) {
        player.fallAnimation();
        //print("fall ");
        animationIndex=2;
      } else if (yAccel<0) {
        player.jumpAnimation();
        animationIndex=3;
        //print("jump ");
      }
    } else if (xAccel<1) {
      pushMatrix();
      translate(run[runcurrentFrame].width+x*2, 0);
      scale(-1, 1);
      player.runAnimation();
      animationIndex=3;
      popMatrix();
      //print("running ");
    } else {
      player.runAnimation();
      //print("running 2 ");
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
      image(idle[0], xDot[0], yDot[0]);
      enff=0;
    } else {
      image(idle[0], xDot[enff+1], yDot[enff+1]);
      enff++;
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
        float xC=idle[1].width/2;
        float yC=idle[1].height/2;
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
    yPredictT = y+idle[0].width/40 + yAccel;

    yPredictB = y+idle[1].height/1.66 + yAccel;

    xPredictR = x+idle[0].width/1.8 + xAccel;
    //line(xPredictR,yPredictT,xPredictR,yPredictB);

    xPredictL = x+51 + xAccel;
    //line(xPredictL,yPredictT,xPredictL,yPredictB);
  }

  void xMove() {
    yInt=int(y);
    int xPredictRInt=int(xPredictR);
    int xPredictLInt=int(xPredictL);
    if (get(xPredictRInt, yInt)==backgroundColor&&get(xPredictRInt, yInt+idle[0].height-51)==backgroundColor&&get(xPredictLInt, yInt)==backgroundColor&&get(xPredictLInt, yInt+idle[0].height-51)==backgroundColor) {
      x=x+xAccel;
    } else {
      xAccel=0;
      print(" x stop: " + "L: " + get(xPredictLInt, yInt+idle[0].height-51) + " R: " + get(xPredictRInt, yInt+idle[0].height-51));
    }
  }

  void yMove() {
    int yPredictBInt=int(yPredictB);
    int yPredictTInt=int(yPredictT);
    xInt=int(x);
    if (get(xInt+idle[0].width/2, yPredictBInt)==backgroundColor) {
      y=y+yAccel;
    } else {
      yAccel=0;
      tick=0;
      jumpAvalible=true;
    }
    if (get(xInt+idle[0].width/2, yPredictBInt+1)==backgroundColor) {
      yAccel+=1;
    }
    if(get(xInt+idle[0].width/2, yPredictTInt-1)!=backgroundColor){
      yAccel+=1;
    }
  }

  void swapPos() {
  }

  void displayShadow() {
    /*
        Til animation af skyggen forsøg 1
     if (animationIndex==0) {//idle
     if (enff>0) {
     shadowArray[enff]=loadImage("img/Character/individual_sheets/idle/0.gif");
     } else {
     shadowArray[0]=idle[0];
     }
     } else if (animationIndex==1) {//fall
     } else if (animationIndex==2) {//run
     } else if (animationIndex==3) {//jump
     }
     */
  }

  void engine() {
    playerAX();
    predictions();
    xMove();
    yMove();
    drawBez();
    displayShadow();
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
