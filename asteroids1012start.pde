//CANNOT USE
/*
      ufos.remove(ui);
          break;
        if (du < (max(u.w, u.h) * 0.5 + 3)) {
      Bullet bb = bullets.get(bj);
      asteroids.remove(ai2);
    float s = sin(frameCount * 0.2);
    float pulse = 0.7 + 0.3 * s;
*/

import java.util.ArrayList;

// modes
final int INTRO    = 0;
final int GAME     = 1;
final int PAUSE    = 2;
final int GAMEOVER = 3;

int mode = INTRO;
boolean buttonIsOver = false;
boolean pausedState  = false;

// input
boolean spacekey = false;

// player + game objects
Spaceship player1;
ArrayList<Bullet> bullets;
ArrayList<Asteroid> asteroids;
ArrayList<UFO> ufos;
ArrayList<Particle> particles; // visual particles (thruster + explosions)

// teleport ability cooldown
int teleportCooldown;
int teleportCooldownMax = 300;  // frames until teleport is ready again

// UFO spawn timing
int ufoSpawnTimer;
int ufoSpawnMin = 250;
int ufoSpawnMax = 450;

// player health / invincibility frames
int health = 3;
int damageCooldown = 0;

void setup() {
  size(600, 400);
  rectMode(CENTER);

  player1    = new Spaceship(width*0.5, height*0.6);
  bullets    = new ArrayList<Bullet>();
  asteroids  = new ArrayList<Asteroid>();
  ufos       = new ArrayList<UFO>();
  particles  = new ArrayList<Particle>();

  spawnAsteroids(6);

  ufoSpawnTimer = int(random(ufoSpawnMin, ufoSpawnMax));
  teleportCooldown = 0;
}

void draw() {
  updatePauseState();
  background(30);

  if (damageCooldown > 0) {
    damageCooldown--;
  }

  // teleport cooldown tick
  if (teleportCooldown > 0 && !pausedState) {
    teleportCooldown--;
    if (teleportCooldown < 0) teleportCooldown = 0;
  }

  if (mode == INTRO) {
    drawIntro();
  }
  if (mode == GAME) {
    drawGame();
  }
  if (mode == PAUSE) {
    drawGame(); // still render game underneath pause overlay
  }
  if (mode == GAMEOVER) {
    drawGameOver();
  }
}

void mousePressed() {
  if (mode == INTRO) {
    checkButton(width/2 - 75, height/2, 150, 50);
    if (buttonIsOver) {
      startNewGame();
      mode = GAME;
    }
  }

  if (mode == GAMEOVER) {
    checkButton(width/2 - 75, height/2 + 20, 150, 50);
    if (buttonIsOver) {
      mode = INTRO;

      // reset ship to center, reset velocity, direction, keys
      player1.reset(width*0.5, height*0.6);

      // wipe all objects so intro is clean
      bullets    = new ArrayList<Bullet>();
      asteroids  = new ArrayList<Asteroid>();
      ufos       = new ArrayList<UFO>();
      particles  = new ArrayList<Particle>();

      health = 3;
      damageCooldown = 0;
      teleportCooldown = 0;
    }
  }
}

void keyPressed() {
  if (keyCode == LEFT)  player1.leftkey  = true;
  if (keyCode == RIGHT) player1.rightkey = true;
  if (keyCode == UP)    player1.upkey    = true;

  if (key == ' ') spacekey = true;

  if (key == 'p' || key == 'P') {
    if (mode == GAME)        mode = PAUSE;
    else if (mode == PAUSE)  mode = GAME;
  }

  if (key == 'z' || key == 'Z') {
    tryTeleport();
  }
}

void keyReleased() {
  if (keyCode == LEFT)  player1.leftkey  = false;
  if (keyCode == RIGHT) player1.rightkey = false;
  if (keyCode == UP)    player1.upkey    = false;

  if (key == ' ') spacekey = false;
}

// try to teleport the player ship to a safe spot
void tryTeleport() {
  if (teleportCooldown == 0 && mode == GAME && !pausedState) {
    PVector spot = getSafeTeleportSpot();
    player1.loc.x = spot.x; player1.loc.y = spot.y;
    teleportCooldown = teleportCooldownMax;
  }
}

// pick a random point on screen that is not too close to any asteroid
PVector getSafeTeleportSpot() {
  int tries = 0;
  while (tries < 100) {
    float testX = random(width);
    float testY = random(height);

    boolean safe = true;
    int ai = 0;
    while (ai < asteroids.size()) {
      Asteroid a = asteroids.get(ai);
      float d = dist(testX, testY, a.loc.x, a.loc.y);
      if (d < 200) {
        safe = false;
      }
      ai++;
    }

    if (safe) {
      return new PVector(testX, testY);
    }

    tries++;
  }

  // fallback: no safe found -> stay where you are
  return new PVector(player1.loc.x, player1.loc.y);
}

