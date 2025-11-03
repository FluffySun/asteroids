class GameObject {
  PVector loc;
  PVector vel;
  boolean dead;

  GameObject() {
    loc = new PVector(0, 0);
    vel = new PVector(0, 0);
    dead = false;
  }

  GameObject(float startX, float startY) {
    loc = new PVector(startX, startY);
    vel = new PVector(0, 0);
    dead = false;
  }

  void act() {
    // default empty
  }

  void show() {
    // default empty
  }
}
