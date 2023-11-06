class BasicMonster {

  float x, y, dx, dy, speed, r;
  color c;

  BasicMonster(float x, float y, float speed) {
    int spawnPosition = int(random(4));

    if (spawnPosition == 0) {
      // 왼쪽에서 생성
      this.x = 0;
      this.y = random(0, height);
    } else if (spawnPosition == 1) {
      // 오른쪽에서 생성
      this.x = width;
      this.y = random(0, height);
    } else if (spawnPosition == 2) {
      // 위에서 생성
      this.x = random(0, width);
      this.y = 0;
    } else {
      // 아래에서 생성
      this.x = random(0, width);
      this.y = height;
    }

    dx = this.x - x;
    dy = this.y - y;

    float t = sqrt(dx*dx + dy*dy); //벡터 정규화

    dx /= t;
    dy /= t;

    c = color(random(255), random(255), random(255));

    r = 50;

    this.speed = speed;
  }

  void show() {
    fill(c);
    circle(x, y, r);
  }

  void update() {
    x -= dx*speed;
    y -= dy*speed;
  }

  boolean isMonsterOut() {
    if (x<0 || x > width || y<0 || y > height) {
      return true;
    } else {
      return false;
    }
  }
}
