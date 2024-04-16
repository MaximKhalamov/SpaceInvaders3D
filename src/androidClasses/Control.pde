class Control{
  float globalPositionX = WIDTH / 2f;
  float globalPositionY = HEIGHT / 2f;
  
  public Control(){}
  
  public float getX(){
    globalPositionX -= 40 * atan(controlDX) * sensitivity;
    
    if(globalPositionX < 0)
      globalPositionX = 0;
    if(globalPositionX > WIDTH)
      globalPositionX = WIDTH;
    return globalPositionX;  
  }
  
  public float getY(){
    globalPositionY -= 40 * atan(controlDY) * sensitivity;
    
    if(globalPositionY < 0)
      globalPositionY = 0;
    if(globalPositionY > HEIGHT)
      globalPositionY = HEIGHT;
    
    return globalPositionY;
  }
  
  public boolean isPressed(){
    return controlIsFire;
  }
}
