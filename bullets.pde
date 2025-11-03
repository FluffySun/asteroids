/*

class Bullet{
  PVector loc+vel;
  
  Bullet() {
    loc=new PVector(player1.loc.x, player1.loc.y);
    vel=player1.dir.copy();
    vel.setMag(10);
  }
  
  void show() {
    circle(loc.x,loc,y,5);
  }
  
  void act() {
    loc.add(vel);
  }
  
  
MAIN PAGE:
->import java.util.ArrayList;

->list of bullets
ArrayList<Bullet> bullets;

->add in setup
bullets=new ArrayList();

->add in void shoot
if (spacekey) bullets.add(new Bullet());

->in void act
loc.add(vel);

-MORE:
->in draw
println(objects.size());

->above draw
rectMode(CENTER);
objects=new ArrayList();
player1=new Spaceship();
objects.add(player1);
/

GAME PAGE:
int i=0;
while(i<bullets.size()) {
  Bullet currentBullet = bullets.get(i);
  currentBullet.act();
  currentBullet.show;
  if (currentObject.lives==0)
  objects.remove(i);
  else
  i++;
}}


BULLET PAGE:
class Bullet extends GameObject{  

int timer; ->at the start

bullet() {
  ...
  super(player1.loc.coy(), player1.dir.copy());
  vel=new PVector(mouseX-loc.x, mouseY-loc.y); ->btwn target+yourself (triangle)
  vel.add(player1.vel);
  vel.setMag(10);
  timer=60;

void act() {
  loc.add(vel);
  timer--;
  if (timer==0) lives=0;
}



  
OPEN GAMEOBJECT PAGE NEW:
class GameObject {
  
  PVector loc;//location
  PVector vel;//velocity
  int lives;
  
  GameObject(float x, float ly, float vx, float vy) {
    loc=new PVector (lx, ly);
    vel=new PVector (vx, vy);
  }
  
  GameObject (PVector l, PVector v) {
    loc=l;
    vel=v;
    lives=1;
  }
  
  GameObject(PVector l, PVector v, int lv) {
    loc=l;
    vel=v;
    lives=lv;
  }
  
  void wrapAround() {
    if (loc.x<0) loc.x=widthl
    if (loc.x>width) loc.x=0;
    if (loc.y<0) loc.y=height;
    if (loc.y>height) loc.y=0;
    
  }
  
  
  SPACESHIP PAGE:
  ->add in void act()
  wrapAround();
  
  ->add after PVector dir; at the top
  int cooldown;
  
  Spaceship() {
    super(width/2. height/2, 0, 0);
    dir=newPVector(0,1,0);
    
   void shoot() {
     cooldown--;
     if (spacekey && cooldown <= 0) {
       objects.add(new Bullet());
       cooldown=30;
     }}
  
  BULLET PAGE:
  ->add in void act() 
  wrapAround();
  
  
  ASTEROID PAGE:
  class Asteroid extends GameObject {
    Asteroid () {
      super (random(width), random(height), 1, 1);
      vel.setMag(random(1,3));
      vel.setDirection();->change to:
      vel.rotate(random(TWO_PI));
      lives=3;
      d=lives*50;
    }
    
    void show() {
       circle(loc.x, loc.y, lives*50);
      line(loc.x, loc.y, loc.x+lives*50/2, loc.y);
    }
    
    void act() {
      loc.add(vel);
      wrapAround();
      checkForCollisions();
    }
    
    void checkForCOllisions() {
      int i=0;
      while(i<objects.size()){
        GameObject obj=objects.get(i);
        if(obj instanceof Bullet) {
          if (dist(loc.x, loc.y, obj.loc.x, obj.loc.y) < d/2 + obj.d/2 {
            objects.add(new Asteroid());
            lives=0;
            obj.lives=0;
    }
   
    MAIN PAGE:
    objects.add(new Asteroid());
    
    X4/more
    
    
    GAMEOBJECT PAGE:
    add in class:
    float d;
    
  }
  
  ::?HOW TO DO::
  1. MAKE NEW CONSTRUCTOR?: for asteroid (new loc.x, loc.y)
  2. Calculate how many lives it has using lives-1
  3. Need a timer to countdown gameover?
  - go to color game to get the code point system
  
  
  LAST TARGETING BULLETS WITH PVECTORS:
  
*/
