// adapted from the "BouncyBubbles" example.

//setup for bg music
import processing.sound.*;
SoundFile song;

//bg image
PImage bg, menu, ground, cactus1, cactus2, cactus3, grass, skull, train, wagon1, wagon2, cross, tnt, whiskey, tumbleweed, good, ok, bad;

int numBubbles = 40; // initial bubble count
final int BROKEN = -99; // code for "broken", may have other states later
final int MAXDIAMETER = 120; // maximum size of expanding bubble

ArrayList pieces; // all the playing pieces

//resources and scoring
int numTnt = 5;
int numWeeds = 0;
int numWhiskey = 0;
int cash = 0;

//timer vars
int begin; 
int duration = 20;
int time = 20;
int elapsed = 0;
int pauseTime;

//game font
PFont font;

// game state variables
public enum GameState {
  INTRO, PLAY, PAUSE, GAMEBAD, GAMEOK, GAMEGOOD
}
GameState gs;

void setup() {
  size(1467, 768);
  noStroke();
  smooth();

  //load images for background/scenery
  bg = loadImage ("scene.png");
  menu = loadImage ("menu.png");
  ground = loadImage ("Ground.png");
  cactus1 = loadImage ("Cactus1.png");
  cactus2 = loadImage ("Cactus2.png");
  cactus3 = loadImage ("Cactus3.png");
  grass = loadImage ("Grass.png");
  skull = loadImage ("Skull.png");
  train = loadImage ("train.png");
  wagon1 = loadImage ("wagon1.png");
  wagon2 = loadImage ("wagon2.png");
  //load cursor image
  cross = loadImage ("cross.png");
  //status icons
  whiskey = loadImage ("Whiskey.png");
  tumbleweed = loadImage ("TumbleWeed.png");
  tnt = loadImage ("TNT.png");
  //ending screens
  good = loadImage ("endGood.png");
  ok = loadImage ("endOK.png");
  bad = loadImage ("endBad.png");
  //set the font
  font = loadFont("Courier.vlw");

  song = new SoundFile(this, "ZitronSound - Lonely Cowboy.mp3");
  song.loop();

  //set game state to start screen
  gs = GameState.INTRO;
}

void start() {
  //reset counters
  numWeeds = 0;
  numWhiskey = 0;
  numTnt = 5;
  duration = 20;
  time = 20;

  pieces = new ArrayList(numBubbles);
  for (int i = 0; i < numBubbles; i++) {
    float type = random(0, 3);
    pieces.add(new Bubble(random(100, width-100), random(100, height-100), 70, i, pieces, type, false));
  }
  //start timer
  begin = millis();
  gs = GameState.PLAY;
}

void draw() {
  //draw cursor
  cursor(cross, 15, 15);

  switch(gs) {
  case INTRO:
    background(menu);
    break;
  case PAUSE:
    drawScreen("PAUSED", "Press p to resume");
    elapsed = millis() - pauseTime;
    break;
  case GAMEGOOD:
    background(good);
    pieces.clear();
    finalScore();
    break;
  case GAMEOK:
    background(ok);
    pieces.clear();
    finalScore();
    break;
  case GAMEBAD:
    background(bad);
    this.pieces.clear();
    finalScore();
    break;
  case PLAY:
    //draw scenery
    background(bg);
    drawScenery();

    //countdown
    if (time > 0)  
      time = duration - (millis() - begin)/1000;

    if (time < 1) {
      //calculating the cost and gain of cash based on resources used
      //tnt total used is taken off
      int t = (5-numTnt) * 50;
      //tumbleweeds are added on, based on percentage destroyed
      int d = numWeeds * 100;
      //whisky is taken off
      int w = numWhiskey * 250;
      //final cash value calculated
      cash = -t + d - w;

      //dtermine outcome from cash earned
      if (cash > 649)
        gs = GameState.GAMEGOOD;
      else if (cash > 0 && cash < 650)
        gs = GameState.GAMEOK;
      else
        gs = GameState.GAMEBAD;
    } else {     
      for (int i = 0; i < numBubbles; i++) {
        Bubble b = (Bubble)pieces.get(i); // get the current piece

        if (b.diameter < 1) { // if too small, remove         
          pieces.remove(i);
          numBubbles--;
          i--;
          //count for score
          if (!b.isClick) {
            if (b.type < 2)
              numWeeds++;
            else
              numWhiskey++;
          }
        } else {
          // check collisions, update state, and draw this piece
          if (b.broken == BROKEN) // only bother to check collisions with broken bubbles
            b.collide();

          b.update();
          b.display();
        }
      }
    }
    //update score
    score();
    break;
  }   //end of game case switch
}

void mousePressed() {  
  //be sure the Tnt isn't used up
  if (numTnt > 0) {
    numTnt --;
    // on click, create a new burst bubble at the mouse location and add it to the field      
    Bubble b = new Bubble(mouseX, mouseY, 2, numBubbles, pieces, -1, true);
    b.burst();
    pieces.add(b);
    numBubbles++;
  }
}

void keyPressed()
{ 
  if (key== ' ' && ( gs == GameState.INTRO || gs == GameState.GAMEGOOD || gs == GameState.GAMEOK || gs == GameState.GAMEBAD )) { 
    start();
  }
  if (key=='p' && gs == GameState.PLAY) {
    pauseTime = millis();
    gs = GameState.PAUSE;
  } else if (key=='p' && gs == GameState.PAUSE) {
    begin += elapsed;
    gs = GameState.PLAY;
    println(begin);
  }
}

void score() {
  textSize(38);
  textAlign(LEFT, BOTTOM);
  //whiskey
  text(numWhiskey, 80, 65);
  //weeds
  text(numWeeds, 320, 65);
  //tnt
  text(numTnt, 650, 65);
  //time left
  text("Time Left: " + time, 1050, 65);
}

void finalScore() {
  //set text params
  textSize(38);
  textAlign(LEFT, BOTTOM);
  //print the stats in the appropriate place
  text(5-numTnt, 505, 161);
  text(numWeeds, 805, 212);
  text(numWhiskey, 755, 263);
  text("$" + cash, 775, 450);
}

void drawScenery() {

  //draw train
  train.resize(170, 0);
  image(train, 1060, 630);
  wagon1.resize(120, 0);
  image(wagon1, 1229, 685);
  wagon2.resize(120, 0);
  image(wagon2, 1350, 685);

  //draw ground, and grass
  int x = -30;
  for (int i=0; i<23; i++) {
    image(ground, x, 690);
    x += 66;
    if (i%5 == 2 || i%2 == 0)  //grass appears random
      image(grass, x, 690);
  }
  //draw cactus
  image(cactus1, 23, 550);
  image(cactus1, 550, 550);
  image(cactus2, 803, 710);
  image(cactus3, 300, 710);
  //draw skull
  image(skull, 520, 665);

  //draw stats bar
  image(whiskey, 25, 15);
  image(tumbleweed, 250, 15);
  image(tnt, 600, 15);
}

void drawScreen(String title, String instructions) 
{
  background(0, 0, 0);

  // draw title
  fill(255, 100, 0);
  textSize(60);
  textAlign(CENTER, BOTTOM);
  text(title, width/2, height/2);

  // draw instructions
  fill(255, 255, 255);
  textSize(32);
  textAlign(CENTER, TOP);
  text(instructions, width/2, height/2);
}
