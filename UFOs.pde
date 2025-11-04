class UFO extends GameObject {
  float w;
  float h;

  int shootCooldown;
  int shootGapMin=45;
  int shootGapMax=80;

  UFO(){
    dead=false;
    w=40;
    h=20;

    if(random(1)<0.5){
      float ly=random(40,height-40);
      loc=new PVector(-w,ly);
      float vx=random(1.0,2.5);
      vel=new PVector(vx,0);
    }else{
      float ly=random(40,height-40);
      loc=new PVector(width+w,ly);
      float vx=random(-2.5,-1.0);
      vel=new PVector(vx,0);
    }

    shootCooldown=int(random(shootGapMin,shootGapMax));
  }

  void act(){
    loc.x+=vel.x;
    loc.y+=vel.y;

    if(loc.x<-w*2||loc.x>width+w*2) {
      dead=true;
    }

    shootCooldown--;
    if(shootCooldown<0) {
      shootCooldown=0;
    }

    if(shootCooldown==0 && !dead){
      float dx=player1.loc.x-loc.x;
      float dy=player1.loc.y-loc.y;
      float m=dist(0,0,dx,dy);
      float nx=0, ny=0;
      if(m>0){ nx=dx/m; ny=dy/m; }

      PVector v=new PVector(nx*6.0, ny*6.0);
      bullets.add(new Bullet(loc.x,loc.y,v,true));

      shootCooldown=int(random(shootGapMin,shootGapMax));
    }
  }

  void show(){
    pushMatrix();
    translate(loc.x,loc.y);
    noStroke();
    fill(100,255,200);
    ellipse(0,0,w,h);
    fill(30);
    ellipse(0,0,w*0.5,h*0.5);
    popMatrix();
  }
}
