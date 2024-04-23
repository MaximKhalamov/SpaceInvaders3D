float PLAYER_MODEL_SCALE = 0.4f;
float PLAYER_COLLISION_R = 2 * AXIS_SCALE / 2;

float PLAYER_BULLET_SPEED_Z = 50.0f;
float PLAYER_BULLET_RADIUS = 5.0f;
int PLAYER_BULLET_LIFE_TIME = 300;
int PLAYER_DAMAGE = 10;

class MainStarship extends Starship{
  private int level = STARTLEVEL;
  //private float fireRatePlayer = MULTIPLIER_FIRE_RATE_PLAYER;

  public MainStarship(int health, int shield){
    super(health, shield);
    
    this.setModel(PLAYER_STARSHIP_MODEL, PLAYER_STARSHIP_MODEL, PLAYER_STARSHIP_MODEL, PLAYER_STARSHIP_MODEL);
    this.setCollisionR(PLAYER_COLLISION_R);
  }
  
  public MainStarship(int health, int shield, float x, float y){
    super(health, shield);
    
    setPosX(x);
    setPosY(y);
    
    this.setModel(PLAYER_STARSHIP_MODEL, PLAYER_STARSHIP_MODEL, PLAYER_STARSHIP_MODEL, PLAYER_STARSHIP_MODEL);
    this.setCollisionR(PLAYER_COLLISION_R);
  }
  
  @Override
  public Bullet shot(){
        return new Bullet(this.getPosX(), this.getPosY(), this.getPosZ() + 2.1 * AXIS_SCALE,
                      0, 0, PLAYER_BULLET_SPEED_Z,
                      PLAYER_BULLET_RADIUS, PLAYER_BULLET_LIFE_TIME, PLAYER_DAMAGE, PLAYER_BULLET_COLOR);
  }
  
  public void shot(List<Bullet> bullets){
    switch(level){
      case 1:      
      case 4:      
        bullets.add(
          new Bullet(this.getPosX(), this.getPosY(), this.getPosZ() + 2.1 * AXIS_SCALE,
                      0, 0, PLAYER_BULLET_SPEED_Z,
                      PLAYER_BULLET_RADIUS, PLAYER_BULLET_LIFE_TIME, PLAYER_DAMAGE, PLAYER_BULLET_COLOR));
        break;
      case 2:
      case 5:      
        bullets.add(
          new Bullet(this.getPosX() + 0.4 * AXIS_SCALE, this.getPosY(), this.getPosZ() + 2.1 * AXIS_SCALE,
                      0, 0, PLAYER_BULLET_SPEED_Z,
                      PLAYER_BULLET_RADIUS, PLAYER_BULLET_LIFE_TIME, PLAYER_DAMAGE, PLAYER_BULLET_COLOR));
        bullets.add(
          new Bullet(this.getPosX() - 0.4 * AXIS_SCALE, this.getPosY(), this.getPosZ() + 2.1 * AXIS_SCALE,
                      0, 0, PLAYER_BULLET_SPEED_Z,
                      PLAYER_BULLET_RADIUS, PLAYER_BULLET_LIFE_TIME, PLAYER_DAMAGE, PLAYER_BULLET_COLOR));
        break;
      case 3:
      case 6:      
      case 7:

        bullets.add(
          new Bullet(this.getPosX(), this.getPosY(), this.getPosZ() + 2.1 * AXIS_SCALE,
                      PLAYER_BULLET_SPEED_Z * sin(-PI/50), 0, PLAYER_BULLET_SPEED_Z * cos(-PI/50),
                      PLAYER_BULLET_RADIUS, PLAYER_BULLET_LIFE_TIME, PLAYER_DAMAGE, PLAYER_BULLET_COLOR));
        bullets.add(
          new Bullet(this.getPosX(), this.getPosY(), this.getPosZ() + 2.1 * AXIS_SCALE,
                      0, 0, PLAYER_BULLET_SPEED_Z,
                      PLAYER_BULLET_RADIUS, PLAYER_BULLET_LIFE_TIME, PLAYER_DAMAGE, PLAYER_BULLET_COLOR));
        bullets.add(
          new Bullet(this.getPosX(), this.getPosY(), this.getPosZ() + 2.1 * AXIS_SCALE,
                      PLAYER_BULLET_SPEED_Z * sin(PI/50), 0, PLAYER_BULLET_SPEED_Z * cos(PI/50),
                      PLAYER_BULLET_RADIUS, PLAYER_BULLET_LIFE_TIME, PLAYER_DAMAGE, PLAYER_BULLET_COLOR));
        
        break;

      default: 
        bullets.add(
          new Bullet(this.getPosX(), this.getPosY(), this.getPosZ() + 2.1 * AXIS_SCALE,
                      0, 0, PLAYER_BULLET_SPEED_Z,
                      PLAYER_BULLET_RADIUS, PLAYER_BULLET_LIFE_TIME, PLAYER_DAMAGE, PLAYER_BULLET_COLOR));
        break;

    }
  }
  
  public boolean display(float camX, float camY, float camZ, float camDirX, float camDirY, float camDirZ, float rotation){
    if( isObjectOnScreen(getPosX(), getPosY(), getPosZ(), camX, camY, camZ, camDirX, camDirY, camDirZ) ){
      return false;
    }
    float distance = getNorm(getPosX() - camX, getPosY() - camY, getPosZ() - camZ);
    pushMatrix();
    translate(getPosX(), getPosY(), getPosZ());
    rotateZ(PI);
    rotateY(PI/2);
    rotateX(rotation);
    if( distance < LOD1_DISTANCE ){
      shape(modelLOD0);    
    } else if ( distance >= LOD1_DISTANCE && distance < LOD2_DISTANCE ){
      shape(modelLOD1);
    } else if ( distance >= LOD2_DISTANCE && distance < LOD3_DISTANCE ){
      shape(modelLOD2);
    } else {
      fill(38, 26, 26);
      shape(modelLOD3);
    }
    popMatrix();
    return true;
  }
  // if level = 1 then ++
  // if level = 7 theb 7
  public void improveStarship(){
    level++;
    switch(level){
      case 4:
        fireRatePlayer *= 2; break;
      case 8: level = 7; break;
    }
  }
}
