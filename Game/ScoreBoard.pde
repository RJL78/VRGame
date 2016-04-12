PGraphics scoreBoardBackGround;
int aestheticCorrection = 50;
int scoreBoardColor = new Color(255, 255, 255).getRGB();

void setupScoreBoard() {
  scoreBoardBackGround = createGraphics(screenWidth, screenHeight/6+aestheticCorrection , P2D);
 
}

void drawScoreBoard(){
  
  scoreBoardBackGround.beginDraw();
  scoreBoardBackGround.background(255,255,255);
  scoreBoardBackGround.fill(scoreBoardColor);
  
  scoreBoardBackGround.noStroke();
  scoreBoardBackGround.rect(0,0,screenWidth, screenHeight/6+aestheticCorrection);
  scoreBoardBackGround.endDraw();
   ortho();
  image(scoreBoardBackGround,0, screenHeight-screenHeight/6);
  perspective();

}