


class sun{
  float resX;
  float resY;
  float size = 100;
  
  int Xlenght = 0;
  int Ylenght = 0;
  float square;
  

  
  sun(float resolution , int myHeight , int myWidth){  
    resX = myWidth / resolution;
    resY = myHeight / resolution;
    
    shines = new ArrayList<shine>();
    Grid = new ArrayList<grid>();
    centers = new ArrayList<PVector>();
    
    square = myHeight/resY;
    int id = 0;
    for (int y = 0; y < myHeight; y+= myHeight/resY) {
      Ylenght++;
      Xlenght = 0;
      for (int x = 0; x < myWidth; x+= myWidth/resX) {
        Xlenght++;
        Grid.add( new grid(x , y , round(myHeight/resY) , id));
        //println(y);
        id++;
      }
    }
  }
  ArrayList<PVector> centers = new ArrayList<PVector>();
  
  int returnSun(Vec2 p){
     int x , y , feed;
     x = floor(p.x / square);
     y = floor(p.y / square);
     
     feed = (y * Xlenght) + x;
     if((feed < 10549) && (feed > 0)){
     grid g = Grid.get(feed);
     return min(g.InFill , 1000);
     }else{
       return -300;
     }
  }
  
  
  
  void update(){
    centers.clear();
 
    noStroke();
    for (int i = shines.size()-1; i >= 0; i--) {
      shine s = shines.get(i);
      s.update();
      if(s.check() == true){
      
      centers.add(new PVector(s.inX , s.inY));
      //print("TRUE");
      }else{
        //s.update();
        //print("FALSE \n \n \n");
      shines.remove(i);
      }
    }
    //pushMatrix();
    int sumFill = 0;
    for (int i = Grid.size()-1; i >= 0; i--) {
      grid g = Grid.get(i);
      float dist = 0;
      for (PVector b: centers) {
        dist += size /PVector.dist(g.centerPoint , b);
      }
      dist = (floor(dist*75.0) * 1);                      //You are looking for me
      g.show(round(dist));
      sumFill += round(dist) * 180;
      //println(dist);
  }
  if (10000000 > sumFill) {
     shine p = new shine();
     shines.add(p); 
    }
  }
};

class shine{
  float inX;
  float inY;
  float angle;
  float speed = 0.37;
  
  shine(){
    if(random(0 , 1) > 0.5){
      inX = 1;
      inY = round(random(1 , height/2));
      angle  = random(PI/5 , 4*PI/5);
      
    }else{
      inY = 1;
      inX = round(random(1 , width/2));
      angle  = random(-3*PI/10 , 3*PI/10);
    }   

  }
  
  void update(){
   inX = inX + (sin(angle) * speed);
   inY = inY + (cos(angle) * speed); 
   /*
   print("inX - "); println(inX);
   print("inY - "); println(inY);
   print(""); 
   */

  }
  
  boolean check(){
    if(inX > 1366+ 200){ 
      return false;
    }else if(inY > 768 + 200){
      return false;
    }else if(inY < -200){
      return false;
    }else if(inX < -200){
      return false;
    }else{
     return true;
   }
  }

};

class grid{
  PVector centerPoint;
  int Size;
  int Id;
  int InFill;

  
  grid(int intX , int intY , int size , int id){
    centerPoint = new PVector(intX + (size / 2) , intY + (size / 2));
    Size = size;
    Id = id;
  }
  
  void show(int inFill){
    InFill = inFill;
    fill(inFill , inFill , 60);
    rect(centerPoint.x , centerPoint.y , Size , Size);
  }
};
