class StarDrawer{
  private int starNumber = 1500;

  float[] starX = new float[starNumber];
  float[] starY = new float[starNumber];
  float[] starZ = new float[starNumber];
  float[] starPZ = new float[starNumber];

  float speed = 40;

  public StarDrawer(){
    for (int i = 0; i < starNumber; i++) {
      starX[i] = random(-width, width);
      starY[i] = random(-height, height);
      starZ[i] = random(width);
      starPZ[i] = starZ[i];
    }
  }
  
  void update(){
    for(int i = 0; i < starNumber; i++){
      starZ[i] = starZ[i] - speed;
      if(starZ[i] < 1){
        starZ[i] = random(width);
        starX[i] = random(-width, width);
        starY[i] = random(-height, height);
        starPZ[i] = starZ[i];
         
      }
    }
  }
  
  void show(){
    fill(255);
    stroke(255);
  
    for(int i = 0; i < starNumber; i++){
      float sx = map(starX[i] / starZ[i], 0, 1, 0, width);
      float sy = map(starY[i] / starZ[i], 0, 1, 0, height);
  
      float r = map(starZ[i], 0, width, 4, 0);
      //ellipse(sx, sy, r, r);
  
      float px = map(starX[i] / starPZ[i], 0, 1, 0, width);
      float py = map(starY[i] / starPZ[i], 0, 1, 0, height);
      
      starPZ[i] = starZ[i];
      
      strokeWeight(r);
      fill(255, 255, 255, 63);
      line(px, py, 0, sx, sy, 0);
      noFill();
    }
  }
}


class ExplosionEffect{
  private float x;
  private float y;
  private float z;
  private int timing = 20;
  private boolean isLarge;
  
  public ExplosionEffect(float x, float y, float z, boolean isLarge){
    this.x = x;
    this.y = y;
    this.z = z;
    this.isLarge = isLarge;
  }
  
  public boolean display(){
    if(timing > 0){
      pushMatrix();
      noStroke();
      translate(x, y, z);
      //fill(255, 127 + 2.5 * timing, 5 * timing, 98);
      //fill(255, 55 + 10 * timing, 0, 98);
      fill(255, 55 + 10 * timing, 0, 170);
      hint(DISABLE_DEPTH_TEST);
      if(isLarge){
        sphere(650f / pow(timing, 0.3));
      }
      else{
        sphere(150f / pow(timing, 0.3));
      }
      hint(ENABLE_DEPTH_TEST);
      popMatrix();
      timing--;
      return true;
    }else{
      return false;
    }
  } 
}

class UIInfo{
  private Starship starship;
  private List<List<Starship>> enemies;
  private int enemiesNumber;
  
  
  public UIInfo(Starship starship, List<List<Starship>> enemies){
    this.starship = starship;
    this.enemies = enemies;
    this.enemiesNumber = getEnemiesNumber();
  }
  
  private int getEnemiesNumber(){
    //int enemiesNum = 0;
    //for(List<Starship> starships : enemies){
    //  enemiesNum += starships.size();
    //}
    //return enemiesNum;
    return (enemies.size() == 0)? 0 : enemies.get(0).size();
  }

  public void displayScreen(color bgColor, String text, color textColor){
    pushMatrix();
    resetMatrix();
    translate(0,0 , - 2 * height);
    textSize(140 * displayDensity);
    hint(DISABLE_DEPTH_TEST);

    fill(bgColor);
    noStroke();
    rect(-2*width, -2*height, 4*width, 4*height);
    fill(textColor);
    textAlign(CENTER);
    text(text, 0, 0, 0);
    hint(ENABLE_DEPTH_TEST);
    popMatrix();
  }

