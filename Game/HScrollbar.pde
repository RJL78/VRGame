class HScrollbar {
  
  float xPosition; //Bar’s x position in pixels float yPosition; //Bar’s y position in pixels
  float yPosition; //Bar’s y position in pixels
  float barHeight; //Bar’s height in pixels float xPosition; //Bar’s x position in pixels float yPosition; //Bar’s y position in pixels
  float barWidth; //Bar’s width in pixelsfloat barHeight; //Bar’s height in pixels float xPosition; //Bar’s x position in pixels float yPosition; //Bar’s y position in pixels
  float sliderPosition, newSliderPosition; //Position of slider
  float sliderPositionMin, sliderPositionMax; //Max and min values of slider
  boolean mouseOver; //Is the mouse over the slider?
  boolean locked; //Is the mouse clicking and dragging the slider now?
  PGraphics layer; //The layer on which HScrollBar should be drawn
  int layerX; //The X coordinate of the upper left hand corner of the layer with respect to the screen;
  int layerY; //The Y coordinate of the upper left hand corner of the layer with respect to the screen;
  float buttonWidth;
  /**
   * @brief Creates a new horizontal scrollbar
   *
   * @param x The x position of the top left corner of the bar in pixels with respect to layer;
   * @param y The y position of the top left corner of the bar in pixels with respect to layer;
   * @param w The width of the bar in pixels
   * @param h The height of the bar in pixels
   * @param l The layer to draw on 
   * @param lX The X coordinate of the upper left hand corner of the layer with respect to the screen;
   * @param lY The Y coordinate of the upper left hand corner of the layer with respect to the screen;
   */
  HScrollbar (float x, float y, float w, float h, PGraphics l, int lX, int lY) {
    layer = l;
    layerX = lX;
    layerY = lY;
    barWidth = w;
    barHeight = h;
    xPosition = x;
    yPosition = y;
    buttonWidth = barWidth;
    sliderPosition = xPosition;
    newSliderPosition = sliderPosition;
    sliderPositionMin = xPosition;
    sliderPositionMax = xPosition + barWidth - buttonWidth;
  }
  
  /**
   * @brief Updates the state of the scrollbar according to the mouse movement
   */
  void update() {
    
    float oldButtonWidth = buttonWidth;
    buttonWidth = historyBoxWidth*Math.min( (historyBoxWidth*1.0/scoreBarWidth)/ Math.max(scoreHistory.size(),1),1);
    sliderPositionMax = xPosition + barWidth - buttonWidth;
    
    sliderPosition = sliderPosition + oldButtonWidth-buttonWidth;
    newSliderPosition = sliderPosition;

    if (isMouseOver()) {
      mouseOver = true;
    } else {
      mouseOver = false;
    }
    if (mousePressed && mouseOver) {
      locked = true;
    }
    if (!mousePressed) {
      locked = false;
    }
    if (locked) {
      newSliderPosition = constrain(mouseX-buttonWidth/2-layerX, sliderPositionMin, sliderPositionMax);
    }
    if (abs(newSliderPosition - sliderPosition) > 1) {
      sliderPosition = sliderPosition + (newSliderPosition - sliderPosition);
    }
  }
  
  /**
   * @brief Clamps the value into the interval
   *
   * @param val The value to be clamped   * @param minVal Smallest value possible
   * @param maxVal Largest value possible
   *
   * @return val clamped into the interval [minVal, maxVal]
   */
  float constrain(float val, float minVal, float maxVal) {
    return min(max(val, minVal), maxVal);
  }
  
  /**
   * @brief Gets whether the mouse is hovering the scrollbar
   *
   * @return Whether the mouse is hovering the scrollbar
   */
  boolean isMouseOver() {
    
    if (mouseX > xPosition+layerX && mouseX < xPosition+layerX+barWidth &&
      mouseY > yPosition+layerY && mouseY < yPosition+layerY+barHeight ) {
      return true;
  
    } else {
      return false;
    }
  }
  
  /**
   * @brief Draws the scrollbar in its current state
   */  
  void display() {
    layer.noStroke();
    layer.fill(204);
    layer.rect(xPosition, yPosition, barWidth, barHeight);
    if (mouseOver || locked) {
      layer.fill(0, 0, 0);
    } else {
      layer.fill(102, 102, 102);
    }
    layer.rect(sliderPosition, yPosition, buttonWidth, barHeight);
  }
  
  /**
   * @brief Gets the position of left end of slider
   */
  int getIndexOfHistEntry() {
    return (int) ((sliderPosition - xPosition)/(barWidth)*scoreHistory.size());
  }
}