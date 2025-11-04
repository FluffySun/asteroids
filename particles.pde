class Particle extends GameObject {
  float alpha;
  float size;
  boolean isExplode;

  Particle(float x,float y,float vx,float vy,boolean explodeStyle){
    loc=new PVector(x,y);
    vel=new PVector(vx,vy);
    dead=false;
    alpha=255;
    size=random(3,6);
    isExplode=explodeStyle;
  }

  void act(){
    loc.x+=vel.x;
    loc.y+=vel.y;
    vel.x=vel.x*0.97;
    vel.y=vel.y*0.97;

    alpha-=6;
    if(alpha<0) alpha=0;
    if(alpha==0) dead=true;
  }

  void show(){
    noStroke();
    if(isExplode) fill(255,220,120,alpha);
    else fill(255,100,60,alpha);
    ellipse(loc.x,loc.y,size,size);
  }
}
