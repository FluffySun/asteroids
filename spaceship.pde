class Spaceship extends GameObject {
  PVector dir;

  boolean leftkey;
  boolean rightkey;
  boolean upkey;

  float sizeShip;
  float boundR;
  float rotStep;
  float thrust;
  float dragAmount;
  float minStop;
  int cooldown;

  Spaceship(float startX,float startY){
    loc=new PVector(startX,startY);
    vel=new PVector(0,0);
    dead=false;

    dir=new PVector(0,-1);

    leftkey=false;
    rightkey=false;
    upkey=false;

    sizeShip=20;
    boundR=15;
    rotStep=0.1;
    thrust=0.25;
    dragAmount=1;
    minStop=0.05;
    cooldown=0;
  }

  void reset(float x,float y){
    loc.x=x; loc.y=y;
    vel.x=0; vel.y=0;
    dir.x=0; dir.y=-1;
    leftkey=false; rightkey=false; upkey=false;
    cooldown=0;
  }

  void act(){
    move();
    shoot();
    wrapAround();
  }

  void move(){
    if(leftkey)  rotateDir(-rotStep);
    if(rightkey) rotateDir(rotStep);

    if(upkey){
      vel.x=vel.x+dir.x*thrust;
      vel.y=vel.y+dir.y*thrust;

      float backX=loc.x-dir.x*(sizeShip*0.6);
      float backY=loc.y-dir.y*(sizeShip*0.6);

      int c=0;
      while(c<3){
        float baseVX=-dir.x*random(1.0,2.5);
        float baseVY=-dir.y*random(1.0,2.5);
        baseVX=baseVX+random(-0.5,0.5);
        baseVY=baseVY+random(-0.5,0.5);
        particles.add(new Particle(backX,backY,baseVX,baseVY,false));
        c++;
      }
    }

    vel.x=vel.x*dragAmount;
    vel.y=vel.y*dragAmount;

    float spd=dist(0,0,vel.x,vel.y);
    if(spd<minStop){ vel.x=0; vel.y=0; }

    loc.x=loc.x+vel.x;
    loc.y=loc.y+vel.y;
  }

  void shoot(){
    cooldown--;
    if(cooldown<0) cooldown=0;

    if(spacekey && cooldown==0){
      bullets.add(new Bullet(loc.x,loc.y,dir,vel));
      cooldown=12;
    }
  }

  void wrapAround(){
    float m=boundR;
    if(loc.x<-m) loc.x=width+m;
    else if(loc.x>width+m) loc.x=-m;
    if(loc.y<-m) loc.y=height+m;
    else if(loc.y>height+m) loc.y=-m;
  }

  void show(){
    pushMatrix();
    translate(loc.x,loc.y);
    float ang=atan2(dir.y,dir.x)+HALF_PI; //need to check
    rotate(ang);
    stroke(255);
    noFill();
    strokeWeight(2);
    beginShape();
    vertex(0,-sizeShip*0.8);
    vertex(-sizeShip*0.5,sizeShip*0.6);
    vertex(sizeShip*0.5,sizeShip*0.6);
    endShape(CLOSE);
    popMatrix();
  }

  void rotateDir(float a){
    float px=-dir.y;
    float py= dir.x;
    dir.x=dir.x+px*a;
    dir.y=dir.y+py*a;

  if(dir.x > 1) dir.x = 1;
  if(dir.x < -1) dir.x = -1;
  if(dir.y > 1) dir.y = 1;
  if(dir.y < -1) dir.y = -1;
  }
}
