class Bullet {
  float x, y, speed = 20, r=5;
  float dx, dy;
  Bullet(float pX, float pY) {
    x = pX;
    y = pY;
    dx = mouseX - pX;
    dy = mouseY - pY;

    float t = sqrt(dx*dx + dy*dy);

    dx /= t;
    dy /= t;
  }

  void update() {
    x += dx*speed;
    y += dy*speed;
  }

  void show() {
    fill(0);
    rectMode(CENTER);
    circle(x, y, r*r);
  }

  boolean isDie() {
    if (x<0 || x > width || y<0 || y > height) {
      return true;
    } else {
      return false;
    }
  }

  boolean isHitted(BasicMonster m) {
    if (pow(abs(m.y-this.y), 2) + pow(abs(m.x-this.x), 2) < pow(abs(m.r + this.r), 2)) {
      return true;
    }
    return false;
  }

  boolean isHitted(BigMonster m) {
    if (pow(abs(m.y-this.y), 2) + pow(abs(m.x-this.x), 2) < pow(abs(m.r + this.r), 2)) {
      return true;
    }
    return false;
  }
}
