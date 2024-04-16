int LIGHT_BOSS_HEALTH = 180;
//int LIGHT_BOSS_HEALTH = 10;
int LIGHT_BOSS_SHIELD = 0;

class LightBossController extends WaveController{
  private int OFFSET_X = -60;
  private int OFFSET_Y = 60;
  private float maxX = -WIDTH, maxY = HEIGHT;
  
  private float maxBossSpeed = 16.0f;
  private float angle = 0f;
  
  private float L_MIN = 1300f;

  private int timing = 0;
  private int prioritySS = 0;

  private List<Starship> bossStarships;
  private Starship mainStarship;
  private List<Bullet> bullets;

  public LightBossController(Starship mainStarship, List<Bullet> bullets, int numberOfBosses){
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

    bossStarships = new ArrayList<>();
    for(int i = 0; i < numberOfBosses; i++){
      bossStarships.add(new BossStarship(LIGHT_BOSS_HEALTH, LIGHT_BOSS_SHIELD,
                                        -WIDTH / 2 + WIDTH / 8 * sin(2 * PI * i / numberOfBosses),
                                        HEIGHT / 2 + HEIGHT / 8 * cos(2 * PI * i / numberOfBosses),
                                        L_MIN ));
    }
  }

  @Override
  public List<Starship> getStarships(){
    return bossStarships;
  }
  
  @Override
  public void moveFrame(){
    timing++;
    for(int i = 0; i < bossStarships.size(); i++){
      moveBoss(bossStarships.get(i), prioritySS == i);
      if(timing % 8 == i % 8)
        attack(bossStarships.get(i));
    }
    if(timing % 100 == 0)
      if(bossStarships.size() != 0)
        prioritySS = (prioritySS + 1) % bossStarships.size();
  }
  
  private void attack(Starship boss){
      bullets.add(boss.shot());
  }
  
  private float weight(float distance){
      return - 100000. / (pow(distance, 2)+0.0001);
      //return - 10;
  }
  
  private void moveBoss(Starship ss, boolean isPriority){
    float x = 0;
    float y = 0;

    if(!isPriority)
      for(Starship another : bossStarships){
        if(!another.equals(ss)){
          x += ( another.getPosX() - ss.getPosX() ) * weight(another.getPosX() - ss.getPosX());
          y += ( another.getPosY() - ss.getPosY() ) * weight(another.getPosY() - ss.getPosY());
        }
      }
    
    x += mainStarship.getPosX() - ss.getPosX();
    y += mainStarship.getPosY() - ss.getPosY();
    
    float xNorm = x / sqrt(x*x + y*y);
    float yNorm = y / sqrt(x*x + y*y);
    
    ss.setVelX((xNorm * maxBossSpeed + 9 * ss.getVelX() )/ 10);
    ss.setVelY((yNorm * maxBossSpeed + 9 * ss.getVelY() )/ 10);
    
    if( (ss.getPosX() + ss.getVelX()) < maxX + OFFSET_X / 2 || (ss.getPosX() + ss.getVelX()) > - OFFSET_X / 2)
      ss.setVelX(-ss.getVelX());
      
    if( (ss.getPosY() + ss.getVelY()) > maxY + OFFSET_Y / 2 || (ss.getPosY() + ss.getVelY()) < - OFFSET_Y / 2)
      ss.setVelY(-ss.getVelY());

    ss.frameMove();
  }
}
