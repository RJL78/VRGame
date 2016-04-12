PGraphics scoreBoardBackGround;
PGraphics topView;

int scoreBorderSize = 10;
int aestheticCorrection = 50;
int scoreBoardColor = new Color(255, 255, 255).getRGB();
int topViewSize = screenHeight/6 - 2*scoreBorderSize;

void setupScoreBoard() {
  topView = createGraphics(topViewSize,topViewSize, P2D);
  scoreBoardBackGround = createGraphics(screenWidth, screenHeight/6+aestheticCorrection , P2D);
 
}

void drawScoreBoard(){
  
  scoreBoardBackGround.beginDraw();
  scoreBoardBackGround.background(scoreBoardBackGround);
  scoreBoardBackGround.fill(scoreBoardColor);
  scoreBoardBackGround.noStroke();
  scoreBoardBackGround.rect(0,0,screenWidth, screenHeight/6+aestheticCorrection);
  scoreBoardBackGround.endDraw();
  
  topView.beginDraw();
  topView.fill(boxColor);
  topView.rect(0,0,topViewSize,topViewSize);
  topView.endDraw();
  
  
 // ortho();
  image(scoreBoardBackGround,0, screenHeight-screenHeight/6);
   //image(topView,scoreBorderSize, screenHeight-screenHeight/6+scoreBorderSize);
  perspective();

}