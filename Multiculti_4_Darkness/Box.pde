// The Nature of Code
// <http://www.shiffman.net/teaching/nature>
// Spring 2012
// Box2DProcessing example

// A rectangular box
int[] data;

class Box {

  // We need to keep track of a Body and a width and height
  Body body;


  boolean touch = false;
  float w;
  float h;
  int livespan = 3600;
  int btime;
  int Btime;
  Vec2 Pos = new Vec2(0 , 0);
  int[] data;
  int[][] visionTable;
  float[] vision;
  float[] output;
  
  
  
  brain Brain = new brain(256 , 10 , 10 , 2 );

  // Constructor
  Box(float x, float y) {

    
    
    int[][] visiontable = new int[366][2];
    float[] vision = new float[256];
    float[] output = new float[2];
    int num = 0;
    
    for(int i = 0 ; i < 256; i++){
     vision[i] = 0.0; 
    }

    int visionSize = 200;
    int interval = 200 / 16;
    
    for(int i = 0; i < visionSize - interval; i = i + interval){
      for(int n = 0; n < visionSize - interval; n = n + interval){
        visiontable[num][0] = i - (visionSize/2) + 10;
        visiontable[num][1] = n - (visionSize/2) + 10;
        num++;
      }

    }
    
    visionTable = visiontable;
    
    
    btime = millis();
    Btime = millis();
    w = random(10,12);
    h = w;
    // Add the box to the box2d world
    makeBody(new Vec2(x,y),w,h);
    Brain.generateRandomStart();
    
    
    
  }
  
  ArrayList<float[]> retunName(){
    return Brain.retunName();
  }
  
  void setNames(ArrayList<float[]> name){
    Brain.setNames(name);
  }
  
  void mutate(int factor){
    Brain.mutate(factor);
  }
  
  int lifeLength(){
    return millis() - Btime;
  }

  // This function removes the particle from the box2d world
  void killBody() {
    box2d.destroyBody(body);
  }
  void giveLife(int life){

  }
  
  void reciveVisuals(int[] visual){
    data = visual;
  }
  boolean doneWall(){
    if(touch){
     return true; 
    }else{
     return false; 
    }
  }
  

  // Is the particle ready for deletion?
  boolean done() {
    if(touch){
     return true; 
    }
    
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
    worldTarget.mulLocal((float) 5);
    // Now apply it to the body's center of mass.
    body.applyForce(worldTarget, bodyVec);
  }
  
  void move(float force , float angle){
    Vec2 target = new Vec2(force * sin(angle) , force * cos(angle));
    target.normalize();
    Vec2 bodyVec = body.getWorldCenter();
    body.applyForce(target, bodyVec);
  }
  
  void move_vec(Vec2 force){
    Vec2 target = new Vec2(force.x , force.y);
    target.normalize();
    target.mulLocal((float) 50);
    Vec2 bodyVec = body.getWorldCenter();
    body.applyForce(target, bodyVec);
  }
  
  
  void update(){
    Vec2 pos = box2d.getBodyPixelCoord(body);
    float[] Vision;
    Vision = new float[256];
    float tmp = 0;
    for(int i = 0 ; i <=254; i++){
      tmp = map(Sun.returnSun(new Vec2(visionTable[i][0] + pos.x , visionTable[i][1] + pos.y)), 0 , 500 , 0 , 1);  
      Vision[i] = tmp;
      //print(tmp);
      //print(" ");
    }
    Vision[255] = Sun.returnSun(Pos);
    
    output = Brain.returnResult(Vision);
    fill(0);
    //text(output[0] , 20 , 60);
    //text(output[1] , 20 , 80);
    
    
    Vec2 target = new Vec2(sin(output[0]) * output[1],cos(output[0]) * output[1]);
    move_vec(target);
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
    fill(50 ,255 - ((millis() - btime) * (255.0 / livespan)) , 50); 
    //fill(300);
    stroke(0);
    rect(0,0,w,h);

    popMatrix();
    
    
    
    //Sun.returnSun(10);
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
    fd.friction = 0.1;
    fd.restitution = 0.1;
    fd.filter.groupIndex = -8;
    

    // Define the body and make it from the shape
    BodyDef bd = new BodyDef();
    bd.type = BodyType.DYNAMIC;
    bd.position.set(box2d.coordPixelsToWorld(center));
    bd.linearDamping = 3.9f;
    bd.setUserData(this);
    body = box2d.createBody(bd);
    
    body.createFixture(fd);
    
  }
}


class Particle {

  // We need to keep track of a Body and a radius
  Body body;
  float r;
  boolean suicide = false;
  color col;
  float inX , inY;
  int btime;


  Particle(float x, float y, float r_) {
    r = r_;
    // This function puts the particle in the Box2d world
    makeBody(x, y, r);
    body.setUserData(this);
    col = color(175);
    btime = millis();
  }

  // This function removes the particle from the box2d world
  void killBody() {
    box2d.destroyBody(body);
  }

  // Change color when hit
  void change() {
    col = color(255, 0, 0);
  }




  // 
  void display() {
    if(suicide){
      killBody();
    }
    // We look at each body and get its screen position
    Vec2 pos = box2d.getBodyPixelCoord(body);
    inX = pos.x;
    inY = pos.y;
    // Get its angle of rotation
    float a = body.getAngle();
    pushMatrix();
    translate(pos.x, pos.y);
    rotate(a);
    fill(col);
    stroke(0);
    strokeWeight(1);
    ellipse(0, 0, r*2, r*2);
    // Let's add a line so we can see the rotation
    line(0, 0, r, 0);
    popMatrix();
  }

  // Here's our function that adds the particle to the Box2D world
  void makeBody(float x, float y, float r) {
    // Define a body
    BodyDef bd = new BodyDef();
    // Set its position
    bd.position = box2d.coordPixelsToWorld(x, y);
    bd.type = BodyType.DYNAMIC;
    body = box2d.createBody(bd);

    // Make the body's shape a circle
    CircleShape cs = new CircleShape();
    cs.m_radius = box2d.scalarPixelsToWorld(r);

    FixtureDef fd = new FixtureDef();
    fd.shape = cs;
    // Parameters that affect physics
    fd.density = 1;
    fd.friction = 0.01;
    fd.restitution = 0.3;

    // Attach fixture to body
    body.createFixture(fd);

    body.setAngularVelocity(random(-10, 10));
  }
}
