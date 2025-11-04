class UfoBullet {
  PVector loc;
  PVector vel;
  boolean dead;
  int timer;

  UfoBullet(float x,float y,PVector v){
    loc=new PVector(x,y);
    vel=new PVector(v.x,v.y);
    dead=false;
    timer=240;
  }

  void act(){
    loc.x+=vel.x;
    loc.y+=vel.y;
    timer--;
    if(timer<=0) dead=true;

    float r=4;
    if(loc.x<-r) dead=true;
    else if(loc.x>width+r) dead=true;
    if(loc.y<-r) dead=true;
    else if(loc.y>height+r) dead=true;
  }

  void show(){
    noStroke();
    fill(255,120,120);
    ellipse(loc.x,loc.y,6,6);
  }
}
