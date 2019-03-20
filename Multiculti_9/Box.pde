// The Nature of Code
// <http://www.shiffman.net/teaching/nature>
// Spring 2012
// Box2DProcessing example

// A rectangular box
int[] data;

class Box {

  // We need to keep track of a Body and a width and height
  Body body;
  float w;
  float h;
  int livespan = 5000;
  int btime;
  Vec2 Pos = new Vec2(0 , 0);
  int[] data;
  int[][] visionTable;
  
  
  
  
  brain Brain = new brain(256 , 20 , 10 , 2 );

  // Constructor
  Box(float x, float y) {
    int[][] visiontable = new int[366][2];
    int num = 0;

    int visionSize = 200;
    int interval = 200 / 16;
    
    for(int i = 0; i < visionSize - interval; i = i + interval){
      for(int n = 0; n < visionSize - interval; n = n + interval){
        visiontable[num][0] = i - (visionSize/2) + 10;
        visiontable[num][1] = n - (visionSize/2) + 10;
        num++;
      }

    }
    print(num);
    visionTable = visiontable;
    
    
    btime = millis();
    w = random(8,16);
    h = w;
    // Add the box to the box2d world
    makeBody(new Vec2(x,y),w,h);
    Brain.generateRandomStart();
    
    
    
  }

  // This function removes the particle from the box2d world
  void killBody() {
    box2d.destroyBody(body);
  }
  void giveLife(int life){
    if(millis() > btime){
      btime = btime + (life / 6);
    }
  }
  
  void reciveVisuals(int[] visual){
    data = visual;
  }
  
  

  // Is the particle ready for deletion?
  boolean done() {
    // Let's find the screen position of the particle
    Pos = box2d.getBodyPixelCoord(body);  

    // Is it off the bottom of the screen?
    if ((Pos.y > height+w*h) || (Pos.y < 0)|| (Pos.x < 0)|| (Pos.x > width+w*h)) {
      killBody();
      return true;
    }
    if(millis() - btime > livespan){
      killBody();
      return true;
    }
    return false;
  }

  void attract(float x,float y) {
    // From BoxWrap2D example
    Vec2 worldTarget = box2d.coordPixelsToWorld(x,y);   
    Vec2 bodyVec = body.getWorldCenter();
    // First find the vector going from this body to the specified point
    worldTarget.subLocal(bodyVec);
    // Then, scale the vector to the specified force
    worldTarget.normalize();
    worldTarget.mulLocal((float) 50);
    // Now apply it to the body's center of mass.
    body.applyForce(worldTarget, bodyVec);
  }
  
  void move(float force , float angle){
    Vec2 target = new Vec2(force * sin(angle) , force * cos(angle));
    target.normalize();
    Vec2 bodyVec = body.getWorldCenter();
    body.applyForce(target, bodyVec);
  }


  // Drawing the box
  void display() {
    
    // We look at each body and get its screen position
    Vec2 pos = box2d.getBodyPixelCoord(body);
    // Get its angle of rotation
    float a = body.getAngle();

    rectMode(CENTER);
    pushMatrix();
    translate(pos.x,pos.y);
    rotate(-a);
    fill(50 ,255 - ((millis() - btime) * (0.051)) , 50); 
    //fill(300);
    stroke(0);
    rect(0,0,w,h);

    
    strokeWeight(2);
    fill(0 , 255 , 255);
    for(int i = 0 ; i <=300; i++){
        point(float(visionTable[i][0]) , float(visionTable[i][1]));
      //point(v.x[i] , v.y[i]);
    }
    
    popMatrix();
    
    
    Sun.returnSun(10);
  }

  // This function adds the rectangle to the box2d world
  void makeBody(Vec2 center, float w_, float h_) {

    // Define a polygon (this is what we use for a rectangle)
    PolygonShape sd = new PolygonShape();
    float box2dW = box2d.scalarPixelsToWorld(w_/2);
    float box2dH = box2d.scalarPixelsToWorld(h_/2);
    sd.setAsBox(box2dW, box2dH);

    // Define a fixture
    FixtureDef fd = new FixtureDef();
    fd.shape = sd;
    // Parameters that affect physics
    fd.density = 1;
    fd.friction = 0.3;
    fd.restitution = 0.5;

    // Define the body and make it from the shape
    BodyDef bd = new BodyDef();
    bd.type = BodyType.DYNAMIC;
    bd.position.set(box2d.coordPixelsToWorld(center));

    body = box2d.createBody(bd);
    body.createFixture(fd);
  }
}
