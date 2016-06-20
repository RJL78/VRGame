PGraphics scoreBoardBackGround;
PGraphics topView;
PGraphics infoBox;
PGraphics historyBox;
PGraphics zoomBox;

ArrayList<Float> scoreHistory;
float maxScore = 0;
float minScore = 0;
float totalScore = 0;
float lastScore = 0;

int framesPerScoreBar = 20;
int frameCounter = 0;
int scoreBarWidth = 7;
int minScoreBarWidth = 1;

int hudHeight = screenHeight/6;
int hudBorder = 10;
int aestheticCorrection = 50;
int hudBackGroundColor = new Color(210, 210, 210).getRGB();

int infoBoxWidth = screenWidth/8;
int infoBoxHeight = hudHeight - 2*hudBorder;
int infoBoxBorder = infoBoxWidth/10;


//Top View is Square ( if board isn't square, everything should scale linearly) 
int topViewSize = hudHeight - 2*hudBorder;

int historyBoxHeight = hudHeight - 2*hudBorder;
int histogramHeight = 2*historyBoxHeight/3;
int histogramColor = new Color(255,255,0).getRGB();

int zoomBoxHeight = histogramHeight;
int zoomBoxWidth = screenWidth/8;
int zoomBoxBorder = zoomBoxHeight/10;
int zoomButtonHeight = (zoomBoxHeight-3*zoomBoxBorder)/2;
int zoomButtonWidth = zoomBoxWidth-2*zoomBoxBorder;


int historyBoxWidth = screenWidth - topViewSize - infoBoxWidth - zoomBoxWidth - 5*hudBorder;


HScrollbar scroll;
int scrollHeight = historyBoxHeight/8;


void updateMaxMinScore() {
  if (totalScore>maxScore) {
    maxScore=totalScore;
  }
  if (totalScore<minScore) {
    minScore=totalScore;
  }
}

void setupScoreBoard() {

  scoreHistory = new ArrayList();
  topView = createGraphics(topViewSize, topViewSize, P2D);
  scoreBoardBackGround = createGraphics(screenWidth, hudHeight+aestheticCorrection, P2D);
  infoBox = createGraphics(hudHeight, topViewSize, P2D);
  historyBox = createGraphics(historyBoxWidth, historyBoxHeight, P2D);
  scroll = new HScrollbar(0, 
    historyBoxHeight-scrollHeight, 
    historyBoxWidth, 
    scrollHeight, 
    historyBox, 
    hudBorder*3+topViewSize+infoBoxWidth, 
    screenHeight-hudHeight+hudBorder);
  zoomBox = createGraphics(zoomBoxWidth,zoomBoxHeight,P2D);
}

