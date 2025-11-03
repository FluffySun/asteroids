class Spaceship extends GameObject {
  // Direction the ship nose points
  PVector dir;

  // Inputs
  boolean leftkey;
  boolean rightkey;
  boolean upkey;

  // drawing / physics
  float sizeShip;
  float boundR;
  float rotStep;
  float thrust;
  float dragAmount;
  float minStop;
  int cooldown;

  Spaceship(float startX, float startY) {
    // manual "super"
    loc = new PVector(startX, startY);
    vel = new PVector(0, 0);
    dead = false;

    dir = new PVector(0, -1); // face up

    leftkey  = false;
    rightkey = false;
    upkey    = false;

    sizeShip   = 20;
    boundR     = 15;
    rotStep    = 0.08;
    thrust     = 0.25;
    dragAmount = 0.99;
    minStop    = 0.05;
    cooldown   = 0;
  }

  void reset(float x, float y) {
    loc.x = x;
    loc.y = y;
    vel.x = 0;
    vel.y = 0;
    dir.x = 0;
    dir.y = -1;

    leftkey  = false;
    rightkey = false;
    upkey    = false;
    cooldown = 0;
  }

  void act() {
    move();
    shoot();
    wrapAround();
  }

  void move() {
    // rotate left/right
    if (leftkey) {
      rotateDir(-rotStep);
    }
    if (rightkey) {
      rotateDir(rotStep);
    }

    // thrust forward
    if (upkey) {
      // accelerate ship
      vel.x = vel.x + dir.x * thrust;
      vel.y = vel.y + dir.y * thrust;

      // thruster particles behind ship
      float backX = loc.x - dir.x * (sizeShip * 0.6);
      float backY = loc.y - dir.y * (sizeShip * 0.6);

      int c = 0;
      while (c < 3) {
        float baseVX = -dir.x * random(1.0, 2.5);
        float baseVY = -dir.y * random(1.0, 2.5);

        baseVX = baseVX + random(-0.5, 0.5);
        baseVY = baseVY + random(-0.5, 0.5);

        particles.add(new Particle(backX, backY, baseVX, baseVY, false));
        c++;
      }
    }

    // drag / slow down
    vel.x = vel.x * dragAmount;
    vel.y = vel.y * dragAmount;
    float spd = sqrt(vel.x*vel.x + vel.y*vel.y);
    if (spd < minStop) {
      vel.x = 0;
      vel.y = 0;
    }

    // update position
    loc.x = loc.x + vel.x;
    loc.y = loc.y + vel.y;
  }

  void shoot() {
    // cooldown timer down
    cooldown--;
    if (cooldown < 0) {
      cooldown = 0;
    }

    if (spacekey && cooldown == 0) {
      // make a player bullet (fromUFO=false inside Bullet)
      bullets.add(new Bullet(loc.x, loc.y, dir, vel));
      cooldown = 12;
    }
  }

  void wrapAround() {
    float m = boundR;
    if (loc.x < -m)              loc.x = width + m;
    else if (loc.x > width + m)  loc.x = -m;
    if (loc.y < -m)              loc.y = height + m;
    else if (loc.y > height + m) loc.y = -m;
  }

  void show() {
    pushMatrix();
    translate(loc.x, loc.y);

    // rotate ship to direction
    float ang = atan2(dir.y, dir.x) + HALF_PI;
    rotate(ang);

    stroke(255);
    noFill();
    strokeWeight(2);

    // triangle nose forward
    beginShape();
    vertex(0, -sizeShip * 0.8);
    vertex(-sizeShip * 0.5, sizeShip * 0.6);
    vertex(sizeShip * 0.5, sizeShip * 0.6);
    endShape(CLOSE);

    popMatrix();

    // debug hit circle (optional)
    // noFill();
    // stroke(255, 100);
    // circle(loc.x, loc.y, boundR*2);
  }

  void rotateDir(float ang) {
    float c = cos(ang);
    float s = sin(ang);

    float newX = dir.x * c - dir.y * s;
    float newY = dir.x * s + dir.y * c;

    dir.x = newX;
    dir.y = newY;
  }
}