void drawIntro() {
  fill(255);
  textAlign(CENTER, CENTER);
  textSize(32);
  text("Asteroid Game", width/2, height/2 - 50);
  drawButton("Start Game", width/2 - 75, height/2 - 10, 150, 50);
}

void drawGame() {
  // HUD: HP
  fill(255);
  textAlign(LEFT, TOP);
  textSize(16);
  text("HP (of player):" + health, 10, 10);

  // Teleport cooldown bar (Z to teleport)
  float fullW = 100;
  float fullH = 12;
  float barLeft = 10;
  float barY = 30;
  float readyAmt = teleportCooldownMax - teleportCooldown;
  if (readyAmt < 0) readyAmt = 0;
  float ratio = readyAmt / (float)teleportCooldownMax;
  float fillW = ratio * fullW;

  // outline
  noFill();
  stroke(255);
  strokeWeight(1);
  rect(barLeft + fullW*0.5, barY, fullW, fullH, 3);

  // filling
  noStroke();
  fill(100, 200, 255);
  rectMode(CORNER);
  rect(barLeft, barY - fullH*0.5, fillW, fullH, 3);
  rectMode(CENTER);

  fill(255);
  textSize(10);
  text("Teleport (Z)", barLeft, barY + 14);

  // ===== PARTICLES =====
  int pi = 0;
  while (pi < particles.size()) {
    Particle p = particles.get(pi);

    if (!pausedState) {
      p.act();
    }
    p.show();

    if (p.dead) {
      particles.remove(pi);
    } else {
      pi++;
    }
  }

  // ===== PLAYER SHIP =====
  player1.show();
  if (!pausedState) {
    player1.act();
  }

  // damage cooldown visual ring around player
  if (damageCooldown > 0) {
    float s = sin(frameCount * 0.2);
    float pulse = 0.7 + 0.3 * s;
    noFill();
    stroke(255, 80, 80, 200);
    strokeWeight(2 + 2 * pulse);
    float ringR = player1.boundR * (2.0 + 0.4 * pulse);
    ellipse(player1.loc.x, player1.loc.y, ringR, ringR);
    strokeWeight(1);
    stroke(0, 0);
  }

  // ===== BULLETS =====
  int bi = 0;
  while (bi < bullets.size()) {
    Bullet b = bullets.get(bi);

    if (!pausedState) {
      b.act();
    }
    b.show();

    // UFO bullets can hit the player
    if (!pausedState && b.fromUFO && damageCooldown == 0) {
      float d2 = dist(player1.loc.x, player1.loc.y, b.loc.x, b.loc.y);
      if (d2 < player1.boundR + 3) {
        health--;
        damageCooldown = 60;
        b.dead = true;
      }
    }

    if (b.dead) {
      bullets.remove(bi);
    } else {
      bi++;
    }
  }

  // ===== ASTEROIDS =====
  int ai = 0;
  while (ai < asteroids.size()) {
    Asteroid a = asteroids.get(ai);

    if (!pausedState) {
      a.act();
    }
    a.show();

    if (a.dead) {
      asteroids.remove(ai);
    } else {
      ai++;
    }
  }

  // ===== PLAYER vs ASTEROIDS: DAMAGE + BOUNCE =====
  int k = 0;
  while (k < asteroids.size()) {
    Asteroid a = asteroids.get(k);

    float hitDist = dist(player1.loc.x, player1.loc.y,
                         a.loc.x, a.loc.y);

    boolean touchingNow = (hitDist < player1.boundR + a.r);

    if (touchingNow && damageCooldown == 0) {
      health--;
      damageCooldown = 60;
    }

    circleBounce(player1.loc, player1.vel, player1.boundR,
                 a.loc, a.vel, a.r);

    k++;
  }

  // ===== PLAYER BULLET vs ASTEROID =====
  int ai2 = 0;
  while (ai2 < asteroids.size()) {
    Asteroid a = asteroids.get(ai2);

    int bi2 = 0;
    boolean asteroidHit = false;

    while (bi2 < bullets.size()) {
      Bullet bb = bullets.get(bi2);
      // only player's bullets can break asteroids
      if (!bb.fromUFO) {
        float dab = dist(bb.loc.x, bb.loc.y, a.loc.x, a.loc.y);
        if (dab < a.r + 3) {
          // bullet hit asteroid
          asteroidHit = true;
          bb.dead = true;

          // spawn children (split)
          a.onHit(asteroids);

          // explosion particles for asteroid
          spawnExplosion(a.loc.x, a.loc.y, 14);
        }
      }

      bi2++;
    }

    if (asteroidHit) {
      asteroids.remove(ai2);
    } else {
      ai2++;
    }
  }

  // ===== UFOs =====
  if (!pausedState) {
    ufoSpawnTimer--;
    if (ufoSpawnTimer <= 0) {
      ufos.add(new UFO());
      ufoSpawnTimer = int(random(ufoSpawnMin, ufoSpawnMax));
    }
  }

  int ui = 0;
  while (ui < ufos.size()) {
    UFO u = ufos.get(ui);

    if (!pausedState) {
      u.act();
    }
    u.show();

    // check collision of player bullet vs UFO (kill UFO)
    int bj = 0;
    boolean ufoHit = false;
    while (bj < bullets.size()) {
      Bullet bb = bullets.get(bj);
      if (!bb.fromUFO) {
        float du = dist(bb.loc.x, bb.loc.y, u.loc.x, u.loc.y);
        if (du < (max(u.w, u.h) * 0.5 + 3)) {
          u.dead = true;
          bb.dead = true;
          ufoHit = true;

          // explosion particles for UFO
          spawnExplosion(u.loc.x, u.loc.y, 18);
        }
      }

      bj++;
    }

    if (u.dead || ufoHit) {
      ufos.remove(ui);
    } else {
      ui++;
    }
  }

  // ===== HEALTH CHECK =====
  if (health <= 0) {
    mode = GAMEOVER;
  }

  // ===== PAUSE OVERLAY =====
  if (pausedState) {
    fill(255, 255, 255, 180);
    rectMode(CENTER);
    rect(width/2, height/2, 300, 200, 10);

    fill(0);
    textAlign(CENTER, CENTER);
    textSize(20);
    text("PAUSED", width/2, height/2 - 20);

    textSize(12);
    text("Press P to resume", width/2, height/2 + 10);
    text("HP: " + health, width/2, height/2 + 30);

    textSize(10);
    text("Teleport cooldown: " + teleportCooldown, width/2, height/2 + 50);

    fill(255);
    textAlign(CENTER, CENTER);
    textSize(16);
    text("Back to Intro", width/2, height/2 + 80);
    drawButton("Back to Intro", width/2 - 75, height/2 + 100, 150, 50);
  }
}