void drawScoreBoard() {

  if (frameCounter == framesPerScoreBar) {
    scoreHistory.add(totalScore);
    frameCounter = 0;
  }
  else if (run){
    frameCounter++;
  }

  scoreBoardBackGround.beginDraw();
  scoreBoardBackGround.fill(hudBackGroundColor);
  scoreBoardBackGround.noStroke();
  scoreBoardBackGround.rect(0, 0, screenWidth, screenHeight/6+aestheticCorrection);
  scoreBoardBackGround.endDraw();


  topView.beginDraw();
  topView.noStroke();
  topView.fill(boxColor);
  topView.rect(0, 0, topViewSize, topViewSize);
  topView.fill(ballShiftColor);
  topView.ellipse(topViewSize/2+spherePositionFromCenter.x/boxDepth*topViewSize, 
    topViewSize/2+spherePositionFromCenter.y/boxWidth*topViewSize, 
    2*sphereSize/boxDepth*topViewSize, 
    2*sphereSize/boxWidth*topViewSize );

  topView.fill(cylinderColor);
  for (int i =0; i <cylinders.size(); i++) {
    topView.ellipse( topViewSize/2+cylinderPositions.get(i).x/boxDepth*topViewSize, 
      topViewSize/2+cylinderPositions.get(i).y/boxWidth*topViewSize, 
      2*cylinderBaseSize/boxDepth*topViewSize, 
      2*cylinderBaseSize/boxWidth*topViewSize);
  }
  topView.endDraw();


  infoBox.beginDraw();
  infoBox.background(hudBackGroundColor);
  infoBox.fill(0);
  //Regarding the structure of infobox layout : we have one border, then one textbox, then one border, etc ...
  infoBox.text("Total Score:\n  "+totalScore, 
    infoBoxBorder, 
    infoBoxBorder, 
    infoBoxWidth-2*infoBoxBorder, 
    (infoBoxHeight-4*hudBorder)/3); 
  infoBox.text("Velocity:\n  "+sphereVelocity.mag(), 
    infoBoxBorder, 
    2*infoBoxBorder +(infoBoxHeight-4*hudBorder)/3, 
    infoBoxWidth-2*infoBoxBorder, 
    (infoBoxHeight-4*hudBorder)/3);  
  infoBox.text("Last Score:\n  "+lastScore, 
    infoBoxBorder, 
    3*infoBoxBorder +2*(infoBoxHeight-4*hudBorder)/3, 
    infoBoxWidth-2*infoBoxBorder, 
    (infoBoxHeight-4*hudBorder)/3); 
  infoBox.noFill();
  infoBox.stroke(0);
  infoBox.rect(0, 0, infoBoxWidth-1, infoBoxHeight-1);
  infoBox.endDraw();
  

  historyBox.beginDraw();
  historyBox.background(hudBackGroundColor);
  scroll.update();
  scroll.display();

  int zeroLevel= (int)((maxScore)/(maxScore-minScore)*histogramHeight);
  if (minScore<maxScore) {
    historyBox.stroke(0,0,0);
    historyBox.line(0,zeroLevel,historyBoxWidth,zeroLevel);
    historyBox.noStroke();
    historyBox.fill(histogramColor);
    int firstEntry = scroll.getIndexOfHistEntry(); 
    for (int i=firstEntry; i<scoreHistory.size() && i-firstEntry <= historyBoxWidth/scoreBarWidth; i++) {
      int barHeight = (int) (scoreHistory.get(i)/(maxScore-minScore)*histogramHeight);
      if (barHeight>0) {
        historyBox.rect((i-firstEntry)*scoreBarWidth, zeroLevel-barHeight, scoreBarWidth, barHeight);
      } else {
        historyBox.rect((i-firstEntry)*scoreBarWidth, zeroLevel, scoreBarWidth, -barHeight);
      }
    }
  }
  historyBox.endDraw();
  
  zoomBox.beginDraw();
  //zoomBox.background(hudBackGroundColor);

  zoomBox.stroke(0);
  zoomBox.noFill();
  zoomBox.rect(zoomBoxBorder, zoomBoxBorder, zoomButtonWidth, zoomButtonHeight);
  zoomBox.rect(zoomBoxBorder,2*zoomBoxBorder+zoomButtonHeight, zoomButtonWidth,zoomButtonHeight);
  zoomBox.fill(0);
  zoomBox.textAlign(CENTER);
  zoomBox.textSize( zoomButtonHeight -10 );
  zoomBox.text("+", zoomBoxBorder, zoomBoxBorder, zoomButtonWidth, zoomButtonHeight);
  zoomBox.text("-", zoomBoxBorder,2*zoomBoxBorder+zoomButtonHeight, zoomButtonWidth,zoomButtonHeight);
  zoomBox.endDraw();





  ortho();
  image(scoreBoardBackGround, 0, screenHeight-hudHeight);
  image(topView, hudBorder, screenHeight-hudHeight+hudBorder);
  image(infoBox, hudBorder*2+topViewSize, screenHeight-hudHeight+hudBorder);
  image(historyBox, hudBorder*3+topViewSize+infoBoxWidth, screenHeight-hudHeight+hudBorder);
  image(zoomBox, hudBorder*4+topViewSize+infoBoxWidth+historyBoxWidth, screenHeight-hudHeight+hudBorder);
  perspective();
}

boolean mouseOverScoreBoard(){
   return (mouseY > screenHeight - hudHeight);
}

boolean mouseOverPlusZoom(){
   return (   mouseY > screenHeight - hudHeight + hudBorder + zoomBoxBorder 
           && mouseY < screenHeight - hudHeight + hudBorder + zoomBoxBorder + zoomButtonHeight
           && mouseX > zoomBoxBorder + hudBorder*4 + topViewSize + infoBoxWidth + historyBoxWidth 
           && mouseX < zoomBoxBorder + hudBorder*4 + topViewSize + infoBoxWidth + historyBoxWidth + zoomButtonWidth);
}

boolean mouseOverMinusZoom(){
   return (   mouseY > screenHeight - hudHeight + hudBorder + 2*zoomBoxBorder +zoomButtonHeight
           && mouseY < screenHeight - hudHeight + hudBorder + 2*zoomBoxBorder + 2*zoomButtonHeight
           && mouseX > zoomBoxBorder + hudBorder*4 + topViewSize + infoBoxWidth + historyBoxWidth 
           && mouseX < zoomBoxBorder + hudBorder*4 + topViewSize + infoBoxWidth + historyBoxWidth + zoomButtonWidth);
}