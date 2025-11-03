//CANNOT USE
/*
THIS () FUNCTION;
super();
.set (i am unsure if this is allowed)

void spawnChildren(ArrayList<Asteroid> asts, int childType, int count) {
  PVector p = loc.copy();
  PVector jitter = new PVector(random(-4, 4), random(-4, 4));
  p.add(jitter);
- unsure if i can use those functions
*/

class Asteroid extends GameObject {
  // Types: 1 = Large (triangle inside), 2 = Medium (rectangle), 3 = Small (circle)
  int type;
  float r; // visual radius and hit radius

  Asteroid() {
    this(1, new PVector(random(width), random(height)));
  }

  Asteroid(int t, PVector startPos) {
    // manual "super"
    type = t;
    loc = new PVector(startPos.x, startPos.y);
    vel = new PVector(0, 0);
    dead = false;

    // random movement direction + speed based on type
    float ang = random(TWO_PI);
    float spd;
    if (type == 1) {
      r = 32;                 // largest
      spd = random(1.0, 2.0);
    } else if (type == 2) {
      r = 22;                 // medium
      spd = random(1.5, 2.7);
    } else {
      r = 12;                 // smallest
      spd = random(2.0, 3.6);
    }
    vel.x = cos(ang) * spd;
    vel.y = sin(ang) * spd;
  }

  void act() {
    loc.x += vel.x;
    loc.y += vel.y;
    wrapAround();
  }

  void show() {
    noStroke();
    fill(160);
    circle(loc.x, loc.y, r*2);

    pushMatrix();
    translate(loc.x, loc.y);
    rotate(frameCount * 0.01);

    fill(60);
    noStroke();

    if (type == 1) {
      // triangle
      beginShape();
      vertex(0, -r*0.8);
      vertex(-r*0.6, r*0.7);
      vertex(r*0.6, r*0.7);
      endShape(CLOSE);
    } else if (type == 2) {
      // rectangle
      rectMode(CENTER);
      rect(0, 0, r*0.9, r*0.55);
    } else {
      // tiny circle
      circle(0, 0, r*0.8);
    }
    popMatrix();
  }

  void wrapAround() {
    float m = r;
    if (loc.x < -m)              loc.x = width + m;
    else if (loc.x > width + m)  loc.x = -m;
    if (loc.y < -m)              loc.y = height + m;
    else if (loc.y > height + m) loc.y = -m;
  }

  // called when a player's bullet hits this asteroid
  void onHit(ArrayList<Asteroid> asts) {
    if (type == 1) {
      // split into two Type 2
      spawnChildren(asts, 2, 2);
    } else if (type == 2) {
      // split into two Type 3
      spawnChildren(asts, 3, 2);
    }
    // type 3 just dies
    dead = true;
  }

  void spawnChildren(ArrayList<Asteroid> asts, int childType, int count) {
    int i = 0
    ;
    while (i < count) {
      // start near parent with little randomness
      float px = loc.x + random(-4, 4);
      float py = loc.y + random(-4, 4);
      PVector p = new PVector(px, py);

      Asteroid child = new Asteroid(childType, p);

      asts.add(child);
      i++;
    }
  }
}

//USE MORE GENERAK NUMBERS#!!!
