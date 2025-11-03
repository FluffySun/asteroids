/*
MAINSCREEN:

x=x+vx

circle (loc.x,y,d);

if (y<d/2||y>height-d/2) vy=-vy;

float x, y,d, vx, vy;

loc.x=loc.x+vel.x;
y=y+vy;

loc.add(vel);

if (loc.y<d/2||loc.y>height-d/2) vel.y=-0.9*vel.y;
if (x<d/2||x>width-d/2) vx=-vx;

PVector loc+vel+gravity;

loc=new PVector(width/2, height/2);

vel=new PVector(random(-5,5), random(-5,5));

gravity=newPVector(0,1); 

loc.add(vel);
vel.add(gravity);



->turn into set: vel=PVEctor(5, 0);
vel.rotate(random(0, 2*PI));

vel.setMag();
vel.mag();

println(vel.mag());
->vel.setMag(vel.mag()+1);

println(vel.mag());

println(vel.heading()); =find out the angle


SPACESHIP:
class spaceship

PVector dir; ->replace gravity, keep loc+vel

need constructor:
spaceship(){
  dir=newPVector (1,); ->direction same as gravity
}

need behaviour functions
void show()

void act() {
  move();
  shoot();
  checkForCollisions();
}

void move() {
...

pushMatrix();
translate(loc.x, loc.y);
drawShip();
popMatrix();

void drawShip() {
}

boolean upkey, downkey, leftkey, rightkey;

Spaceship player1;

void setup() {
  player1=new spaceship();
}


GAME:
player1.show();

void keyPressed() {
  if (keyCode == UP) upkey = true/false;
  
  translate(loc.x, loc.y);
  
  rotate(dir.heading());
  
void move() {
  if (eftkey) dir.rotate(-radians(3));
  
  player1.act();
  
void move() {
  loc.add(vel);
  
if (upkey) vel.add(dir);

*/
