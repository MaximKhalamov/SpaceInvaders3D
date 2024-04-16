enum BossState{
  BOSS_ATTACK,
  BOSS_AVOID,
}

int BOSS_HEALTH = 250;
int BOSS_SHIELD = 0;

class BossController extends WaveController{
  private Thread timer;
  //private Thread positionCalculator;
  private int secondsNumber = 91;
  
  private int OFFSET_X = -60;
  private int OFFSET_Y = 60;
  private float maxX = -WIDTH, maxY = HEIGHT;
  
  private float maxBossSpeed = 15.0f;
  private float angle = 0f;
  
  private int DT_BOSS_ATTACK = 40;
  private int DT_BOSS_AVOID = 80;
  private float L_MIN = 1300f;

  private int timing = 20;

  private float bulletPrejX = 0.0f;
  private float bulletPrejY = 0.0f;

  private volatile float clasterX = 0.0f;
  private volatile float clasterY = 0.0f;

  private volatile int bulletNumber = 0;


  private float L_MAX = 13000f;
  private float ACCELERATION = 1f;


  private BossState bossState = BossState.BOSS_AVOID;

  private BossStarship bossStarship;
  private Starship mainStarship;
  private List<Bullet> bullets;

  public BossController(Starship mainStarship, List<Bullet> bullets){
    this.mainStarship = mainStarship;
    this.bullets = bullets;
    float bossPosX;
    float bossPosY;
    
    if( mainStarship.getPosX() < maxX - OFFSET_X ){
      bossPosX = maxX - OFFSET_X;
    } else if( mainStarship.getPosX() > OFFSET_X ){
      bossPosX = OFFSET_X;
    } else {
      bossPosX = mainStarship.getPosX();
    }
    
    if( mainStarship.getPosY() > maxY - OFFSET_Y ){
      bossPosY = maxY - OFFSET_Y;
    } else if( mainStarship.getPosY() < OFFSET_Y ){
      bossPosY = OFFSET_Y;
    } else {
      bossPosY = mainStarship.getPosY();
    }

    bossStarship = new BossStarship(BOSS_HEALTH, BOSS_SHIELD, bossPosX, bossPosY, L_MIN );
    bossStarship.setVelX(maxBossSpeed);
    
    timer = new Thread(new Runnable(){
      @Override    
      public void run(){
        try{
          while(secondsNumber > 0){
            if(main.getState() != State.ACTIONFIELD)
              continue;
            Thread.sleep(1000);
            secondsNumber--;          
          }
          //positionCalculator.interrupt();
        }catch(InterruptedException e){
          e.printStackTrace();
        }
      }
    });
    timer.start();
    
    
    //positionCalculator = new Thread(new Runnable(){
    //  //private volatile boolean isInt = false;
      
    //  @Override    
    //  public void run(){
        
    //    try{
    //      while(!Thread.currentThread().isInterrupted()){

    //        Thread.sleep(500);
    //      }
    //    }catch(InterruptedException e){
    //      e.printStackTrace();
    //    }      
    //  }
    //});
    //positionCalculator.start();
  }
  
  @Override
  public List<Starship> getStarships(){
    List<Starship> ls = new ArrayList<>();
    ls.add(bossStarship);
    return ls;
  }
  
  @Override
  public void moveFrame(){
      switch(bossState){
        case BOSS_ATTACK:
          if(timing % 2 == 0)
            attack();
          break;
        case BOSS_AVOID:
          //if(timing % 2 == 0)
          scanning();
          if(timing % 6 == 0)
              bullets.add(bossStarship.shot());
          break;
      }
    //println(secondsNumber);
    if(secondsNumber == 0){
      bossStarship.setVelZ(bossStarship.getVelZ() + ACCELERATION);
      if(bossStarship.getPosZ() > L_MAX){
        // FAIL
        this.mainStarship.setDamage(9999);
      }
    }
    moveBoss();
    timing--;
    //println(timing);
    if(timing == 0){
      switch(bossState){
        case BOSS_ATTACK:
          //if(timing % 2 == 0)
          attack();
          bossState = BossState.BOSS_AVOID;
          timing = DT_BOSS_AVOID;
          break;
        case BOSS_AVOID:
          scanning();
          bossState = BossState.BOSS_ATTACK;
          timing = DT_BOSS_ATTACK;
          break;
      }      
    }
  }
  
