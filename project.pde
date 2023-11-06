import java.util.*;
import processing.sound.*;

Player p;

SoundFile[] sf = new SoundFile[1];

int startTime, monsterTime, bigMonsterTime;//시작시간체크, 몬스터시간체크,

int setTimeUp;
int bi=0, bmi=0, bigi=0; //총알 포문, 베이직몬스터 포문, 빅몬스터 포문
float basicMonsterSpeed, bigMonsterHp; //셋업
int spawnRate, bigSpawnRate, setTimeUpRate;
int score; //점수
boolean gameOn;

ArrayList< Bullet > b = new ArrayList< Bullet >(); //총알을 생성하고 배열에 담기 위해 생성
ArrayList< BasicMonster > bm = new ArrayList< BasicMonster >(); //몬스터를 생성하고 배열에 담기 위해 생성
ArrayList< BigMonster > bigm = new ArrayList< BigMonster >(); //빅몬스터를 생성하고 배열에 담기 위해 생성

void setup() {
  size(2550, 1400); //캔버스 크기
  //size(1800, 900);
  gameOn = true;
  score=0;
  p = new Player();
  startTime = millis();
  monsterTime = millis();
  bigMonsterTime = millis();
  setTimeUp = millis();
  spawnRate = 400;
  bigSpawnRate = 8000;
  setTimeUpRate = 20000;
  basicMonsterSpeed = 5;
  bigMonsterHp = 10;
}

void draw() {
  background(255);  //기본 UI

  textSize(70);
  textAlign(CENTER);
  fill(255, 0, 0);
  text("HP " + p.getHp() +"/5", width/2, 70);
  fill(0);
  text("SCORE : "+score, width-200, 70);

  p.showPlayer();
  p.moveP();

  checkScoreForFireRate();

  if (p.getHp() <= 0) { //체력이 0일때 실행
    gameOver();
  }

  if (millis() - monsterTime > spawnRate) { //spawnRate 밀리초 마다 베이직몬스터 생성
    BasicMonster bmm = new BasicMonster(p.getX(), p.getY(), basicMonsterSpeed);
    bm.add(bmm);
    bmi ++;
    monsterTime = millis();
  }

  if (millis() - startTime > p.getFireRate()) { //fireRate 밀리초 마다 총알 발사
    sf[0] = new SoundFile(this, "shootSound.mp3");
    sf[0].play();
    Bullet bb = new Bullet(p.getX(), p.getY());
    b.add(bb);
    bi ++;
    startTime = millis();
  }

  if (millis() - bigMonsterTime > bigSpawnRate) { //bigSpawnRate 밀리초 마다 빅몬스터 생성
    BigMonster big = new BigMonster(p.getX(), p.getY(), bigMonsterHp);
    bigm.add(big);
    bigi++;
    bigMonsterTime = millis();
  }

  if (millis() - setTimeUp > setTimeUpRate) { //20초마다 난이도 업
    bigMonsterHp+=1;
    basicMonsterSpeed += 0.1;
    setTimeUp = millis();
  }

  for (int i = bm.size() -1; i>= 0; i--) {
    BasicMonster monster = bm.get(i);
    if (p.isCrashed(monster)) { //플레이어와 베이직몬스터의 충돌 판별
      bm.remove(i);

      bmi--;
      p.crackedBasic();

      break;
    }
  }

  for (int i = bigm.size() -1; i>=0; i--) { //플레이어와 빅몬스터의 충돌 판별
    BigMonster bMonster = bigm.get(i);
    if (p.isCrashed(bMonster)) {
      bigm.remove(i);

      bigi--;
      p.crackedBig();

      break;
    }
  }

  for (int i = b.size() - 1; i >= 0; i--) { //베이직몬스터가 총알에 맞았을때
    Bullet bu = b.get(i);
    for (int j = bm.size() - 1; j >= 0; j--) {
      BasicMonster monster = bm.get(j);
      if (bu.isHitted(monster)) { //맞았으면 실행
        b.remove(i);
        bm.remove(j);
        bi--;
        bmi--;
        score++;
        break;
      }
    }
  }

  for (int i = b.size() - 1; i >= 0; i--) { //빅몬스터가 총알에 맞았을때
    Bullet bu = b.get(i);
    for (int j = bigm.size() - 1; j >= 0; j--) {
      BigMonster bMonster = bigm.get(j);
      if (bu.isHitted(bMonster)) {
        bMonster.hitted();//맞았으면 실행
        b.remove(i);
        bi--;
        if (bMonster.checkHp()) { //체력이 0이 되면 실행
          bigm.remove(j);
          bigi--;
          score+=bigMonsterHp+1.5;
          break;
        }
      }
    }
  }

  for (int i = bm.size() - 1; i >= 0; i--) { //베이직몬스터를 배열에서 하나씩 꺼내와서 보여주고 업데이트
    BasicMonster b = bm.get(i);

    b.show();
    b.update();

    if (b.isMonsterOut()) { //베이직몬스터가 밖으로 나갔을때 제거
      bm.remove(b);
      bmi--;
    }
  }

  for (int i = bigm.size() - 1; i >= 0; i--) { //빅몬스터를 배열에서 하나씩 꺼내와서 보여주고 업데이트
    BigMonster b = bigm.get(i);

    b.show();
    b.update();

    if (b.isMonsterOut()) { //빅몬스터가 밖으로 나갔을때 제거
      bigm.remove(b);
      bigi--;
    }
  }

  for (int i = b.size() - 1; i >= 0; i--) { //총알을 배열에서 하나씩 꺼내와서 보여주고 업데이트
    Bullet bu = b.get(i);

    bu.show();
    bu.update();

    if (bu.isDie()) { //총알이 밖으로 나갔을때 제거
      b.remove(bu);
      bi--;
    }
  }
}

