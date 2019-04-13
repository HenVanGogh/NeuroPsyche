// The Nature of Code
// <http://www.shiffman.net/teaching/nature>
// Spring 2011
// Box2DProcessing example

// Basic example of falling rectangles
import java.util.*; 
import shiffman.box2d.*;
import org.jbox2d.collision.shapes.*;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.*;
import shiffman.box2d.*;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.joints.*;
import org.jbox2d.collision.shapes.*;
import org.jbox2d.collision.shapes.Shape;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.*;
import org.jbox2d.dynamics.contacts.*;



int lock = 0;
// A reference to our box2d world
Box2DProcessing box2d;

// A list we'll use to track fixed objects
ArrayList<Boundary> boundaries;
// A list for all of our rectangles
ArrayList<Box> boxes;
ArrayList<shine> shines;
ArrayList<grid> Grid;
ArrayList<player> lifeArray;

ArrayList<ArrayList<float[]>> Generations;

int[][] visionTable;

  sun Sun = new sun(10 , 768 , 1366); // 768 1366

void setup() {
  
  
  
  //size(1920,1080);
  fullScreen();
  //smooth();

  // Initialize box2d physics and create the world
  box2d = new Box2DProcessing(this);
  box2d.createWorld();
  // We are setting a custom gravity
  box2d.setGravity(0,0);


  // Create ArrayLists	
  boxes = new ArrayList<Box>();
  boundaries = new ArrayList<Boundary>();
  Generations = new ArrayList<ArrayList<float[]>>();
  lifeArray = new ArrayList<player>();
  

  // Add a bunch of fixed boundaries
  boundaries.add(new Boundary(width/2,height,width,0));
  boundaries.add(new Boundary(width/2,0,width,0));
  boundaries.add(new Boundary(0,height/2,0,height));
  boundaries.add(new Boundary(width,height/2,0,height));

for(int i = 0 ; i < 100 ; i++){
Box p = new Box(width/2 + random(20),height/2 + random(20));
    boxes.add(p);
    box2d.listenForCollisions();
}
  
    
    
    
    
}
class player{
  ArrayList<float[]> brain;
  int score;
  
  player(ArrayList<float[]> Brain , int Score){
    brain = Brain;
    score = Score;
  }
}
class SortPlayers implements Comparator<player> 
{ 
    // Used for sorting in ascending order of 
    // roll number 
    public int compare(player a, player b) 
    { 
        return a.score - b.score; 
    } 
} 

void draw() {
  

  
  background(255);

  // We must always step through time!
  box2d.step();
   
  
  
  for (int i = boxes.size()-1; i >= 0; i--) {
    Box b = boxes.get(i);
    if (b.done()) {
      boxes.remove(i);
      if(lock == 0){
      if(lifeArray.size() <= 300){
        lifeArray.add(new player(b.retunName() , b.lifeLength()));
        
        Box p = new Box(width/2 + random(20),height/2 + random(20));
        boxes.add(p);
        
      }else{
        lock = 1;
        //for(int a = 0; a < lifeArray.size() - 200; a++){
          //lifeArray.remove(lifeArray.indexOf(Collections.min(lifeArray)));
        }
      }else{
        int boxScore = b.lifeLength();
        int negative;
        if(b.doneWall()){
        negative = 100;
        }else{
        negative = 0;
        }
        Collections.sort(lifeArray, new SortPlayers());
        player a = lifeArray.get(0);
        
        
        if(boxScore > a.score - negative){
          lifeArray.remove(0);
          lifeArray.add(new player(b.retunName() , b.lifeLength() - negative));
        }
        
        Box p = new Box(width/2 + random(20),height/2 + random(20));
        player champ = lifeArray.get(floor(0.00001*pow(random(0 , 300) , 3.019)));
        println(300 - floor(0.00001*pow(random(0 , 300) , 3.019)));
        p.setNames(champ.brain);
        p.mutate(10);
        boxes.add(p);
      
      }
    }
  } 
  Sun.update();


  // When the mouse is clicked, add a new Box object
  /*
  if (random(1) < 0.1) {
    Box p = new Box(width/2 + random(20),height/2 + random(20));
    boxes.add(p);
  }
  */
  
  if (mousePressed) {
    for (Box b: boxes) {
     b.attract(mouseX,mouseY);
    }
  }

  // Display all the boundaries
  for (Boundary wall: boundaries) {
    wall.display();
  }



  // Display all the boxes
  for (Box b: boxes) {
    
    b.giveLife(Sun.returnSun(b.Pos));
    b.display();
    b.update();
  }

  // Boxes that leave the screen, we delete them
  // (note they have to be deleted from both the box2d world and our list
  
  
  
  fill(0);
  Vec2 mouse = new Vec2(mouseX , mouseY);
  text(frameRate,20,20);
  text(mouseX,80,20);
  text(mouseY,80,40);
  text(Sun.returnSun(mouse) , 20 , 40);
  if(lock == 1){
  Collections.sort(lifeArray, new SortPlayers());
  player top1 = lifeArray.get(1);
  player top2 = lifeArray.get(2);
  player top3 = lifeArray.get(3);
  player top4 = lifeArray.get(4);
  player top5 = lifeArray.get(5);
  player top6 = lifeArray.get(6);
  player top7 = lifeArray.get(7);
  player top8 = lifeArray.get(8);
  player top9 = lifeArray.get(9);
  player top10 = lifeArray.get(10);
  
  player top300 = lifeArray.get(300);
  player top299 = lifeArray.get(299);
  player top298 = lifeArray.get(298);
  player top297 = lifeArray.get(297);
  player top296 = lifeArray.get(296);
  player top295 = lifeArray.get(295);
  player top294 = lifeArray.get(294);
  
  text(top1.score , 20 , 60);
  text(top2.score , 20 , 80);
  text(top3.score , 20 , 100);
  text(top4.score , 20 , 120);
  text(top5.score , 20 , 140);
  text(top6.score , 20 , 160);
  text(top7.score , 20 , 180);
  text(top8.score , 20 , 200);
  text(top9.score , 20 , 220);
  text(top10.score , 20 , 240);
  text(top300.score , 20 , 260);
  text(top299.score , 20 , 280);
  text(top298.score , 20 , 300);
  text(top297.score , 20 , 320);
  text(top296.score , 20 , 340);
  text(top295.score , 20 , 360);
  text(top294.score , 20 , 380);
  }

}


void beginContact(Contact cp) {
  
  // Get both shapes
  Fixture f1 = cp.getFixtureA();
  Fixture f2 = cp.getFixtureB();
  // Get both bodies
  Body b1 = f1.getBody();
  Body b2 = f2.getBody();

  // Get our objects that reference these bodies
  Object o1 = b1.getUserData();
  Object o2 = b2.getUserData();
  
  if (o1==null || o2==null)
     return;



  if (o1.getClass() == Boundary.class) {
    Box p = (Box) o2;
    p.touch = true;
  }
  if (o2.getClass() == Boundary.class) {
    Box p = (Box) o1;
    p.touch = true;
  }


}
void endContact(Contact cp) {
}
