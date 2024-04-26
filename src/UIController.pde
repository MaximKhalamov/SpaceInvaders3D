// screen x (x_min, x_max) -> (0, width)
// screen y (y_min, y_max) -> (0, heigth)

// relative x (x_min, x_max) -> (- 2 * width, 2 * width)
// relative y (y_min, y_max) -> (- 2 * heigth, 2 * heigth)

float Z_COORD = - 2 * height;

float controlDX = 0.0f;
float controlDY = 0.0f;
boolean controlIsFire = false;

float sensitivity;

class UIController{
  private List<UIElement> UIElements;
  
  public UIController(List<UIElement> UIElements){
    this.UIElements = UIElements;
    //UIElements = new ArrayList<>();
    //UIElements.add(new UIElementShot(width * 0.8, height * 0.6));
    //UIElements.add(new UIElementJoystick(width * 0.2, height * 0.6));
  }
  
  //private float

  public void check(){
  }
  
  public void draw(){
    for(UIElement elem : UIElements){
      elem.draw();
    }  
    
    for(UIElement elem : UIElements){
      if(ANDROID){
        if (touches.length > 0) {
          for (int i = 0; i < touches.length; i++) {
            TouchEvent.Pointer touch = touches[i];       
            if(elem.isSelected(touch.x, touch.y)){
              break;            
            }
          }
        } 
      }
      if(JAVA){
        if (mousePressed) {
          if(elem.isSelected(mouseX, mouseY)){
            break;            
          }
        } 
      }
      else {
      elem.isNotSelected();
      //isTouched false
      }
    }
  }
  
  public List<UIElement> getElements(){
    return UIElements;
  }
}

class UIControllerActionField extends UIController{
  private UIElement menuController;
  
  public UIControllerActionField(List<UIElement> UIElements, UIElement menuController){
    super(UIElements);
    this.menuController = menuController;
  }
  
  public boolean isMenuCalling(){
    return menuController.getIsSelected();
  }
}

class UIControllerMenu extends UIController{
  private List<Boolean> uiElementsState;
  
  public UIControllerMenu(List<UIElement> UIElements){
    super(UIElements);
    uiElementsState = new ArrayList<>();

    for(UIElement elem : UIElements){
      uiElementsState.add(false);    
    }
  }
  
  public boolean getState(int number){
    return getElements().get(number).getIsSelected();
  }
}

float MULTIPLIER_SCREEN = 4;

float screenToXRel(float xScreen){
  return MULTIPLIER_SCREEN * xScreen;
}

float screenToYRel(float yScreen){
  return MULTIPLIER_SCREEN * yScreen;  
}

abstract class UIElement{
  private float xScreen;
  private float yScreen;
  private boolean isSelected;
  
  public abstract void draw();
  public abstract boolean isSelected(float xScreen, float yScreen);
  public abstract void isNotSelected();
  
  public boolean getIsSelected(){
    return isSelected;
  }
  
  protected void setIsSelected(boolean isSelected){
    this.isSelected = isSelected;
  }
  
  public void setXScreen(float xScreen){
    this.xScreen = xScreen;
  }
  
  public void setYScreen(float yScreen){
    this.yScreen = yScreen;
  }
  
  public float getXScreen(){
    return xScreen;
  }
  
  public float getYScreen(){
    return yScreen;
  }
}

class UIElementShot extends UIElement{

  private float radius;
  public UIElementShot(float xScreen, float yScreen){
    setXScreen(xScreen);
    setYScreen(yScreen);
    radius = 1.0 / 8.0 * height;
  }
  
  @Override
  public void draw(){
    hint(DISABLE_DEPTH_TEST);
    pushMatrix();
    resetMatrix();
    translate(-2 * width, - 2 * height, - 2 * height);
    
    if(JAVA){
      color clr = dist(getXScreen(), getYScreen(), mouseX, mouseY) < radius ? color(245, 194, 225, 160) : color(255, 255, 255, 160);
    }
    if(ANDROID){
      color clr = getIsSelected() ? color(245, 194, 225, 160) : color(255, 255, 255, 160);
    }

    fill(clr);
    noStroke();
    ellipse(screenToXRel(getXScreen()), screenToYRel(getYScreen()), MULTIPLIER_SCREEN * radius, MULTIPLIER_SCREEN * radius);
    popMatrix();
    hint(ENABLE_DEPTH_TEST);
  }
  
  @Override  
  public boolean isSelected(float xScreen, float yScreen){ 
    setIsSelected(dist(getXScreen(), getYScreen(), xScreen, yScreen) < radius);
    controlIsFire = getIsSelected();

    return controlIsFire;
  }  
  
  @Override    
  public void isNotSelected(){
    setIsSelected(false);
    controlIsFire = false;
  }
}

