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

  public void displayTimer(float t, float x, float y, float z){
    if(t > 0){
      textAlign(CENTER, CENTER);
    if(t > 10)
      fill(255, 255, 255);
    else 
      fill(255, 0, 0);
      if(JAVA){
        text(int(t / 60) + ":" + String.format("%02d", int(t % 60)), - x, - 1.8 * height + y, - 2 * height);
      }
      if(ANDROID){
        text(int(t / 60) + ":" + String.format("%02d", int(t % 60)), - x, - 1.4 * height + y, - 2 * height);
      }
    }
  }

  public void displayBestScore(float x, float y, float z){
    textAlign(CENTER, UP);
    fill(255, 255, 255);
    if(JAVA){
      text(translation.get("best") + "\n" + bestScore, - x + 1.6 * width, - 1.8 * height + y, - 2 * height);
    }
    if(ANDROID){
      text(translation.get("best") + "\n" + bestScore, - x + 1.6 * width + height * 0.05, - 1.4 * height + y, - 2 * height);
    }
  }

  public void displayScreen(color bgColor, String text, color textColor){
    pushMatrix();
    resetMatrix();
    translate(0,0 , - 2 * height);
    textSize(4./5 * 140 * displayDensity);
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
    textSize(4./5 * 240 * displayDensity);
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
  
    String uiHealthBar = "       " + playerHealth;
    String uiShieldBar = "       " + playerShield;
    String uiEnemiesKilled = "       " + enemyKilled;
    //String uiEnemiesLeft = "Left: " + getEnemiesNumber();
    
    pushMatrix();
    rotateY(PI);
    textSize(4./5 * 180);
    hint(DISABLE_DEPTH_TEST);

    fill(255, 255, 255);
    textAlign(LEFT, CENTER);
    //text(uiEnemiesLeft + "\n" + uiEnemiesKilled, - x - 1.9 * width, - 1.8 * height + y, - 2 * height);
    text(uiEnemiesKilled, height / 5. - x - 1.9 * width, - 1.8 * height + y, - 2 * height);
    drawIcon(DEAD_ICON, - x - 1.9 * width, - 1.8 * height + y, - 2 * height, height / 5., height / 5.);

    drawIcon(HEALTH_ICON, - x - 1.9 * width, + 1.8 * height + y, - 2 * height, height / 5., height / 5.);
    drawIcon(SHIELD_ICON, - x - 1.4 * width, + 1.8 * height + y, - 2 * height, height / 5., height / 5.);

    if(playerHealth < 20)
      fill(225, 0, 0);
    
    text(uiHealthBar, height / 5. - x - 1.9 * width, + 1.8 * height + y, - 2 * height);
    text(uiShieldBar, height / 5. - x - 1.4 * width, + 1.8 * height + y, - 2 * height);    

    displayTimer(timeBoss, x, y, z);
    displayBestScore(x, y, z);
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
    textSize(4./5 * 80 * displayDensity);
    hint(DISABLE_DEPTH_TEST);

    fill(255, 255, 255);
    textAlign(LEFT, CENTER);
    //text(uiEnemiesLeft + "\n" + uiEnemiesKilled, - x - 1.9 * width, - 1.8 * height + y, - 2 * height);
    text(uiEnemiesKilled, height / 5. - x - 0.1 * width, - 1.7 * height + y, - 2 * height);
    drawIcon(DEAD_ICON, - x - 0.1 * width, - 1.7 * height + y, - 2 * height, height / 10., height / 10.);

    if(playerHealth < 20)
      fill(225, 0, 0);
    
    text(uiHealthBar, height / 5. - x - 1.8 * width, - 1.7 * height + y, - 2 * height);
    text(uiShieldBar, height / 5. - x - 1.4 * width, - 1.7 * height + y, - 2 * height);    

    fill(255, 255, 255);
    drawIcon(HEALTH_ICON, - x - 1.8 * width, - 1.7 * height + y, - 2 * height, height / 10., height / 10.);
    drawIcon(SHIELD_ICON, - x - 1.4 * width, - 1.7 * height + y, - 2 * height, height / 10., height / 10.);

    displayTimer(timeBoss, x, y, z);
    displayBestScore(x, y, z);
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
  private int currentValue = 0;
  private boolean isReversed = false;

  private float[][] valuesHSV = {
    {0.10, 0.50, 0.60},  // 8-1 transition
    {0.10, 0.50, 0.60},  // 1st level

    {0.09, 0.15, 0.40}, // 1-2 transition
    {0.09, 0.15, 0.40}, // 2nd level

    {0.19, 0.40, 0.45},  // 2-3 transition
    {0.19, 0.40, 0.45},  // 3rd level

    {0.27, 0.45, 0.50}, // 3-4 transition
    {0.27, 0.45, 0.50}, // 4th level

    {0.38, 0.40, 0.60},  // 4-5 transition
    {0.38, 0.40, 0.60},  // 5th level

    {0.40, 1.00, 0.50}, // 5-6 transition
    {0.40, 1.00, 0.50}, // 6th level

    {0.43, 1.00, 0.55},  // 6-7 transition
    {0.43, 1.00, 0.55},  // 7th level

    {0.43, 1.00, 0.80}, // 7-8 transition
    {0.43, 1.00, 0.80}, // 8th level
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
      if(currentValue == 0 && isReversed){
        isReversed = false;
        currentValue = -1;
      }

      if(currentValue == (valuesHSV.length - 1) && !isReversed){
        isReversed = true;
        currentValue = valuesHSV.length;
      }

      if(isReversed)
        currentValue--;
      else
        currentValue++;
  }
  
  public void resetAll(){
    currentValue = 0;
    isReversed = false;
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
