class MenuController{
  private UIControllerMenu uiController;
  
  public MenuController(List<UIElement> elements){
    uiController = new UIControllerMenu(elements);
  }
  
  public void draw(){
    uiController.draw();
    uiController.check();
    
    hint(DISABLE_DEPTH_TEST);
    pushMatrix();
    resetMatrix();
    translate(-2 * width, - 2 * height, - 2 * height);
    
    popMatrix();
    hint(ENABLE_DEPTH_TEST);    
  }
  
  public boolean getState(int i){
    return uiController.getState(i);
  }
}


//xScreen and yScreen are for the center of rect
// lx, ly -- sizes of rect
class UIButton extends UIElement{
  private float lx, ly;
  protected String text;
  private String buttonName;
  private boolean isBlocked;
  
  public UIButton(float xScreen, float yScreen, float lx, float ly, String buttonName){
    setXScreen(xScreen);
    setYScreen(yScreen);
    this.lx = lx;
    this.ly = ly;
    this.buttonName = buttonName;
    isBlocked = false;
  }
  
  @Override
  public void draw(){
    hint(DISABLE_DEPTH_TEST);
    pushMatrix();
    resetMatrix();
    translate(-2 * width, - 2 * height, - 2 * height);
    
    color colorSelected = color(245, 194, 225, 160);
    color colorBlocked = color(127, 127, 127, 160);
    color colorDefault = color(255, 255, 255, 160);

    if(ANDROID){
    color clr = isBlocked ? colorBlocked : (getIsSelected() ? colorSelected : colorDefault );
    }
    if(JAVA){
    color clr = isBlocked ? colorBlocked : (abs(mouseX - getXScreen()) < lx / 2 && abs(mouseY - getYScreen()) < ly / 2 ? colorSelected : colorDefault );
    }
    fill(clr);
    noStroke();
    //rect(screenToXRel(getXScreen() - lx / 2), screenToYRel(getYScreen() - ly / 2), MULTIPLIER_SCREEN * lx, MULTIPLIER_SCREEN * ly);
    
    setText();
    
    rectMode(CORNER);
    if(JAVA){
      textSize(4./5 * 110 * displayDensity);
    }
    if(ANDROID){
      textSize(4./5 * 80 * displayDensity);
    }
    if(text.equals("MENU")){
      textureMode(NORMAL);
      noStroke();
      beginShape();
      texture(CROSS_ICON);
      vertex(screenToXRel(getXScreen() - lx / 2), screenToYRel(getYScreen() - ly / 2), 0, 0, 0);
      vertex(screenToXRel(getXScreen() + lx / 2), screenToYRel(getYScreen() - ly / 2), 0, 1, 0);
      vertex(screenToXRel(getXScreen() + lx / 2), screenToYRel(getYScreen() + ly / 2), 0, 1, 1);
      vertex(screenToXRel(getXScreen() - lx / 2), screenToYRel(getYScreen() + ly / 2), 0, 0, 1);
      //vertex(x + sx, y - sy / 2, z, 1, 0);
      //vertex(x + sx, y + sy / 2, z, 1, 1);
      //vertex(x, y + sy / 2, z, 0, 1);
      endShape();
    }
    else{
      rect(screenToXRel(getXScreen() - lx / 2), screenToYRel(getYScreen() - ly / 2), MULTIPLIER_SCREEN * lx, MULTIPLIER_SCREEN * ly);
      textAlign(CENTER, CENTER);
      fill(0);
      text(text, screenToXRel(getXScreen()),screenToYRel(getYScreen()), 0);
    }
    popMatrix();
    hint(ENABLE_DEPTH_TEST);
  }
  
  @Override  
  public boolean isSelected(float xScreen, float yScreen){ 
    setIsSelected(abs(xScreen - getXScreen()) < lx / 2 && abs(yScreen - getYScreen()) < ly / 2);

    return getIsSelected();
  }  
  
  @Override    
  public void isNotSelected(){
    setIsSelected(false);
  }
  
  protected void setText(){
    text = translation.get(buttonName);
  }
  
  public String getButtonName(){
    return buttonName;
  }
  
  public float getLX(){
    return lx;
  }
  
  public float getLY(){
    return ly;
  }

  public void block(){
    isBlocked = true;
  }

  public void unblock(){
    isBlocked = false;
  }
}

class UIStateButton extends UIButton{
  private boolean isChosen = true;
  private List<String> states;
  private int currentState;
  public UIStateButton(float xScreen, float yScreen, float lx, float ly, String buttonName, List<String> states){
    super(xScreen, yScreen, lx, ly, buttonName);
    this.states = states;
  }
  
  public String getVal(){
    return states.get(currentState);
  }
  
  public void setVal(String val){
    currentState = states.indexOf(val);
  }
  
  @Override
  void draw(){
    super.draw();
    if(!getIsSelected())
      isChosen = true;    
  }
  
  @Override
  protected void setText(){
   text = translation.get(getButtonName()) + ": " + states.get(currentState);
  }
  
  @Override  
  public boolean isSelected(float xScreen, float yScreen){ 
    setIsSelected(abs(xScreen - getXScreen()) < getLX() / 2 && abs(yScreen - getYScreen()) < getLY() / 2);
    if(getIsSelected()){
      if(isChosen){
        currentState = (currentState + 1) % states.size();
        isChosen = false;
      }  
    }
    return getIsSelected();
  }  
}