  private void attack(){
    bullets.add(bossStarship.shot());
    
    float lx = mainStarship.getPosX() - bossStarship.getPosX();
    float ly = mainStarship.getPosY() - bossStarship.getPosY();
    
    bossStarship.setVelX((lx / sqrt(lx * lx + ly * ly) * maxBossSpeed + 9 * bossStarship.getVelX() )/ 10);
    bossStarship.setVelY((ly / sqrt(lx * lx + ly * ly) * maxBossSpeed + 9 * bossStarship.getVelY() )/ 10);
  }
  
  private boolean isCollidable(Bullet bullet){
    if(bullet.getVelZ() < 0)
      return false;
    if(bullet.getPosZ() > bossStarship.getPosZ()){
      return false;
    }
    
    float t0 = ( bullet.getPosZ() - bossStarship.getPosZ() ) / bullet.getVelZ();
    bulletPrejX = bullet.getPosX() + t0 * bullet.getVelX();
    bulletPrejY = bullet.getPosY() + t0 * bullet.getVelY();
    //return !( (bulletPrejX < maxX - OFFSET_X) ||
    //    (bulletPrejX > 0)               ||
    //    (bulletPrejY < 0)               ||
    //    (bulletPrejY > maxY - OFFSET_Y)
    //return true;
    //);
    
    return true;
  }

  
  public int getSecondsNumber(){
    return secondsNumber;
  }

  
  private void scanning(){
    bulletNumber = 0;
    int limit = 35;
    boolean isFirstBullet = false;

    for(Bullet bullet : bullets){
      if(limit == 0)
        break;
       limit--;
      //if(bulletNumber > 0)
      //  break;
      if(isCollidable(bullet)){
        bulletNumber++;
        if(isFirstBullet){
          clasterX = bulletPrejX;
          clasterY = bulletPrejY;
          isFirstBullet = true;
        } else {
          clasterX += bulletPrejX;
          clasterY += bulletPrejY;
        }
      }
    }

    if(bulletNumber == 0) return;

    clasterX /= bulletNumber;
    clasterY /= bulletNumber;

    float lx = bossStarship.getPosX() - clasterX;
    float ly = bossStarship.getPosY() - clasterY;
    
    bossStarship.setVelX((lx / sqrt(lx * lx + ly * ly) * maxBossSpeed + 9 * bossStarship.getVelX() )/ 10);
    bossStarship.setVelY((ly / sqrt(lx * lx + ly * ly) * maxBossSpeed + 9 * bossStarship.getVelY() )/ 10);
    
    //bossStarship.setVelX(lx / sqrt(lx * lx + ly * ly) * maxBossSpeed);
    //bossStarship.setVelY(ly / sqrt(lx * lx + ly * ly) * maxBossSpeed);
  }
  
  private void moveBoss(){
    if( (bossStarship.getPosX() + bossStarship.getVelX()) < maxX + OFFSET_X / 2|| (bossStarship.getPosX() + bossStarship.getVelX()) > - OFFSET_X / 2)
      bossStarship.setVelX(-bossStarship.getVelX());
      
    if( (bossStarship.getPosY() + bossStarship.getVelY()) > maxY + OFFSET_Y / 2|| (bossStarship.getPosY() + bossStarship.getVelY()) < - OFFSET_Y / 2)
      bossStarship.setVelY(-bossStarship.getVelY());

    bossStarship.frameMove();
  }
}
