/*
NOTES:
- no loc.set()
- no .copy(), .setMag(), etc.
*/

class UFO extends GameObject {
  float w;
  float h;

  int shootCooldown;
  int shootGapMin = 45;
  int shootGapMax = 80;

  UFO() {
    // manual "super"
    dead = false;
    w = 40;
    h = 20;

    // spawn on left or right side randomly
    if (random(1) < 0.5) {
      float ly = random(40, height - 40);
      loc = new PVector(-w, ly);
      float vx = random(1.0, 2.5);
      vel = new PVector(vx, 0);
    } else {
      float ly = random(40, height - 40);
      loc = new PVector(width + w, ly);
      float vx = random(-2.5, -1.0);
      vel = new PVector(vx, 0);
    }

    shootCooldown = int(random(shootGapMin, shootGapMax));
  }

  void act() {
    // move
    loc.x += vel.x;
    loc.y += vel.y;

    // offscreen = die
    if (loc.x < -w*2 || loc.x > width + w*2) {
      dead = true;
    }

    // shoot cooldown counting down
    shootCooldown--;
    if (shootCooldown < 0) {
      shootCooldown = 0;
    }

    // fire bullet toward player
    if (shootCooldown == 0 && !dead) {
      // aim vector from UFO to player
      PVector toPlayer = new PVector(player1.loc.x - loc.x,
                                     player1.loc.y - loc.y);

      // normalize safely
      float mag = sqrt(toPlayer.x*toPlayer.x + toPlayer.y*toPlayer.y);
      float normX = 0;
      float normY = 0;
      if (mag > 0) {
        normX = toPlayer.x / mag;
        normY = toPlayer.y / mag;
      }

      // UFO bullet velocity
      PVector v = new PVector(normX * 6.0,
                              normY * 6.0);

      // use Bullet's UFO-style constructor (fromUFO = true)
      bullets.add(new Bullet(loc.x, loc.y, v, true));

      shootCooldown = int(random(shootGapMin, shootGapMax));
    }
  }

  void show() {
    pushMatrix();
    translate(loc.x, loc.y);

    noStroke();
    fill(100, 255, 200);
    ellipse(0, 0, w, h);

    fill(30);
    ellipse(0, 0, w*0.5, h*0.5);

    popMatrix();
  }
}