void gameOver() {
  gameOn = false;
  textAlign(CENTER);
  textSize(200);
  fill(255, 0, 0);
  text("GAME OVER!", width/2, height/2);
  fill(0);
  textSize(50);
  rectMode(CENTER);
  rect(width/2, height/4*3-20, 700, 100);
  fill(255);
  text("ENTER TO RESTART GAME", width/2, height/4 * 3);
  fill(0, 255, 0);
  textSize(150);
  text("FINAL SCORE : " + score, width/2, height/4);
  noLoop();
}

void reStartGame() {
  b.clear();
  bm.clear();
  bigm.clear();
  bi = 0;
  bmi = 0;
  bigi = 0;
  gameOn = true;
  score=0;
  p = new Player();
  startTime = millis();
  monsterTime = millis();
  bigMonsterTime = millis();
  setTimeUp = millis();
  spawnRate = 400;
  bigSpawnRate = 8000;
  setTimeUpRate = 20000;
  basicMonsterSpeed = 5;
  bigMonsterHp = 10;
  loop();
}

void checkScoreForFireRate() {
  if (score < 100) {    //100스코어마다 fireRate 증가
    p.changeFireRate(500);
  } else if (score < 200) {
    p.changeFireRate(420);
  } else if (score < 300) {
    p.changeFireRate(360);
  } else if (score < 400) {
    p.changeFireRate(280);
  } else if (score < 450) {
    p.changeFireRate(270);
  } else if (score < 500) {
    p.changeFireRate(260);
  } else if (score < 550) {
    p.changeFireRate(250);
  } else if (score < 600) {
    p.changeFireRate(240);
  } else if (score < 650) {
    p.changeFireRate(230);
  } else if (score < 700) {
    p.changeFireRate(220);
  } else if (score < 800) {
    p.changeFireRate(210);
  } else if (score < 850) {
    p.changeFireRate(200);
  }
}

void keyPressed() { //키를 눌렀을때 작동
  p.move(key, keyCode); //wasd 를 눌렀을때를 판별하기 위해 보냄

  if (keyCode == ENTER) { //만약 ENTER 키를 누르면 재시작
    if (!gameOn) reStartGame();
  }
}

void keyReleased() { //키를 땠을때 작동
  p.stop(key, keyCode); //누르고 있던 키를 땠을때를 판별하기 위해 보냄
}
