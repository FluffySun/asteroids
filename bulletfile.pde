class Bullet extends GameObject {
  int timer;        // counts down until bullet disappears
  boolean fromUFO;  // false = player bullet, true = UFO bullet

  // === PLAYER BULLET CONSTRUCTOR ===
  Bullet(float x, float y, PVector shipDir, PVector shipVel) {
    // manual "super"
    loc = new PVector(x, y);
    vel = new PVector(0, 0);
    dead = false;

    // direction of ship nose
    float dirX = shipDir.x;
    float dirY = shipDir.y;

    // make that direction length 10
    float mag = sqrt(dirX*dirX + dirY*dirY);
    if (mag > 0) {
      dirX = (dirX / mag) * 10;
      dirY = (dirY / mag) * 10;
    }

    // bullet inherits ship velocity
    vel.x = dirX + shipVel.x;
    vel.y = dirY + shipVel.y;

    // lifetime
    timer = 90;
    fromUFO = false;
  }

  // === UFO BULLET CONSTRUCTOR ===
  Bullet(float x, float y, PVector v, boolean isFromUFO) {
    // manual "super"
    loc = new PVector(x, y);
    vel = new PVector(v.x, v.y);
    dead = false;

    timer = 240;
    fromUFO = isFromUFO;
  }

  void act() {
    // move forward
    loc.x += vel.x;
    loc.y += vel.y;

    // timer down
    timer--;
    if (timer < 0) {
      timer = 0;
    }
    if (timer == 0) {
      dead = true;
    }

    wrapAround();
  }

  void show() {
    noStroke();
    if (fromUFO) {
      fill(255, 120, 120);
    } else {
      fill(255, 255, 100);
    }
    ellipse(loc.x, loc.y, 5, 5);
  }

  void wrapAround() {
    float r = 5; // margin

    if (loc.x < -r)             loc.x = width + r;
    else if (loc.x > width + r) loc.x = -r;

    if (loc.y < -r)             loc.y = height + r;
    else if (loc.y > height + r)loc.y = -r;
  }
}
