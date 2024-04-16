enum TrajectoryType{
  TRAJECTORY_ELLIPSE,
  TRAJECTORY_ASTROID,
  TRAJECTORY_DELTOID,
  TRAJECTORY_PENTOID,
  TRAJECTORY_SEXTOID,
  TRAJECTORY_LISSAJOUS1,
  TRAJECTORY_LISSAJOUS2,
  TRAJECTORY_LISSAJOUS3,
  TRAJECTORY_LISSAJOUS4
}



class WaveController{
  private int OFFSET_X = -50;
  private int OFFSET_Y = 50;
  private float maxX = -WIDTH, maxY = HEIGHT;
  
  private float lMax = 16000f;
  private float lMin = 1600f;
  private float V_MIN = -0.4 * MULTIPLIER_SPEED_ENEMY;
  private float vMin = V_MIN;
  
  //private float smallAcceleration = -0.001f;
  
  private float dT = 0.0005f;
  private int dTCount = 60 * 5;
  
  private float acceleration = 2 / pow(dTCount * dT, 2) * (lMax + dTCount * dT * vMin - lMin);
  private float vMax = vMin - acceleration * (dTCount * dT);
  private boolean isSlowedDown = false;
  
  private float deltaT;
  private float t = 0.0f;
  private int enemyNumber;
  private List<Starship> starships;
  private TrajectoryType trajectoryType;
  Map<Starship, Integer> starshipsWithTimer = new HashMap<>();
  
  
  private WaveController(){
    
  }
  
  public WaveController(int enemyNumber){
    this.enemyNumber = enemyNumber;
    this.starships = generateWave(enemyNumber);
    
    float r = (random(2) < 1) ? 1 : -1; 
    deltaT = dT * r;
    
    for(int i = 0; i < enemyNumber; i++){
      starshipsWithTimer.put(this.starships.get(i), i);
    }
  }
  
  public List<Starship> generateWave(int enemyCount){
    return generateWave(getRandomEnumValue(TrajectoryType.class), enemyCount);
  }
  
  public List<Starship> generateWave(TrajectoryType trajectoryType, int enemyCount){
    this.trajectoryType = trajectoryType;
    List<Starship> enemies = new ArrayList<>();
    for(int i = 0; i < enemyCount; i++){
      Starship ss = new EnemyStarship(ENEMY_LIGHT_HEALTH, ENEMY_LIGHT_SHIELD, 0, 0, 16000);
      ss.setShotStatus(false);
      //ss.setVelZ(- 40);
      enemies.add(ss);
    }
    starships = enemies;
    initMove();
  return enemies;
  }
  
  public List<Starship> getStarships(){
    return starships;
  }
  
  public void moveFrame(){
    t += deltaT;

    if(!starships.isEmpty()){
      if(!isSlowedDown){
        if(starships.get(0).getPosZ() < lMin + 1f){
          for(Starship ss : starships){
            ss.setVelZ(vMin);
            ss.setShotStatus(true);  
          }
          isSlowedDown = true;
        }
        for(Starship ss : starships){
          ss.setPosZ( lMax + abs(t) * vMax + acceleration * t * t / 2);
          
        }
          //println(lMax + abs(t) * vMax + acceleration * t * t / 2);
      }
      
      if(starships.get(0).getPosZ() < lMin){
        for(Starship ss : starships){
          ss.setVelZ(ss.getVelZ() - 0.0105f * pow(abs(ss.getVelZ() - V_MIN - 0.02f), 1.7) );  
        }
        //println("Velocity Z: " + starships.get(0).getVelZ());
      }
      
      Iterator<Starship> iterator = starships.iterator();
      while (iterator.hasNext()) {
          Starship obj = iterator.next();
          //obj.setVelZ(obj.getVelZ() + smallAcceleration);
          obj.frameMove();
          boolean toDelete = true;
          for(Map.Entry<Starship, Integer> pair : starshipsWithTimer.entrySet()){
            if(pair.getKey().getID() == obj.getID()){
              toDelete = false; break;
            }
          }
          if(toDelete){
              iterator.remove();
          }        
      }
      
      for(Map.Entry<Starship, Integer> pair : starshipsWithTimer.entrySet()){
        setPosition(pair.getKey(), pair.getValue());
      }
    }
    
    
    //starships = starshipsWithTimer.keySet().stream().collect(Collectors.toList());
    //for(Starship pair : starshipsWithTimer.keySet()){
    //  starship
    //  setPosition(starships.get(i), i);      
    //}
    
    //for(int i = 0; i < starships.size(); i++){
    //  setPosition(starships.get(i), i);
    //}
  }
  
  private <T extends Enum<?>> T getRandomEnumValue(Class<T> enumClass) {
        Random random = new Random();
        T[] values = enumClass.getEnumConstants();
        return values[random.nextInt(values.length)];
    }
  
