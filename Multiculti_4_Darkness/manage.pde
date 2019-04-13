

class manage{
  
  
  manage(){
    boxes = new ArrayList<Box>();
  }
  
  void createLife(){
    Box p = new Box(width/2 + random(20),height/2 + random(20));
    boxes.add(p);
  }
}
