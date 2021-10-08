class Bubble 
{
  PImage whiskey, tnt, tumbleweed;
  
  float x, y;
  float diameter;
  float vx = 0;
  float vy = 0;
  int id;
  int broken = 0;
  float growrate = 0;
  ArrayList others;
  boolean isClick;
  //determine what kind of bubble this is (good or bad)
  float type;
  
  Bubble(float xin, float yin, float din, int idin, ArrayList oin, float type, boolean isClick) 
  {
    whiskey = loadImage ("Whiskey.png");
    tumbleweed = loadImage ("TumbleWeed.png");
    tnt = loadImage ("TNT.png");

    //xin and yin are placements on the screen
    x = xin;
    y = yin;
    diameter = din;
    growrate = 0;
    //object number
    id = idin;
    //increase speed a bit by decreasing denominator
    vx = random(0,100)/35. - 1.;
    vy = random(0,100)/35. - 1.;
    //array of others
    others = oin;
    //check if the player placed the bubble
    this.isClick = isClick;
    //asign type
    this.type = type;
  } 
  
  
  void burst()
  {
      if (this.broken != BROKEN) // only burst once
      {
         this.broken = BROKEN;
         this.growrate = 2; // start it expanding
      }   
  }
  
  void collide() 
  {
      Bubble b;
      // check collisions with all bubbles
      for (int i = 0; i < numBubbles; i++) 
      {      
         b = (Bubble)others.get(i);
         float dx = b.x - x;
         float dy = b.y - y;
         float distance = sqrt(dx*dx + dy*dy);
         //adjust min distance to diameter/3 to account for transparency in image
         float minDist = b.diameter/3 + diameter/3;
     
         if (distance < minDist) 
         {   // collision has happened
             if ((this.broken == BROKEN) || (b.broken == BROKEN))
             {
                // broken bubbles cause others to break also
                b.burst();
             }
         }
     }   
  }
  
  
  void update() 
  {
     if (this.broken == BROKEN)
     {
         this.diameter += this.growrate;
 
         if (this.diameter > MAXDIAMETER) // reached max size
               this.growrate = -1.75; // start shrinking
     }
     else
     {
        // move via Euler integration
        x += vx;
        y += vy;
  
       // the rest: reflect off the sides and top and bottom of the screen
       if (x + diameter/2 > width) 
       {
           x = width - diameter/2;
           vx *= -1; 
       }
       else if (x - diameter/2 < 0) 
       {
           x = diameter/2;
           vx *= -1;
       }

       if (y + diameter/2 > (height-100)) 
       {
           y = (height-100) - diameter/2;
           vy *= -1; 
       } 
       else if (y - diameter/2 < 100) 
       {
           y = 100 + diameter/2;
           vy *= -1;
       }
      
    }
  }
  
  
  
  void display() 
  {
    //load image in center of bubble, then reset image mode to draw background
    imageMode(CENTER);
    //the player bubble is tnt
    if(isClick)
      image(tnt,x,y,diameter,diameter);
    //object bubbles
    else{
      if(type < 2)
        image(tumbleweed,x,y,diameter,diameter); 
      else
        image(whiskey,x,y,diameter,diameter); 
    }
    imageMode(CORNER);
  }
  
}
