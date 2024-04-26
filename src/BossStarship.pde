float BOSS_MODEL_SCALE = 0.8f;
float BOSS_COLLISION_R = 4 * AXIS_SCALE / 2;

float BOSS_BULLET_SPEED_X = 0;
float BOSS_BULLET_SPEED_Y = 0;
float BOSS_BULLET_SPEED_Z = - 50.0f;
float BOSS_BULLET_RADIUS = 5.0f;
int BOSS_BULLET_LIFE_TIME = 150;
int BOSS_DAMAGE = 10;

class BossStarship extends Starship{
    private int damageTiming = 0;
  
  public BossStarship(int health, int shield){
    super(health, shield);


    this.setModel(BOSS_STARSHIP_MODEL, BOSS_STARSHIP_MODEL, BOSS_STARSHIP_MODEL, BOSS_STARSHIP_MODEL);
    this.setCollisionR(BOSS_COLLISION_R);
  }

  public BossStarship(int health, int shield, float posX, float posY, float posZ){
    super(health, shield);
    
    this.setModel(BOSS_STARSHIP_MODEL, BOSS_STARSHIP_MODEL, BOSS_STARSHIP_MODEL, BOSS_STARSHIP_MODEL);
    this.setCollisionR(BOSS_COLLISION_R);
  
    this.setPosX(posX);
    this.setPosY(posY);
    this.setPosZ(posZ);
  }
  
  @Override
  public boolean setDamage(int damage){
    //if(getInvincibilityStatus()){
    //  return false;
    //}
    damageTiming = 5;
    if(getShield() < damage && getShield() > 0){
      setShield(0);
    } else if(getShield() == 0){
      if(getHealth() <= damage){
        return true;
      } else{
        setHealth(getHealth() - damage);
      }
    } else{
      setShield(getShield() - damage);
    }
    return false;
  }
  
  @Override
  public Bullet shot(){
    return new Bullet(this.getPosX(), this.getPosY(), this.getPosZ() - BOSS_COLLISION_R - 10,
                      BOSS_BULLET_SPEED_X, BOSS_BULLET_SPEED_Y, BOSS_BULLET_SPEED_Z,
                      BOSS_BULLET_RADIUS, BOSS_BULLET_LIFE_TIME, BOSS_DAMAGE, ENEMY_BULLET_COLOR);
}
  
  @Override
  public boolean display(float camX, float camY, float camZ, float camDirX, float camDirY, float camDirZ){
    if(isObjectOnScreen(getPosX(), getPosY(), getPosZ(), camX, camY, camZ, camDirX, camDirY, camDirZ))
      return false;
    fill(38, 26, 26);

    pushMatrix();
    translate(getPosX(), getPosY(), getPosZ());
    rotateZ(PI/2);
    rotateY(PI/2);
    rotateX(PI);
    rotateX(-0.015 * getVelX());
    if( damageTiming == 0 && getShield() > 0 ){
      popMatrix();
    }else if(damageTiming > 0 && getShield() > 0){
      damageTiming--;
      popMatrix();
      super.display(camX, camY, camZ, camDirX, camDirY, camDirZ, -PI /2 - 0.015 * getVelX());
    }else if(damageTiming > 0 && getShield() == 0){
      shape(BOSS_STARSHIP_MODEL_DAMAGE);  
      popMatrix();
      damageTiming--;
    } else{
      popMatrix();
      super.display(camX, camY, camZ, camDirX, camDirY, camDirZ, -PI / 2 - 0.015 * getVelX());    
    }
    return true;
  }
}
