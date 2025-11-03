class Particle extends GameObject {
  float alpha;   // transparency (255 = solid, 0 = invisible)
  float size;    // how big the particle is when drawn

  // isExplode tells us what style to draw:
  // true  = explosion particle (bright burst)
  // false = thruster flame (engine fire)
  boolean isExplode;

  Particle(float x, float y, float vx, float vy, boolean explodeStyle) {
    // manual "super"
    loc = new PVector(x, y);
    vel = new PVector(vx, vy);
    dead = false;

    alpha = 255;
    size = random(3, 6);
    isExplode = explodeStyle;
  }

  void act() {
    // move
    loc.x += vel.x;
    loc.y += vel.y;

    // slow down a tiny bit so they drift nicely
    vel.x = vel.x * 0.97;
    vel.y = vel.y * 0.97;

    // fade out
    alpha -= 6;
    if (alpha < 0) {
      alpha = 0;
    }

    // if invisible -> mark dead so main loop removes it
    if (alpha == 0) {
      dead = true;
    }
  }

  void show() {
    noStroke();

    if (isExplode) {
      // explosion: brighter / more white-yellow
      fill(255, 220, 120, alpha);
    } else {
      // thruster flame: orangey/red
      fill(255, 100, 60, alpha);
    }

    ellipse(loc.x, loc.y, size, size);
  }
}
