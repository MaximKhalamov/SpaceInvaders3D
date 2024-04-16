class Control{
  float globalPositionX = WIDTH / 2;
  float globalPositionY = HEIGHT / 2;
  
  float prevMovementX = 0;
  float prevMovementY = 0;
  
  public Control(){}
  
  public float getX(float mosueMovementX){
    globalPositionX += SENSITIVITY_X * (mosueMovementX + 3*prevMovementX) / 4 * sensitivity;
    prevMovementX = (mosueMovementX + 3*prevMovementX) / 4;
    if(globalPositionX < 0)
      globalPositionX = 0;
    if(globalPositionX > WIDTH)
      globalPositionX = WIDTH;
    return globalPositionX;  
  }
  
  public float getY(float mosueMovementY){
    globalPositionY += SENSITIVITY_Y * (mosueMovementY + 3*prevMovementY) / 4 * sensitivity;
    prevMovementY = (mosueMovementY + 3*prevMovementY) / 4;
    if(globalPositionY < 0)
      globalPositionY = 0.0f;
    if(globalPositionY > HEIGHT)
      globalPositionY = HEIGHT;
    return globalPositionY;    
  }
}