  public void displayScreen(color bgColor, String text, color textColor, int killedNumber){
    pushMatrix();
    resetMatrix();
    translate(0,0 , - 2 * height);
    textSize(240 * displayDensity);
    hint(DISABLE_DEPTH_TEST);

    fill(bgColor);
    noStroke();
    rect(-2*width, -2*height, 4*width, 4*height);
    fill(textColor);
    
    String killedNumberText = new String("" + killedNumber);
    float textLen = textWidth(killedNumberText);
    
    if(ANDROID){
      float sw = 2.4 * height / 10.;
      float totalLen = textLen + sw * displayDensity;
    }
    if(JAVA){
      float sw = 2.4 * height / 10. * 2;
      float totalLen = textLen + sw;
    }

    textAlign(CENTER);
    text(text, 0, 0, 0);
    textAlign(RIGHT, CENTER);
    drawIcon(DEAD_ICON, 0 * width - totalLen / 2, 0.35 * height, 0, sw, sw);
    text(killedNumberText, 0 * width + totalLen / 2, 0.35 * height, 0);
    hint(ENABLE_DEPTH_TEST);
    popMatrix();
  }

if(JAVA){
  public void display(float x, float y, float z){
    int playerShield = starship.getShield();
    int playerHealth = starship.getHealth();
  
    String uiHealthBar = "   " + playerHealth;
    String uiShieldBar = "   " + playerShield;
    String uiEnemiesKilled = "   " + enemyKilled;
    //String uiEnemiesLeft = "Left: " + getEnemiesNumber();
    
    pushMatrix();
    rotateY(PI);
    textSize(180);
    hint(DISABLE_DEPTH_TEST);

    fill(255, 255, 255);
    textAlign(LEFT, CENTER);
    //text(uiEnemiesLeft + "\n" + uiEnemiesKilled, - x - 1.9 * width, - 1.8 * height + y, - 2 * height);
    text(uiEnemiesKilled, - x - 1.9 * width, - 1.8 * height + y, - 2 * height);
    drawIcon(DEAD_ICON, - x - 1.9 * width, - 1.8 * height + y, - 2 * height, height / 5., height / 5.);

    drawIcon(HEALTH_ICON, - x - 1.9 * width, + 1.8 * height + y, - 2 * height, height / 5., height / 5.);
    drawIcon(SHIELD_ICON, - x - 1.4 * width, + 1.8 * height + y, - 2 * height, height / 5., height / 5.);

    if(playerHealth < 20)
      fill(225, 0, 0);
    
    text(uiHealthBar, - x - 1.9 * width, + 1.8 * height + y, - 2 * height);
    text(uiShieldBar, - x - 1.4 * width, + 1.8 * height + y, - 2 * height);    

    hint(ENABLE_DEPTH_TEST);
    popMatrix();
  }
}

if(ANDROID){
  public void display(float x, float y, float z){
    int playerShield = starship.getShield();
    int playerHealth = starship.getHealth();

    String uiHealthBar = "  " + playerHealth;
    String uiShieldBar = "  " + playerShield;
    String uiEnemiesKilled = "  " + enemyKilled;
    
    pushMatrix();
    rotateY(PI);
    textSize(100 * displayDensity);
    hint(DISABLE_DEPTH_TEST);

    fill(255, 255, 255);
    textAlign(LEFT, CENTER);
    //text(uiEnemiesLeft + "\n" + uiEnemiesKilled, - x - 1.9 * width, - 1.8 * height + y, - 2 * height);
    text(uiEnemiesKilled, - x - 0.1 * width, - 1.7 * height + y, - 2 * height);
    drawIcon(DEAD_ICON, - x - 0.1 * width, - 1.7 * height + y, - 2 * height, height / 10., height / 10.);

    if(playerHealth < 20)
      fill(225, 0, 0);
    
    text(uiHealthBar, - x - 1.8 * width, - 1.7 * height + y, - 2 * height);
    text(uiShieldBar, - x - 1.4 * width, - 1.7 * height + y, - 2 * height);    

    fill(255, 255, 255);
    drawIcon(HEALTH_ICON, - x - 1.8 * width, - 1.7 * height + y, - 2 * height, height / 10., height / 10.);
    drawIcon(SHIELD_ICON, - x - 1.4 * width, - 1.7 * height + y, - 2 * height, height / 10., height / 10.);

    hint(ENABLE_DEPTH_TEST);
    popMatrix();
  }
}

  
  public void drawIcon(PImage icon, float x, float y, float z, float sx, float sy){
    textureMode(NORMAL);
    noStroke();
    beginShape();
    texture(icon);
    if(ANDROID){
      sx *= displayDensity;
      sy *= displayDensity;
    }
    vertex(x, y - sy / 2, z, 0, 0);
    vertex(x + sx, y - sy / 2, z, 1, 0);
    vertex(x + sx, y + sy / 2, z, 1, 1);
    vertex(x, y + sy / 2, z, 0, 1);
    endShape();
  }
}

class ShaderController{
  private PShader hueShader;
  //private float seed;
  
  private int currentValue = 0;
  
  private float[][] valuesHSV = {
    {0.10, 0.48, 1.00},  // not used
    {0.10, 0.48, 1.00}, // 1st level
    
    {0.11, 0.81, 1.00},  // 1-2 transition
    {0.11, 0.81, 1.00},  // 2nd level
    
    {0.20, 0.46, 1.00},  // 2-3 transition
    {0.20, 0.46, 1.00},  // 3rd level
    
    {0.32, 0.46, 0.85},  // 3-4 transition
    {0.32, 0.46, 0.85},  // 4th level
    
    {0.39, 0.63, 0.80},  // 4-5 transition
    {0.39, 0.63, 0.80},  // 5th level
    
    {0.39, 0.88, 0.75},  // 5-6 transition
    {0.39, 0.88, 0.75},  // 6th level
    
    {0.40, 1.00, 0.50},  // 6-7 transition
    {0.40, 1.00, 0.50},  // 7th level

    {0.44, 1.00, 0.70},  // 7-8 transition
    {0.44, 1.00, 0.70}   // 8th level
};
  
  public ShaderController(){
    hueShader = loadShader(HUE_SHADER_PATH);
  }
  
  public void useHueShader(){
    int val = currentValue % valuesHSV.length;
    hueShader.set("hueShift", valuesHSV[val][0]);
    hueShader.set("satFactor", valuesHSV[val][1]);
    hueShader.set("valFactor", valuesHSV[val][2]);
    //randomize();
    shader(hueShader);
  }
  
  public void resetShaders(){
    resetShader();
  }
  
  public void randomize(){
    currentValue++;
    //seed = millis() / 10.;
    //seed = millis() / 1000.;
  }
  
  public void resetAll(){
    currentValue = 0;
  }
}

int TIMING_SCAN_MODE = 2;
int TIMING_LOCATING = 20;
int TIMING_RECEIVING = 23;
int TIMING_INCOMING = 5;
int TIMING_BETWEEN_FUNCS = 4;
int TIMING_ENTERNING = 8;
int TIMITG_SECOND = 30;

class PreparingInfo{
  private int timing = 0;  
  private List<String> functions;
  
  public PreparingInfo(){
    functions = new ArrayList<>();
  }
  
  public void display(float x, float y, float z){
    //pushMatrix();
    //translate(x, y, z);
    //rotateY(PI);
    //textSize(240);
    ////textAlign(CENTER, CENTER);  
    //hint(DISABLE_DEPTH_TEST);
    //text("word", 100, 100);
    //fill(0, 408, 612, 816);
    //text("word", 100, 180, -120);  // Specify a z-axis value
    //text("word", 48, 240);
    //hint(ENABLE_DEPTH_TEST);
    
    //popMatrix();
    timing++;
  }
}