void drawGameOver() {
  fill(255);
  textAlign(CENTER, CENTER);
  textSize(24);
  text("Game Over", width/2, height/2 - 50);
  drawButton("Back to Intro", width/2 - 75, height/2 + 20, 150, 50);
}

void updatePauseState() {
  pausedState = (mode == PAUSE);
}

// ===== Helpers =====
void startNewGame() {
  player1.reset(width*0.5, height*0.6);

  bullets    = new ArrayList<Bullet>();
  asteroids  = new ArrayList<Asteroid>();
  ufos       = new ArrayList<UFO>();
  particles  = new ArrayList<Particle>();

  spawnAsteroids(6);

  health = 3;
  damageCooldown = 0;
  teleportCooldown = 0;
  ufoSpawnTimer = int(random(ufoSpawnMin, ufoSpawnMax));
}

// make some starting asteroids
void spawnAsteroids(int count) {
  int k = 0;
  while (k < count) {
    asteroids.add(new Asteroid(1, new PVector(random(width), random(height))));
    k++;
  }
}

// create many explosion particles at (x,y)
void spawnExplosion(float x, float y, int amount) {
  int i = 0;
  while (i < amount) {
    // random direction + speed
    float ang = random(TWO_PI);
    float spd = random(1.5, 4.0);
    float vx = cos(ang) * spd;
    float vy = sin(ang) * spd;

    particles.add(new Particle(x, y, vx, vy, true));
    i++;
  }
}

// circle bounce resolution and basic elastic velocity swap
void circleBounce(PVector p1, PVector v1, float r1,
                  PVector p2, PVector v2, float r2) {

  float dx = p2.x - p1.x;
  float dy = p2.y - p1.y;

  float distSq = dx*dx + dy*dy;
  float minDist = r1 + r2;

  if (distSq == 0) {
    dx = 0.01;
    dy = 0;
    distSq = dx*dx + dy*dy;
  }

  float distActual = sqrt(distSq);
  if (distActual < minDist) {
    float overlap = (minDist - distActual) * 0.5;

    float nx = dx / distActual;
    float ny = dy / distActual;

    p1.x -= nx * overlap;
    p1.y -= ny * overlap;
    p2.x += nx * overlap;
    p2.y += ny * overlap;

    float tx = -ny;
    float ty = nx;

    float v1n = v1.x*nx + v1.y*ny;
    float v1t = v1.x*tx + v1.y*ty;

    float v2n = v2.x*nx + v2.y*ny;
    float v2t = v2.x*tx + v2.y*ty;

    float v1nAfter = v2n;
    float v2nAfter = v1n;

    v1.x = v1nAfter*nx + v1t*tx;
    v1.y = v1nAfter*ny + v1t*ty;

    v2.x = v2nAfter*nx + v2t*tx;
    v2.y = v2nAfter*ny + v2t*ty;
  }
}
