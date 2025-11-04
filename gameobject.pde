class GameObject {
  PVector loc;
  PVector vel;
  boolean dead;

  GameObject(){
    loc=new PVector(0,0);
    vel=new PVector(0,0);
    dead=false;
  }

  GameObject(float x,float y){
    loc=new PVector(x,y);
    vel=new PVector(0,0);
    dead=false;
  }

  void act(){
  }

  void show(){
  }
}