class UIRadioButton extends UIElement{
  private boolean value;
  private boolean isChosen = true;
  private String name;
  private float elementLen;
  private float sw = height / 10.;
  public UIRadioButton(boolean value, String name, float xScreen, float yScreen){
    this.value = value;
    this.name = name;
    //this.size = size;
    setXScreen(xScreen);
    setYScreen(yScreen);
  }
  
  public void setVal(boolean val){
    value = val;
  }
  
  @Override
  public void draw(){
    
      if(!getIsSelected()){
        isChosen = true;    
      }
    
      hint(DISABLE_DEPTH_TEST);
      pushMatrix();
      resetMatrix();
      translate(-2 * width, - 2 * height, - 2 * height);
      
      if(JAVA){
        color clr = abs(mouseX + sw / 2 - getXScreen() - elementLen / 2) < elementLen / 2 && abs(mouseY - getYScreen()) < height / 20 ? color(245, 194, 225, 160) : color(255, 255, 255, 160);
      }
      if(ANDROID){
        color clr = getIsSelected() ? color(245, 194, 225, 160) : color(255, 255, 255, 160);
      }
  
      fill(clr);
      noStroke();
  
      String text = translation.get(name);
      rectMode(CORNER);
      //fill(0);
      
      String displayedText = new String("" + text);
      float textLen = textWidth(displayedText);
      
      float totalLen = textLen + sw * displayDensity;
      
      totalLen /= displayDensity;
      elementLen = totalLen;

      //rect(screenToXRel(getXScreen() - totalLen / 2), screenToYRel(getYScreen() - size / 2), screenToXRel(totalLen), screenToYRel(size));
      rect(screenToXRel(getXScreen() - sw / 2), 
                        screenToYRel(getYScreen() - sw / 2), 
                        MULTIPLIER_SCREEN * (sw), 
                        MULTIPLIER_SCREEN * (sw));
      
      
      float offset = sw / 10;
      
      fill(0);
      rect(screenToXRel(getXScreen() - sw / 2 + offset ), screenToYRel(getYScreen() - sw / 2 + offset), MULTIPLIER_SCREEN * (sw - 2 * offset), MULTIPLIER_SCREEN * (sw - 2 * offset));

      if(value){
        fill(clr);
        rect(screenToXRel(getXScreen() - sw / 2 + 2 * offset ), screenToYRel(getYScreen() - sw / 2 + 2 * offset), MULTIPLIER_SCREEN * (sw - 4 * offset), MULTIPLIER_SCREEN * (sw - 4 * offset));
      }
      
      textAlign(LEFT, CENTER);
      fill(clr);
      text(text, screenToXRel(getXScreen() + sw), screenToYRel(getYScreen()), 0);
      
      popMatrix();
      hint(ENABLE_DEPTH_TEST);
  }
  
  public boolean getVal(){
    return value;
  }
  
  @Override  
  public boolean isSelected(float xScreen, float yScreen){ 
    setIsSelected(abs(xScreen - getXScreen() + sw / 2 - elementLen / 2) < elementLen / 2 && abs(yScreen - getYScreen()) < height / 20);
    //setIsSelected(dist(getXScreen(), getYScreen(), xScreen, yScreen) < radius);
    //controlIsFire = getIsSelected();
    if(getIsSelected()){
      if(isChosen){
        value = !value;
        isChosen = false;
      }  
    }
    return getIsSelected();
  }
  
  @Override    
  public void isNotSelected(){
    setIsSelected(false);
  }
  
}

class UIElementSlider extends UIElement{
  private float minVal;
  private float maxVal;
  private float val;
  private String name;
  
  private float len;
  
  public UIElementSlider(float valInit, float minVal, float maxVal, float len, String name, float xScreen, float yScreen){
    this.minVal = minVal;
    this.maxVal = maxVal;
    val = valInit;
    this.name = name;
    this.len = len;
    setXScreen(xScreen);
    setYScreen(yScreen);
  }
  
  public void setVal(float val){
    this.val = val;
  }
  