  private void initMove(){
    for(int i = 0; i < enemyNumber; i++){
      setPosition(starships.get(i), i);
    }  
  }

  private void setPosition(Starship ss, int i){
    float prevPosX = ss.getPosX();
    
    switch(trajectoryType){
      case TRAJECTORY_ELLIPSE: 
        ss.setPosX(lerp(maxX - OFFSET_X, OFFSET_X, 0.5 * (1 + sin( 2* PI * ( (float)i / enemyNumber + t ) )))); 
        ss.setPosY(lerp(maxY - OFFSET_Y, OFFSET_Y, 0.5 * (1 + cos( 2* PI * ( (float)i / enemyNumber + t ) )))); 
        break;
      case TRAJECTORY_ASTROID: 
        ss.setPosX(lerp(maxX - OFFSET_X, OFFSET_X, getHypocycloidX(4.0, ( (float)i / enemyNumber + t ) ))); 
        ss.setPosY(lerp(maxY - OFFSET_Y, OFFSET_Y, getHypocycloidY(4.0, ( (float)i / enemyNumber + t ) ))); 
        break;
      case TRAJECTORY_DELTOID: 
        ss.setPosX(lerp(maxX - OFFSET_X, OFFSET_X, getHypocycloidX(3.0, ( (float)i / enemyNumber + t ) ))); 
        ss.setPosY(lerp(maxY - OFFSET_Y, OFFSET_Y, getHypocycloidY(3.0, ( (float)i / enemyNumber + t ) ))); 
        break;
      case TRAJECTORY_PENTOID: 
        ss.setPosX(lerp(maxX - OFFSET_X, OFFSET_X, getHypocycloidX(5.0, ( (float)i / enemyNumber + t ) ))); 
        ss.setPosY(lerp(maxY - OFFSET_Y, OFFSET_Y, getHypocycloidY(5.0, ( (float)i / enemyNumber + t ) ))); 
        break;
      case TRAJECTORY_SEXTOID: 
        ss.setPosX(lerp(maxX - OFFSET_X, OFFSET_X, getHypocycloidX(6.0, ( (float)i / enemyNumber + t ) ))); 
        ss.setPosY(lerp(maxY - OFFSET_Y, OFFSET_Y, getHypocycloidY(6.0, ( (float)i / enemyNumber + t ) ))); 
        break;
      case TRAJECTORY_LISSAJOUS1: 
        ss.setPosX(lerp(maxX - OFFSET_X, OFFSET_X, 0.5 * (1 + sin( 3 * 2* PI * ( (float)i / enemyNumber + t ) )))); 
        ss.setPosY(lerp(maxY - OFFSET_Y, OFFSET_Y, 0.5 * (1 + sin( 2 * 2* PI * ( (float)i / enemyNumber + t ) )))); 
        break;
      case TRAJECTORY_LISSAJOUS2: 
        ss.setPosX(lerp(maxX - OFFSET_X, OFFSET_X, 0.5 * (1 + sin( 3 * 2* PI * ( (float)i / enemyNumber + t ) )))); 
        ss.setPosY(lerp(maxY - OFFSET_Y, OFFSET_Y, 0.5 * (1 + sin( 2 * 2* PI * ( (float)i / enemyNumber + t ) )))); 
        break;
      case TRAJECTORY_LISSAJOUS3: 
        ss.setPosX(lerp(maxX - OFFSET_X, OFFSET_X, 0.5 * (1 + sin( 3 * 2* PI * ( (float)i / enemyNumber + t ) )))); 
        ss.setPosY(lerp(maxY - OFFSET_Y, OFFSET_Y, 0.5 * (1 + sin( 1 * 2* PI * ( (float)i / enemyNumber + t ) )))); 
        break;
      case TRAJECTORY_LISSAJOUS4: 
        ss.setPosX(lerp(maxX - OFFSET_X, OFFSET_X, 0.5 * (1 + sin( 1 * 2* PI * ( (float)i / enemyNumber + t ) )))); 
        ss.setPosY(lerp(maxY - OFFSET_Y, OFFSET_Y, 0.5 * (1 + sin( 3 * 2* PI * ( (float)i / enemyNumber + t ) )))); 
        break;
    }
    float nextPosX = ss.getPosX();    
    
    ss.setRotation(-0.015 * (nextPosX - prevPosX) );
  }
  
  // r = 1
  // t0 from 0 to 1
  // return from 0 to 1
  private float getHypocycloidX(float k, float t0){
    float t = lerp(0.0, 2 * PI, t0) + PI / k;
    float r = 1 / k * (k - 1) * (cos(t) + cos( (k-1) * t ) / (k - 1));
    return (r + 1) / 2;
  }

  private float getHypocycloidY(float k, float t0){
    float t = lerp(0.0, 2 * PI, t0) + PI / k;
    float r = 1 / k * (k - 1) * (sin(t) - sin( (k-1) * t ) / (k - 1));
    return (r + 1) / 2;    
  }
}
