float ENEMY_MODEL_SCALE = 2.5f;
float ENEMY_COLLISION_R = ENEMY_MODEL_SCALE * 4 * AXIS_SCALE / 2;

float ENEMY_BULLET_SPEED_X = 0;
float ENEMY_BULLET_SPEED_Y = 0;
float ENEMY_BULLET_SPEED_Z = - 50.0f;
float ENEMY_BULLET_RADIUS = 5.0f;
int ENEMY_BULLET_LIFE_TIME = 50;
int ENEMY_DAMAGE = 10;

class EnemyStarship extends Starship{  
  private int damageTiming = 0;
  
  public EnemyStarship(int health, int shield){
    super(health, shield);


    this.setModel(ENEMY_STARSHIP_LOD0_MODEL, ENEMY_STARSHIP_LOD1_MODEL, ENEMY_STARSHIP_LOD2_MODEL, ENEMY_STARSHIP_LOD3_MODEL);
    this.setCollisionR(ENEMY_COLLISION_R);
  }

  public EnemyStarship(int health, int shield, float posX, float posY, float posZ){
    super(health, shield);
    
    this.setModel(ENEMY_STARSHIP_LOD0_MODEL, ENEMY_STARSHIP_LOD1_MODEL, ENEMY_STARSHIP_LOD2_MODEL, ENEMY_STARSHIP_LOD3_MODEL);
    this.setCollisionR(ENEMY_COLLISION_R);
  
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
    return getShotStatus() ? new Bullet(this.getPosX(), this.getPosY(), this.getPosZ() - ENEMY_COLLISION_R - 10,
                      ENEMY_BULLET_SPEED_X, ENEMY_BULLET_SPEED_Y, ENEMY_BULLET_SPEED_Z,
                      ENEMY_BULLET_RADIUS, ENEMY_BULLET_LIFE_TIME, ENEMY_DAMAGE, ENEMY_BULLET_COLOR) : null;
}
  
  @Override
  public boolean display(float camX, float camY, float camZ, float camDirX, float camDirY, float camDirZ){
    if(isObjectOnScreen(getPosX(), getPosY(), getPosZ(), camX, camY, camZ, camDirX, camDirY, camDirZ))
      return false;
    //if(! ) return false;
    fill(38, 26, 26);

    pushMatrix();
    translate(getPosX(), getPosY(), getPosZ());
    rotateZ(PI);
    rotateY(PI/2);
    rotateX(getRotation());
    if( damageTiming == 0 && getShield() > 0 ){
      shape(SHIELD_DAMAGE_MODEL);
      popMatrix();
    }else if(damageTiming > 0 && getShield() > 0){
      damageTiming--;
      popMatrix();
      super.display(camX, camY, camZ, camDirX, camDirY, camDirZ, getRotation());
    }else if(damageTiming > 0 && getShield() == 0){
      shape(HEALTH_DAMAGE_MODEL);
      popMatrix();
      damageTiming--;
    } else{
      popMatrix();
      super.display(camX, camY, camZ, camDirX, camDirY, camDirZ, getRotation());
    }
    return true;
  }
}
