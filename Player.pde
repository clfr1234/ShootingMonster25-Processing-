class Player {
  float x, y, r, speed, fireRate;
  int hp;
  color c;
  boolean top=false, bottom = false, left = false, right = false;
  Player() {
    this.x = width/2;
    this.y = height/2;
    this.r = 10;
    this.speed = 6;
    c = color(0);

    fireRate = 500;
    hp = 5;
  }

  void showPlayer() {
    fill(c);
    circle(x, y, r*r);
    fill(255);
    textSize(30);
    text("PLAYER",x,y+10);
  }

  float getY() {
    return y;
  }
  float getX() {
    return x;
  }

  float getFireRate() {
    return fireRate;
  }

  int getHp() {
    return hp;
  }

  void crackedBasic() {
    hp--;
  }

  void crackedBig() {
    hp-=2;
  }

  void move(char k, int kc) {
    if (k == 'a' || kc == 37) {
      left = true;
    } else if (k == 'w' || kc == 38) {
      top = true;
    } else if (k == 's' || kc == 40) {
      bottom = true;
    } else if (k == 'd' || kc == 39) {
      right = true;
    }
  }

  void stop(char k, int kc) {
    if (k == 'w' || kc == 38) {
      top = false;
    } else if (k == 'a' || kc == 37) {
      left = false;
    } else if (k == 's' || kc == 40) {
      bottom = false;
    } else if (k == 'd' || kc == 39) {
      right = false;
    }
  }

  void moveP() {
    if (top == true && left == true && bottom == false && right == false && y-speed >=0 && x-speed > 0) { //왼쪽 위로
        y -= speed;
        x -= speed;
    } else if (left == true && bottom == true && right == false && top == false && y+speed < height && x-speed > 0) { //왼쪽 아래로
        y += speed;
        x -= speed;
    } else if (bottom == true && right == true && top == false && left == false && y+speed < height && x+speed < width) { //오른쪽 아래로
        y += speed;
        x += speed;
    } else if (right == true && top == true && left == false && bottom == false && y-speed > 0 && x+speed < width) { //오른쪽 위로
        y -= speed;
        x += speed;
    } else if (top == true && left == false && bottom == false && right == false && y-speed > 0) { //위로
        y -= speed;
    } else if (left == true && bottom == false && right == false && top == false && x-speed > 0) { //왼쪽
        x -= speed;
    } else if (bottom == true && right == false && top == false && left == false && y+speed < height) { //아래로
        y += speed;
    } else if (right == true && top == false && left == false && bottom == false && x+speed < width) { //오른쪽
        x += speed;
    } else if (top == true && left == true && bottom == true && right == false && x-speed > 0) { //왼쪽
        x -= speed;
    } else if (left == true && bottom == true && right == true && top == false && y+speed < height) { //아래로
        y += speed;
    } else if (bottom == true && right == true && top == true && left == false && x+speed < width) { //오른쪽
        x += speed;
    } else if (right == true && top == true && left == true && bottom == false && y-speed > 0) { //위로
        y -= speed;
    }
  }

  boolean isCrashed(BasicMonster m) {
    if (pow(abs(m.y-this.y), 2) + pow(abs(m.x-this.x), 2) < pow(abs(m.r + this.r), 2)) {
      return true;
    }
    return false;
  }

  boolean isCrashed(BigMonster m) {
    if (pow(abs(m.y-this.y), 2) + pow(abs(m.x-this.x), 2) < pow(abs(m.r + this.r), 2)) {
      return true;
    }
    return false;
  }

  void changeFireRate(int fireRate) {
    this.fireRate = fireRate;
  }
}
