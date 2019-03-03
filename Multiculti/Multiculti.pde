// The Nature of Code
// <http://www.shiffman.net/teaching/nature>
// Spring 2011
// Box2DProcessing example

// Basic example of falling rectangles

import shiffman.box2d.*;
import org.jbox2d.collision.shapes.*;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.*;

// A reference to our box2d world
Box2DProcessing box2d;

// A list we'll use to track fixed objects
ArrayList<Boundary> boundaries;
// A list for all of our rectangles
ArrayList<Box> boxes;

void setup() {
  //size(1920,1080);
  fullScreen();
  smooth();

  // Initialize box2d physics and create the world
  box2d = new Box2DProcessing(this);
  box2d.createWorld();
  // We are setting a custom gravity
  box2d.setGravity(0,0);

  // Create ArrayLists	
  boxes = new ArrayList<Box>();
  boundaries = new ArrayList<Boundary>();

  // Add a bunch of fixed boundaries
  boundaries.add(new Boundary(width/2,height,width,0));
  boundaries.add(new Boundary(width/2,0,width,0));
  boundaries.add(new Boundary(0,height/2,0,height));
  boundaries.add(new Boundary(width,height/2,0,height));

}

void draw() {
  background(255);

  // We must always step through time!
  box2d.step();

  // When the mouse is clicked, add a new Box object
  if (random(1) < 0.1) {
    Box p = new Box(random(width),10);
    boxes.add(p);
  }
  
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
    b.display();
  }

  // Boxes that leave the screen, we delete them
  // (note they have to be deleted from both the box2d world and our list
  for (int i = boxes.size()-1; i >= 0; i--) {
    Box b = boxes.get(i);
    if (b.done()) {
      boxes.remove(i);
    }
  }
  
  fill(0);
  text(frameRate,20,20);
}
