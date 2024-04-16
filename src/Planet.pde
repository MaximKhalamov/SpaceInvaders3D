float INIT_RADIUS = 300f;
float currentRadius = INIT_RADIUS;
float radiusMultiplier = 1.0f;

class Planet{  
  private float x, y, r;
  private int enemyNumber;
  if(JAVA){
    private PImage texture;
  }
  private boolean hasBoss;
  private PShape model;
  private float multiplierSize;
  private float deltaH;
  //private float planetSize;
  private float prevAngle = 0;
  
  public Planet(int enemyNumber, boolean hasBoss, float planetSize, float multiplierSize, float deltaH){
    float randomAngle = random(- PI / 5 + prevAngle, PI / 5 + prevAngle);
    if(hasBoss){
      randomAngle = random(- PI / 10 + prevAngle, PI / 10 + prevAngle);            
    } else{
      randomAngle = random(- PI / 5 + prevAngle, PI / 5 + prevAngle);    
    }
    prevAngle = randomAngle;
    x = currentRadius * cos(randomAngle);
    y = currentRadius * sin(randomAngle);

    this.hasBoss = hasBoss;
    this.enemyNumber = enemyNumber;
    
    this.multiplierSize = multiplierSize;
    this.deltaH = deltaH;
    
    //this.planetSize = planetSize;
    r = currentRadius;
    currentRadius += 0.5 * INIT_RADIUS;

    model = loadShape(getRandomModel());

    if(model == null){
      println("Model not found");
    }
    model.scale(planetSize * multiplierSize);
  }
  
  public float getMultiplierSize(){
    return multiplierSize;
  }
  
  public float getDeltaH(){
    return deltaH;
  }
  

  if(JAVA){
    private String getRandomModel(){
      //File directory = new File(RELATIVE_PATH + PLANET_TEXTURE_PATHS);
      File directory = new File(PLANET_TEXTURE_PATHS);
      
      if (!directory.isDirectory()) {
        System.out.println(directory.getAbsolutePath());
        System.err.println("Specified path is not a directory.");
        return null;
      }

      File[] files = directory.listFiles();

      if (files == null || files.length == 0) {
          System.err.println("No files found in the directory.");
          return null;
      }
      Random random = new Random();
      int randomIndex = random.nextInt(files.length);

      // StringBuilder sb = new StringBuilder(files[randomIndex].getRelativePath());
      StringBuilder sb = new StringBuilder(files[randomIndex].toString());
      sb.delete(sb.length() - 4, sb.length());
      sb.append(".obj");
      println(sb.toString());
      return sb.toString();
    }
  }
  if(ANDROID){
    private String getRandomModel(){
      AssetManager assetManager = context.getAssets();

      String[] filesName = new String[0];
      try{
        filesName = assetManager.list(PLANET_TEXTURE_PATHS);
      } catch(IOException e){
        e.printStackTrace();
      }
      Random random = new Random();
      int randomIndex = random.nextInt(filesName.length);
      StringBuilder sb = new StringBuilder(PLANET_TEXTURE_PATHS + filesName[randomIndex]);
      //println("DEBUG: " + PLANET_TEXTURE_PATHS + filesName[randomIndex]);
      sb.delete(sb.length() - 4, sb.length());
      sb.append(".obj");
      return sb.toString();
    }
  }

  public boolean getBossStatus(){
    return hasBoss;
  }
  
  public float getX(){
    return x;
  }

  public float getY(){
    return y;
  }

  public void drawPlanet(){    
    pushMatrix();
    translate(x, y, multiplierSize * deltaH);
    rotateX(PI/2);
    //sphere(planetSize);
    shape(model);
    popMatrix();
  }
  
  public int getEnemyNumber(){
    return enemyNumber;
  }  
}