  @Override
  public void draw(){
      hint(DISABLE_DEPTH_TEST);
      pushMatrix();
      resetMatrix();
      translate(-2 * width, - 2 * height, - 2 * height);
      
      if(JAVA){
        color clr = abs(mouseX - getXScreen()) < len / 2 && abs(mouseY - getYScreen()) < MULTIPLIER_SCREEN * height / 40 ? color(245, 194, 225, 160) : color(255, 255, 255, 160);
      }
      if(ANDROID){
        color clr = getIsSelected() ? color(245, 194, 225, 160) : color(255, 255, 255, 160);
      }
  
      fill(clr);
      noStroke();
  
      String text = translation.get(name);
  
      textAlign(CENTER, BOTTOM);
      text(text, screenToXRel(getXScreen()), screenToYRel(getYScreen() - height / 20), 0);
    
      rectMode(CORNER);
      //fill(0);

      textAlign(RIGHT, CENTER);
      text(String.format("%.1f", minVal) + " ", screenToXRel(getXScreen() - len / 2), screenToYRel(getYScreen()), 0);

      textAlign(LEFT, CENTER);
      text(" " + String.format("%.1f", maxVal), screenToXRel(getXScreen() + len / 2), screenToYRel(getYScreen()), 0);
      
      rect(screenToXRel(getXScreen() - len / 2), screenToYRel(getYScreen() - height / 400), screenToXRel(len), screenToYRel(height / 100));
      ellipse( screenToXRel(getXScreen() + map(val, minVal, maxVal, - len / 2, + len / 2)), screenToYRel(getYScreen()), MULTIPLIER_SCREEN * height / 20, MULTIPLIER_SCREEN * height / 20 );
      
      popMatrix();
      hint(ENABLE_DEPTH_TEST);
  }
  
  public float getVal(){
    return val;
  }
  
  @Override  
  public boolean isSelected(float xScreen, float yScreen){ 
    setIsSelected(abs(xScreen - getXScreen()) < len / 2 && abs(yScreen - getYScreen()) < MULTIPLIER_SCREEN * height / 40);
    //setIsSelected(dist(getXScreen(), getYScreen(), xScreen, yScreen) < radius);
    controlIsFire = getIsSelected();
    if(getIsSelected()){
      val = map(xScreen, getXScreen() - len / 2, getXScreen() + len / 2, minVal, maxVal);
    }
    return getIsSelected();
  }
  
  @Override    
  public void isNotSelected(){
    setIsSelected(false);
    //controlIsFire = false;
  }
}

if(ANDROID){
  class UIElementJoystick extends UIElement{

    private float intX;
    private float intY;
    
    private float intRadius;
    private float extRadius;
    public UIElementJoystick(float xScreen, float yScreen){
      setXScreen(xScreen);
      setYScreen(yScreen);
      intX = getXScreen();
      intY = getYScreen();
      intRadius = 1.0 / 8.0 * height;
      extRadius = 4 * intRadius;
    }
    
    @Override
    public void draw(){
      hint(DISABLE_DEPTH_TEST);
      pushMatrix();
      resetMatrix();
      translate(-2 * width, - 2 * height, - 2 * height);
      
      
      noStroke();
      fill(0, 0, 0, 70);
      ellipse(screenToXRel(getXScreen()), screenToYRel(getYScreen()), MULTIPLIER_SCREEN * extRadius, MULTIPLIER_SCREEN * extRadius);
      color clr = getIsSelected() ? color(245, 194, 225, 160) : color(255, 255, 255, 160);
      fill(clr);
      noStroke();
      ellipse(screenToXRel(intX), screenToYRel(intY), MULTIPLIER_SCREEN * intRadius, MULTIPLIER_SCREEN * intRadius);
      popMatrix();
      hint(ENABLE_DEPTH_TEST);
    }
    
    @Override  
    public boolean isSelected(float xScreen, float yScreen){ 
      boolean selected = false;
      if(!getIsSelected()){
        selected = dist(getXScreen(), getYScreen(), xScreen, yScreen) < extRadius / 2;
      }else{
        selected = xScreen < width / 2;      
      }
      setIsSelected(selected);
      if(selected){
        intX = xScreen;      
        intY = yScreen;
        
        float dx = getXScreen() - intX;
        float dy = getYScreen() - intY;
        
        float normDX = dx;
        float normDY = dy;
        
        if(dist(getXScreen(), getYScreen(), xScreen, yScreen) > extRadius / 2){
          normDX = dx / sqrt(dx * dx + dy * dy) * extRadius / 2;
          normDY = dy / sqrt(dx * dx + dy * dy) * extRadius / 2;
          
          intX = map(normDX, -extRadius / 2, extRadius / 2, getXScreen() + extRadius / 2, getXScreen() - extRadius / 2);
          intY = map(normDY, -extRadius / 2, extRadius / 2, getYScreen() + extRadius / 2, getYScreen() - extRadius / 2);
        }
        
        controlDX = (normDX) / (extRadius / 2);
        controlDY = (normDY) / (extRadius / 2);
      } else{
        intX = getXScreen();
        intY = getYScreen();

        controlDX = 0;
        controlDY = 0;
      }
      return selected;
    }  
    
    @Override    
    public void isNotSelected(){
      setIsSelected(false);
      intX = getXScreen();      
      intY = getYScreen();
      
      controlDX = 0;
      controlDY = 0;
    }
  }
}