class Asteroid extends GameObject {
  int type;
  float r;

  Asteroid(){
    type=1;
    loc=new PVector(random(width),random(height));
    vel=new PVector(0,0);
    dead=false;
    float spd=random(1,2);
    r=32;
    float vx=random(-1,1);
    float vy=random(-1,1);
    float m=dist(0,0,vx,vy);
    if(m<0.0001){ vx=1; vy=0; m=1; }
    vel.x=(vx/m)*spd;
    vel.y=(vy/m)*spd;
  }

  Asteroid(int t,PVector startPos){
    type=t;
    loc=new PVector(startPos.x,startPos.y);
    vel=new PVector(0,0);
    dead=false;

    float spd;
    if(type==1){
      r=32;
      spd=random(1.0,2.0);
    }else if(type==2){
      r=22;
      spd=random(1.5,3);
    }else{
      r=12;
      spd=random(2.0,3.5);
    }

    float vx=random(-1,1);
    float vy=random(-1,1);
    float m=dist(0,0,vx,vy);
    if(m<0.0001){ vx=1; vy=0; m=1; }
    vel.x=(vx/m)*spd;
    vel.y=(vy/m)*spd;
  }

  void act(){
    loc.x+=vel.x;
    loc.y+=vel.y;
    wrapAround();
  }

  void show(){
    noStroke();
    fill(160);
    circle(loc.x,loc.y,r*2);

    pushMatrix();
    translate(loc.x,loc.y);
    rotate(frameCount*0.01);

    fill(60);
    noStroke();
    if(type==1){
      beginShape();
      vertex(0,-r*0.8);
      vertex(-r*0.6,r*0.7);
      vertex(r*0.6,r*0.7);
      endShape(CLOSE);
    }else if(type==2){
      rectMode(CENTER);
      rect(0,0,r*0.9,r*0.55);
    }else{
      circle(0,0,r*0.8);
    }
    popMatrix();
  }

  void wrapAround(){
    float m=r;
    if(loc.x<-m) loc.x=width+m;
    else if(loc.x>width+m) loc.x=-m;
    if(loc.y<-m) loc.y=height+m;
    else if(loc.y>height+m) loc.y=-m;
  }

  void onHit(ArrayList<Asteroid> asts){
    if(type==1){
      spawnChildren(asts,2,2);
    }else if(type==2){
      spawnChildren(asts,3,2);
    }
    dead=true;
  }

  void spawnChildren(ArrayList<Asteroid> asts,int childType,int count){
    int i=0;
    while(i<count){
      float px=loc.x+random(-4,4);
      float py=loc.y+random(-4,4);
      PVector p=new PVector(px,py);
      Asteroid child=new Asteroid(childType,p);
      asts.add(child);
      i++;
    }
  }
}
