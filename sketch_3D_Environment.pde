import java.awt.Robot;

Robot rbt;

boolean wkey, akey, skey, dkey;
float eyeX, eyeY, eyeZ, focusX, focusY, focusZ, tiltX, tiltY, tiltZ;
float leftRightHeadAngle, upDownHeadAngle;


//color pallette
color black = #000000;  //oak blocks
color white = #ffffff;  //empty space
color aqua = #63dcbf;  //mossy bricks
color purple = #a263dc; //snow
color blue = #6394dc;
color green = #92dc63;
color red = #dc6363;

//Map variables
int gridSize;
PImage map;

//textures
PImage mossyStone;
PImage oakPlanks;
PImage snow;

boolean skipFrame;



void setup() {
  size(displayWidth, displayHeight, P3D);
  textureMode(NORMAL);
  wkey = akey = skey = dkey = false;
  eyeX = width/2;
  eyeY = 9*height/10;
  eyeZ = height/2;
  focusX = width/2;
  focusY = height/2;
  focusZ = height/2 - 100;
  tiltX = 0;
  tiltY = 1;
  tiltZ = 0;
  leftRightHeadAngle = PI/2;
  noCursor();
  //upDownHeadAngle = 0;

  try {
    rbt = new Robot();
  }

  catch(Exception e) {
    e.printStackTrace();
  }


  //load map
  map = loadImage("colourmap.png");
  gridSize = 100;


  //load textures
  mossyStone = loadImage("Mossy_Stone_Bricks.png");
  oakPlanks = loadImage("OakPlanks.png");
  snow = loadImage("Snow.png");

  mouseX = width/2;
  mouseY = height/2;


  skipFrame = false;
}

void draw() {
  background(0);

  //lights();
  pointLight(255, 255, 255, eyeX, eyeY, eyeZ);
  camera(eyeX, eyeY, eyeZ, focusX, focusY, focusZ, tiltX, tiltY, tiltZ);


  drawFloor(-4000, 6000, height, 100);
  drawFloor(-4000, 6000, -gridSize, 100);

  //  drawFloor(-2000, 2000, height, 100);
  //  drawFloor(-2000, height - gridSize*4, 2000, gridSize);

  // drawCeiling();
  drawFocalPoint();
  controlCamera();
  drawMap(2000);
}


void drawFocalPoint() {
  pushMatrix();
  translate(focusX, focusY, focusZ);
  sphere(5);
  popMatrix();
}


//void drawFloor(float fx, float fy, float fz, float add) {
//  stroke(255);
//  for (float x = fx; x <= fz; x = x + add) {
//    line(x, fy, fx, x, fy, fz);
//    line(fx, fy, x, fz, fy, x);
//  }
//}


void drawFloor(int start, int end, int level, int gap) {
  stroke(255);
  strokeWeight(1);
  int x = start;
  int z = start;
  while (z < end) {
    texturedCube(x, level, z, oakPlanks, gap);
    x = x + gap;
    if (x >= end) {
      x = start;
      z = z + gap;
    }
  }
}



void drawCeiling() {
  stroke(255);
  for (int x = -2000; x <= 2000; x = x + 100) {
    line(x, 0, -2000, x, 0, 2000);
    line(-2000, 0, x, 2000, 0, x);
  }
}


void controlCamera() {
  if (wkey) {
    eyeX = eyeX + cos(leftRightHeadAngle)*10;
    eyeZ = eyeZ + sin(leftRightHeadAngle)*10;
  }
  if (skey) {
    eyeX = eyeX - cos(leftRightHeadAngle)*10;
    eyeZ = eyeZ - sin(leftRightHeadAngle)*10;
  }
  if (akey) {
    eyeX = eyeX - cos(leftRightHeadAngle+PI/2)*10;
    eyeZ = eyeZ - sin(leftRightHeadAngle+PI/2)*10;
  }
  if (dkey) {
    eyeX = eyeX + cos(leftRightHeadAngle+PI/2)*10;
    eyeZ = eyeZ + sin(leftRightHeadAngle+PI/2)*10;
  }

  if (skipFrame == false ) {
    leftRightHeadAngle = leftRightHeadAngle + (mouseX - pmouseX)*0.01;
    upDownHeadAngle = upDownHeadAngle + (mouseY - pmouseY)*0.01;
  }

  if (upDownHeadAngle > PI/2.5) upDownHeadAngle = PI/2.5;
  if (upDownHeadAngle < -PI/2.5) upDownHeadAngle = -PI/2.5;



  focusX = eyeX + cos(leftRightHeadAngle)*300;
  focusZ = eyeZ + sin(leftRightHeadAngle)*300;
  focusY = eyeY + tan(upDownHeadAngle)*300;
  //println(eyeX, eyeY, eyeZ);

  if (mouseX < 2) {
    rbt.mouseMove(width-3, mouseY);
    skipFrame = true;
  } else if (mouseX > width - 2) {
    rbt.mouseMove(3, mouseY);
    skipFrame = true;
  } else {
   skipFrame = false; 
    
  }
  
}

void drawMap(int  fx) {
  for (int x = 0; x < map.width; x++) {
    for (int y = 0; y < map.height; y++) {
      color c = map.get(x, y);
      if (c == aqua) {
        for (int mult = 1; mult <= 9; mult++)
          texturedCube(x*gridSize-fx, height-gridSize*mult, y*gridSize-fx, mossyStone, gridSize);
      }
      if (c == black) {
        for (int mult = 1; mult <= 9; mult++)
          texturedCube(x*gridSize-fx, height-gridSize*mult, y*gridSize-fx, oakPlanks, gridSize);
      }

      if (c == purple) {
        for (int mult = 1; mult <= 9; mult++)
          texturedCube(x*gridSize-fx, height-gridSize*mult, y*gridSize-fx, snow, gridSize);
      }
    }
  }
}




void keyPressed () {
  if (key == 'W' || key == 'w') wkey = true;
  if (key == 'A' || key == 'a') akey = true;
  if (key == 'S' || key == 's') skey = true;
  if (key == 'D' || key == 'd') dkey = true;
}


void keyReleased () {
  if (key == 'W' || key == 'w') wkey = false;
  if (key == 'A' || key == 'a') akey = false;
  if (key == 'S' || key == 's') skey = false;
  if (key == 'D' || key == 'd') dkey = false;
}
