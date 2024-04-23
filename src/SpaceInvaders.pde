import java.io.File;
import java.util.Random;
import java.util.List;
import java.util.Map;
import java.util.Iterator;
import java.io.IOException;
import java.io.InputStream;
import java.io.FileOutputStream;
import java.util.Properties;
import java.io.BufferedReader;
import java.io.FileReader;
import java.io.FileWriter;
import java.util.ListIterator;


if(JAVA){
import ddf.minim.*;
import org.gamecontrolplus.*;
import java.awt.*;
}
if(ANDROID){
import android.media.MediaPlayer;
import android.media.SoundPool;
import android.media.AudioManager;
import android.media.AudioAttributes;
import android.content.res.AssetManager;
import android.content.Context;
import android.content.SharedPreferences;
import android.hardware.Sensor;
import android.hardware.SensorManager;
import android.hardware.SensorEvent;
import android.hardware.SensorEventListener;
import cassette.audiofiles.SoundFile;
}


// --------------------------------------- CUSTOMIZABLE ---------------------------------------
int NUMBER_OF_PLANETS =               3;     // Also number of levels
float MULTIPLIER_ENEMIES =            1.0f;  // Multiplier for the numbers of enemies
float MULTIPLIER_FIRE_RATE_ENEMY =    1.0f;
float MULTIPLIER_FIRE_RATE_PLAYER =   1.0f;
float MULTIPLIER_SPEED_ENEMY =        0.0f;
float MULTIPLIER_SCREEN_TRANSISTION = 1.0f;

int PLAYER_HEALTH = 50;
int PLAYER_SHIELD = 20;

int ENEMY_LIGHT_HEALTH = 20;
int ENEMY_LIGHT_SHIELD = 10;

float SENSITIVITY_X = 30f;
float SENSITIVITY_Y = 30f;

boolean IS_CINEMATOGRAPHIC_CAMERA = true;
int NUMBER_OF_WAVES = 2;

float LOD1_DISTANCE = 50.0f;
float LOD2_DISTANCE = 200.0f;
float LOD3_DISTANCE = 3000000.0f;

color PLAYER_BULLET_COLOR = color(0, 255, 0);
color ENEMY_BULLET_COLOR = color(255, 0, 0);

String DEVICE_NAME = "Xbox Wireless Controller";
String RELATIVE_PATH = "/home/max/sketchbook/SpaceInvaders/";

// --------------------------------------- END CUSTOMIZABLE ---------------------------------------

// --------------------------------------- BETTER DO NOT TOUCH ---------------------------------------
if(JAVA){
boolean inGame;
float displayDensity = 2;

int CENTER_X;
int CENTER_Y;

float mouseMovementX;
float mouseMovementY;

byte[] pressedKeys = new byte[256];
}
if(ANDROID){
SpaceInvaders SIA;
SharedPreferences sharedPreferences;
SharedPreferences.Editor editor;
Context context;
SensorManager manager;
Sensor sensor;
AssetManager assetManager;
}


Properties prop;

float PLANET_SIZE = 10.0f;
float STAR_SIZE = 100.0f;

float rx, ry, rz;

boolean isGlobalController = true;

int timeBoss = -1;

// These vars are overrided so you can use any number
int HEIGHT = 0;
int WIDTH = 0;

float coeffX = 1;
float coeffY = 1;

float FOV = PI / 2;

float AXIS_SCALE = 20.0f;

PShape PLAYER_STARSHIP_MODEL;

PShape ENEMY_STARSHIP_LOD0_MODEL;
PShape ENEMY_STARSHIP_LOD1_MODEL;
PShape ENEMY_STARSHIP_LOD2_MODEL;
PShape ENEMY_STARSHIP_LOD3_MODEL;

PShape HEALTH_DAMAGE_MODEL;
PShape SHIELD_DAMAGE_MODEL;

PShape BOSS_STARSHIP_MODEL;
PShape BOSS_STARSHIP_MODEL_DAMAGE;

PShader customShader;
Translation translation;

PImage SHIELD_ICON;
PImage HEALTH_ICON;
PImage DEAD_ICON;
PImage CROSS_ICON;

PFont UI_FONT;

AudioController audioController;
PlanetGenerator planetGenerator;

int STARTLEVEL = 0;
//fireRatePlayer *= 2;

enum State{
  BACKGROUND,
  ACTIONFIELD,
  MENU,
  SETTINGS,
  START
}

enum Signal{
  CONTINUE,
  SWITCH,
  MENU
}

enum Regime{
  CPG,
  INF
}

Regime regime;
// --------------------------------------- END BETTER DO NOT TOUCH ---------------------------------------

// --------------------------------------- FILE PATHS ---------------------------------------

if(JAVA){
  String prefixFile = "assets" + File.separator;
}
if(ANDROID){
  String prefixFile = "";
}

String LOADING_SCREEN = prefixFile + "background" + File.separator + "loadingScreen.png";

String SKYSPHERE_TEXTURE_PATH = prefixFile + "background" + File.separator + "skySphere.png";
String SKYSPHERE_MODEL_PATH = prefixFile + "background" + File.separator + "skySphere.obj";

String STAR_MODEL_PATH = prefixFile + "starSystem" + File.separator + "sphere3.obj";


String PLANET_TEXTURE_PATHS = prefixFile + "starSystem" + File.separator + "planets" + File.separator;
String PLANET_MODEL_PATH = prefixFile + "starSystem" + File.separator + "sphere3.obj";

String PLAYER_MODEL_PATH = prefixFile + "starship" + File.separator + "FIghter2.obj";

String ENEMY_MODEL_LOD3_PATH = prefixFile + "starship" + File.separator + "qfsrgec1aua5.obj";
String ENEMY_MODEL_LOD1_PATH = prefixFile + "starship" + File.separator + "01_2.obj";
String ENEMY_MODEL_LOD2_PATH = prefixFile + "starship" + File.separator + "01_3.obj";
String ENEMY_MODEL_LOD0_PATH = prefixFile + "starship" + File.separator + "FIghter1_1.obj";

String ENEMY_MODEL_SHIELD_PATH = prefixFile + "starship" + File.separator + "01_3_shield.obj";
String ENEMY_MODEL_DAMAGE_PATH = prefixFile + "starship" + File.separator + "01_3_damage.obj";

String BOSS_STARSHIP_MODEL_PATH = prefixFile + "starship" + File.separator + "Boss.obj";
String BOSS_STARSHIP_MODEL_DAMAGE_PATH = prefixFile + "starship" + File.separator + "BossDamage.obj";

String CROSSHAIR_IMG_PATH = prefixFile + "starship" + File.separator + "crosshair.png";

String SOUND_FLYING_LOOP_PATH = prefixFile + "sounds" + File.separator + "JetBoost_Loop.mp3";
String SOUND_FLYING_START_PATH = prefixFile + "sounds" + File.separator + "JetBoost_Start.mp3";
String SOUND_SHOT_PATH = prefixFile + "sounds" + File.separator + "shot.mp3";
String SOUND_DAMAGE_PATH = prefixFile + "sounds" + File.separator + "damage.mp3";
String SOUND_EXPLOSION_PATH = prefixFile + "sounds" + File.separator + "damage.mp3";

String MUSIC_BACKGROUND_PATH = prefixFile + "sounds" + File.separator + "galaxyx27s-edge-154425.mp3";
String MUSIC_BACKGROUND_PATH1 = prefixFile + "sounds" + File.separator + "donx27t-stop-151123.mp3";
String MUSIC_BACKGROUND_PATH2 = prefixFile + "sounds" + File.separator + "galaxyx27.mp3";
String MUSIC_BACKGROUND_PATH3 = prefixFile + "sounds" + File.separator + "push-on-134671.mp3";

String FONT_PATH = prefixFile + "font" + File.separator + "QuinqueFive-48.vlw";
String HUE_SHADER_PATH = prefixFile + "shaders" + File.separator + "hueOffset.glsl";

String CROSS_UI_PATH = prefixFile + "ui" + File.separator + "pause.png";
String DEAD_UI_PATH = prefixFile + "ui" + File.separator + "dead.png";
String HEALTH_UI_PATH = prefixFile + "ui" + File.separator + "health.png";
String SHIELD_UI_PATH = prefixFile + "ui" + File.separator + "shield.png";

// --------------------------------------- END FILE PATHS ---------------------------------------

class Main{
  private ActionField actionField;
  private Background background;
  private List<Planet> planets;
  
  private State currentState = State.START;
  
  private int currentLevel;

  private int playerShield;
  private int playerHealth;

  public Main(State state){
    this();
    currentState = state;
  }

  public Main(){   
    if(JAVA){ 
      inGame = true;
      noCursor();
      warpPointer(CENTER_X, CENTER_Y);
    }
    if(ANDROID){
      audioController = getAudioController();
    }
    playerHealth = PLAYER_HEALTH;
    playerShield = PLAYER_SHIELD;

    planets = new ArrayList<Planet>();
    planetGenerator = new PlanetGenerator();

    for(int i = 0; i < NUMBER_OF_PLANETS; i++){
      planets.add( planetGenerator.getNext() );
    }
    currentLevel = 0;

    actionField = new ActionField(planets);
    background = new Background(planets);
  }

  public State getState(){
    return currentState;
  }

  public Signal drawBackground(){
    return background.drawBG(currentLevel);
  }

  public Signal drawActionField(){
    return this.actionField.calculateActions(currentLevel);
  }
  
  public void changeState(State state){
    this.currentState = state;
  }
  
  public void setNextLevel(){
    currentLevel++;
  }
}

void loadModels(){
  ENEMY_STARSHIP_LOD0_MODEL = modelBuilder(ENEMY_MODEL_LOD0_PATH, ENEMY_MODEL_SCALE);
  ENEMY_STARSHIP_LOD1_MODEL = modelBuilder(ENEMY_MODEL_LOD1_PATH, ENEMY_MODEL_SCALE);
  ENEMY_STARSHIP_LOD2_MODEL = modelBuilder(ENEMY_MODEL_LOD2_PATH, ENEMY_MODEL_SCALE);
  ENEMY_STARSHIP_LOD3_MODEL = modelBuilder(ENEMY_MODEL_LOD2_PATH, ENEMY_MODEL_SCALE);

  HEALTH_DAMAGE_MODEL = modelBuilder(ENEMY_MODEL_DAMAGE_PATH, ENEMY_MODEL_SCALE);
  SHIELD_DAMAGE_MODEL = modelBuilder(ENEMY_MODEL_SHIELD_PATH, ENEMY_MODEL_SCALE);

  BOSS_STARSHIP_MODEL = modelBuilder(BOSS_STARSHIP_MODEL_PATH, 1.0);
  BOSS_STARSHIP_MODEL_DAMAGE = modelBuilder(BOSS_STARSHIP_MODEL_DAMAGE_PATH, 1.0);

  PLAYER_STARSHIP_MODEL = modelBuilder(PLAYER_MODEL_PATH, PLAYER_MODEL_SCALE); 
  
  SHIELD_ICON = loadImage(SHIELD_UI_PATH);
  HEALTH_ICON = loadImage(HEALTH_UI_PATH);
  DEAD_ICON = loadImage(DEAD_UI_PATH);
  CROSS_ICON = loadImage(CROSS_UI_PATH);
}

PShape modelBuilder(String modelPath, float scaleCoeff){
  PShape model = loadShape(modelPath);
  model.scale(scaleCoeff);
  if(ANDROID){
      translate(9999, 9999, 9999);
  }
  return model;
}

Main main;
boolean isLoading = false;
PImage bgImage;
ShaderController shaderController;

void setup(){
  if(JAVA){
    Minim minim = new Minim(this);
    audioController = new AudioController( minim );
    CENTER_X = width / 2;
    CENTER_Y = height / 2;
    noCursor();
  }
  if(ANDROID){
    SIA = this;
    println("setup()");
    context = getContext();
    manager = (SensorManager)context.getSystemService(Context.SENSOR_SERVICE);
    sharedPreferences = context.getSharedPreferences("config.properties", Context.MODE_PRIVATE);
    editor = sharedPreferences.edit();
    orientation(LANDSCAPE);
  }

  
  UI_FONT = loadFont(FONT_PATH);
  textFont(UI_FONT);
  
  HEIGHT = height;
  WIDTH = width;

  translation = new Translation();
  bgImage = loadImage(LOADING_SCREEN);
  fullScreen(P3D);

  perspective(FOV, float(width)/float(height), 1, 400000);
}

ResourcesLoader rl;

MenuController menuController;
MenuController startController;
MenuController settingsUIController;
SettingsController settingsController;


boolean isTouchable = false;
State rememberedState = State.START;

void draw(){
  background(0);
  
  if(!isLoading){
    //public UIButton(float xScreen, float yScreen, float lx, float ly, String text)
    UIButton continueButton = new UIButton(width / 2, 2 * height / 7, 3 * width / 8, height / 10, "continue");
    UIButton restartButton = new UIButton(width / 2, 3 * height / 7, 3 * width / 8, height / 10, "restart");
    UIButton settingsButton = new UIButton(width / 2, 4 * height / 7, 3 * width / 8, height / 10, "settings");
    UIButton exitButton = new UIButton(width / 2, 6 * height / 7, 3 * width / 8, height / 10, "exitmenu");
    List<UIElement> elements = new ArrayList<>();
    elements.add(continueButton);
    elements.add(restartButton);
    elements.add(exitButton);
    elements.add(settingsButton);
    //elements.add(new UIElementSlider(1, 0.5, 2.0, width / 4, "SENSITIVITY", width / 2, 5 * height / 7));

    menuController = new MenuController(elements);
    
    elements = new ArrayList<>();

    rl = new ResourcesLoader();
    rl.startLoading();
    isLoading = true;  
    
    settingsController = new SettingsController();
    
    elements.add(settingsController.getSensitivitySlider());
    elements.add(new UIButton(width / 2, 6 * height / 7, 3 * width / 8, height / 10, "back"));
    elements.add(settingsController.getSoundButton());
    elements.add(settingsController.getMusicButton());
    elements.add(settingsController.getLanguageButton());
    //elements.add(new UIRadioButton(width / 2, 6 * height / 7, height / 10, "Sound"));
    //elements.add(new UIRadioButton(width / 2, 6 * height / 7, height / 10, "Music"));
    //UIButton exitButton = new 

    settingsUIController = new MenuController(elements);
    
    elements = new ArrayList<>();
    elements.add(new UIButton(width / 2, 2 * height / 7, 3 * width / 8, height / 10, "start"));
    elements.add(new UIButton(width / 2, 3 * height / 7, 3 * width / 8, height / 10, "infinite"));
    elements.add(new UIButton(width / 2, 4 * height / 7, 3 * width / 8, height / 10, "settings"));
    elements.add(new UIButton(width / 2, 6 * height / 7, 3 * width / 8, height / 10, "exit"));
    
    startController = new MenuController(elements);
  }
  if(!rl.getIsLoaded()){
    rl.draw();
    return;
  } else{
    switch(main.getState()){
      case ACTIONFIELD: 
      
        switch(main.drawActionField()){
          case SWITCH: 
            main.changeState(State.BACKGROUND);
            main.setNextLevel();
            break;
          case MENU:
            if(main.getState() == State.ACTIONFIELD)
              main.changeState(State.MENU);
            break;
        }
        break;
      case BACKGROUND:
        if(main.drawBackground() == Signal.SWITCH){
          main.changeState(State.ACTIONFIELD);
        }    
        break;
      case START:
        if(JAVA){
          inGame = false;
          cursor();
        }

        startController.draw();
        if(isTouchable == false && !mousePressed)
          isTouchable = true;
        
        if(!isTouchable)
          break;
        // Start
        if(startController.getState(0)){
          main.changeState(State.ACTIONFIELD);
          regime = Regime.CPG;
          if(JAVA){
            inGame = true;  
            noCursor();
            warpPointer(CENTER_X, CENTER_Y);
          }
        }
        // Infinite
        if(startController.getState(1)){
          regime = Regime.INF;
          main.changeState(State.ACTIONFIELD);
          if(JAVA){
            inGame = true;  
            noCursor();
            warpPointer(CENTER_X, CENTER_Y);
          }
        }

        // Settings
        if(startController.getState(2)){
          isTouchable = false;
          rememberedState = State.START;
          main.changeState(State.SETTINGS);
        }
        
        // Exit
        if(startController.getState(3)){
          writeConfig();
          stop();
          exit();
        }
        

        break;  
      
      case MENU:
        menuController.draw();
        if(JAVA){
          if(isTouchable == false && !mousePressed)
            isTouchable = true;
        }
        if(ANDROID){
          if(isTouchable == false && touches.length == 0)
            isTouchable = true;
        }

        
        if(!isTouchable)
          break;
        // Continue
        if(menuController.getState(0)){
          main.changeState(State.ACTIONFIELD);
          if(JAVA){
            inGame = true;  
            noCursor();
            warpPointer(CENTER_X, CENTER_Y);
          }
          if(ANDROID){
            audioController.continuePlayers();
          }

        }
        
        // Restart
        if(menuController.getState(1)){
          resetAll(State.ACTIONFIELD);
          if(JAVA){
            inGame = true;  
            noCursor();
            warpPointer(CENTER_X, CENTER_Y);
          }
          if(ANDROID){
            audioController.continuePlayers();
          }
        }
        
        // BACK TO MENU
        if(menuController.getState(2)){
          resetAll();
        }
        
        // Settings
        if(menuController.getState(3)){
          isTouchable = false;
          rememberedState = State.MENU;
          main.changeState(State.SETTINGS);
        }
        break;
      case SETTINGS:
        // Menu
        audioController.update();
        settingsUIController.draw();
        if(isTouchable == false && !mousePressed)
          isTouchable = true;

        settingsController.update();

        if(!isTouchable)
          break;
        
        if(settingsUIController.getState(1)){
          isTouchable = false;
          main.changeState(rememberedState);
          writeConfig();     
        }

        break;
    }
  }  
}
if(JAVA){
  void writeConfig(){
    prop.setProperty("SENSITIVITY","" + sensitivity);
    prop.setProperty("IS_MUSIC_ON","" + isMusicOn);
    prop.setProperty("IS_SOUND_ON","" + isSoundOn);
    prop.setProperty("LANGUAGE","" + language);
    
    //editor.commit();
    
    try{
      File configFile = new File(sketchPath("config.properties"));
      prop.store(new FileWriter(configFile), "config");
    } catch (IOException ex) {
      ex.printStackTrace();
    }
  }

  void keyPressed() {
    if(key == ESC){
      key = 0;
      if( main.getState() == State.ACTIONFIELD ){
        main.changeState(State.MENU);
        inGame = false;
        cursor();
      }
      else if( main.getState() == State.MENU ){
        main.changeState(State.ACTIONFIELD);
        inGame = true;  
        noCursor();
        warpPointer(CENTER_X, CENTER_Y);
      }
    }
    pressedKeys[keyCode] = 1;
  }

  void keyReleased() {
    pressedKeys[keyCode] = 0;
  }

  void rewrite(){
    while(settingsController == null){
      // nothing, wait for creating Settings Controller
    }
    settingsController.rewrite();
  }

  void readConfig() {
    prop = new Properties();
    File configFile = new File(sketchPath("config.properties"));
    
    try (BufferedReader reader = new BufferedReader(new FileReader(configFile))) {
      prop.load(reader);
    } catch (IOException ex) {
      ex.printStackTrace();
    }

    NUMBER_OF_PLANETS = Integer.parseInt(prop.getProperty("NUMBER_OF_PLANETS"));
    MULTIPLIER_ENEMIES = Float.parseFloat(prop.getProperty("MULTIPLIER_ENEMIES"));
    MULTIPLIER_FIRE_RATE_ENEMY = Float.parseFloat(prop.getProperty("MULTIPLIER_FIRE_RATE_ENEMY"));
    MULTIPLIER_FIRE_RATE_PLAYER = Float.parseFloat(prop.getProperty("MULTIPLIER_FIRE_RATE_PLAYER"));
    MULTIPLIER_SPEED_ENEMY = Float.parseFloat(prop.getProperty("MULTIPLIER_SPEED_ENEMY"));
    MULTIPLIER_SCREEN_TRANSISTION = Float.parseFloat(prop.getProperty("MULTIPLIER_SCREEN_TRANSISTION"));

    PLAYER_HEALTH = Integer.parseInt(prop.getProperty("PLAYER_HEALTH"));
    PLAYER_SHIELD = Integer.parseInt(prop.getProperty("PLAYER_SHIELD"));

    ENEMY_LIGHT_HEALTH = Integer.parseInt(prop.getProperty("ENEMY_LIGHT_HEALTH"));
    ENEMY_LIGHT_SHIELD = Integer.parseInt(prop.getProperty("ENEMY_LIGHT_SHIELD"));

    SENSITIVITY_X = Float.parseFloat(prop.getProperty("SENSITIVITY_X"));
    SENSITIVITY_Y = Float.parseFloat(prop.getProperty("SENSITIVITY_Y"));

    IS_CINEMATOGRAPHIC_CAMERA = Boolean.parseBoolean(prop.getProperty("IS_CINEMATOGRAPHIC_CAMERA"));
    NUMBER_OF_WAVES = Integer.parseInt(prop.getProperty("NUMBER_OF_WAVES"));

    LOD1_DISTANCE = Float.parseFloat(prop.getProperty("LOD1_DISTANCE"));
    LOD2_DISTANCE = Float.parseFloat(prop.getProperty("LOD2_DISTANCE"));
    LOD3_DISTANCE = Float.parseFloat(prop.getProperty("LOD3_DISTANCE"));

    PLAYER_BULLET_COLOR = color(
      Integer.parseInt(prop.getProperty("PLAYER_BULLET_COLOR_R")), 
      Integer.parseInt(prop.getProperty("PLAYER_BULLET_COLOR_G")),
      Integer.parseInt(prop.getProperty("PLAYER_BULLET_COLOR_B")));
    
    ENEMY_BULLET_COLOR = color(
      Integer.parseInt(prop.getProperty("ENEMY_BULLET_COLOR_R")),
      Integer.parseInt(prop.getProperty("ENEMY_BULLET_COLOR_G")),
      Integer.parseInt(prop.getProperty("ENEMY_BULLET_COLOR_B")));
      
    RELATIVE_PATH = prop.getProperty("RELATIVE_PATH");
    
    sensitivity = Float.parseFloat(prop.getProperty("SENSITIVITY"));
    isSoundOn = Boolean.parseBoolean(prop.getProperty("IS_SOUND_ON"));
    isMusicOn = Boolean.parseBoolean(prop.getProperty("IS_MUSIC_ON"));
    language = prop.getProperty("LANGUAGE");
  }
}

if(ANDROID){
  void writeConfig(){
    editor.putString("SENSITIVITY","" + sensitivity);
    editor.putString("IS_MUSIC_ON","" + isMusicOn);
    editor.putString("IS_SOUND_ON","" + isSoundOn);
    editor.putString("LANGUAGE","" + language);
    
    editor.commit();
    
    //try{
    //  prop.store(new FileWriter("config.properties"), "config");
    //} catch (IOException ex) {
    //  ex.printStackTrace();
    //}
  }

  void rewrite(){
    settingsController.rewrite();
  }

  void readConfig() {
    prop = new Properties();
    assetManager = context.getAssets();
    
    try (BufferedReader reader = new BufferedReader(createReader("config.properties"))) {
      prop.load(reader);
    } catch (IOException ex) {
      ex.printStackTrace();
    }

    NUMBER_OF_PLANETS = Integer.parseInt(sharedPreferences.getString("NUMBER_OF_PLANETS", "2"));
    MULTIPLIER_ENEMIES = Float.parseFloat(sharedPreferences.getString("MULTIPLIER_ENEMIES", "0.4"));
    MULTIPLIER_FIRE_RATE_ENEMY = Float.parseFloat(sharedPreferences.getString("MULTIPLIER_FIRE_RATE_ENEMY", "1.8"));
    MULTIPLIER_FIRE_RATE_PLAYER = Float.parseFloat(sharedPreferences.getString("MULTIPLIER_FIRE_RATE_PLAYER", "0.8"));
    MULTIPLIER_SPEED_ENEMY = Float.parseFloat(sharedPreferences.getString("MULTIPLIER_SPEED_ENEMY", "1.0"));
    MULTIPLIER_SCREEN_TRANSISTION = Float.parseFloat(sharedPreferences.getString("MULTIPLIER_SCREEN_TRANSISTION", "1.0"));

    PLAYER_HEALTH = Integer.parseInt(sharedPreferences.getString("PLAYER_HEALTH", "50"));
    PLAYER_SHIELD = Integer.parseInt(sharedPreferences.getString("PLAYER_SHIELD", "20"));

    ENEMY_LIGHT_HEALTH = Integer.parseInt(sharedPreferences.getString("ENEMY_LIGHT_HEALTH", "40"));
    ENEMY_LIGHT_SHIELD = Integer.parseInt(sharedPreferences.getString("ENEMY_LIGHT_SHIELD", "0"));

    SENSITIVITY_X = Float.parseFloat(sharedPreferences.getString("SENSITIVITY_X", "40"));
    SENSITIVITY_Y = Float.parseFloat(sharedPreferences.getString("SENSITIVITY_Y", "40"));

    IS_CINEMATOGRAPHIC_CAMERA = Boolean.parseBoolean(sharedPreferences.getString("IS_CINEMATOGRAPHIC_CAMERA", "true"));
    NUMBER_OF_WAVES = Integer.parseInt(sharedPreferences.getString("NUMBER_OF_WAVES", "3"));

    LOD1_DISTANCE = Float.parseFloat(sharedPreferences.getString("LOD1_DISTANCE", "2000.0"));
    LOD2_DISTANCE = Float.parseFloat(sharedPreferences.getString("LOD2_DISTANCE", "3000.0"));
    LOD3_DISTANCE = Float.parseFloat(sharedPreferences.getString("LOD3_DISTANCE", "3500.0"));

    PLAYER_BULLET_COLOR = color(
      Integer.parseInt(sharedPreferences.getString("PLAYER_BULLET_COLOR_R", "255")), 
      Integer.parseInt(sharedPreferences.getString("PLAYER_BULLET_COLOR_G", "255")),
      Integer.parseInt(sharedPreferences.getString("PLAYER_BULLET_COLOR_B", "0")));
    
    ENEMY_BULLET_COLOR = color(
      Integer.parseInt(sharedPreferences.getString("ENEMY_BULLET_COLOR_R", "255")),
      Integer.parseInt(sharedPreferences.getString("ENEMY_BULLET_COLOR_G", "0")),
      Integer.parseInt(sharedPreferences.getString("ENEMY_BULLET_COLOR_B", "0")));
      
    RELATIVE_PATH = sharedPreferences.getString("RELATIVE_PATH", "BROKEN");
    
    sensitivity = Float.parseFloat(sharedPreferences.getString("SENSITIVITY", "1.0"));
    isSoundOn = Boolean.parseBoolean(sharedPreferences.getString("IS_SOUND_ON", "true"));
    isMusicOn = Boolean.parseBoolean(sharedPreferences.getString("IS_MUSIC_ON", "true"));
    
    language = sharedPreferences.getString("LANGUAGE", "EN");
    
  }
}

void stop(){
  if(audioController != null)
    audioController.stopPlayers();
  if(main != null && main.getState() == State.ACTIONFIELD){
    main.changeState(State.MENU);

  }
  //println("calling stop()");
}

class SettingsController{
  private UIElementSlider sensitivitySlider;
  private UIRadioButton soundController;
  private UIRadioButton musicController;
  private UIStateButton languageController;
  
  public SettingsController(){
    sensitivitySlider = new UIElementSlider(sensitivity, 0.5, 2.0, width / 4, "sensitivity", width / 2, 5 * height / 7);
    soundController = new UIRadioButton(isSoundOn, "sound", width / 2, 4 * height / 14);
    musicController = new UIRadioButton(isMusicOn, "music", width / 2, 6 * height / 14);
    List<String> langs = new ArrayList<>();
    langs.add("EN");
    langs.add("RU");
    languageController = new UIStateButton(width / 2, 2 * height / 14, 3 * width / 8, height / 10, "language", langs);
  }
  
  public UIRadioButton getMusicButton(){
    return musicController;
  }

  public UIRadioButton getSoundButton(){
    return soundController;
  }
  
  public UIElementSlider getSensitivitySlider(){
    return sensitivitySlider;
  }

  public UIStateButton getLanguageButton(){
    return languageController;
  }

  void rewrite(){
    sensitivitySlider.setVal(sensitivity);
    soundController.setVal(isSoundOn);
    musicController.setVal(isMusicOn);
    languageController.setVal(language);
  }
  
  public void update(){
    sensitivity = sensitivitySlider.getVal();
    isSoundOn = soundController.getVal();
    isMusicOn = musicController.getVal();
    language = languageController.getVal();
    translation.setLang(language);
  }
  
}

class ResourcesLoader {
  private volatile boolean isLoaded = false;
  private int counter = 0;
  private int COUNTER_MAX = 60;
  
  public ResourcesLoader(){}
  
  public void startLoading(){
    // here is lambda Runnable class which loads resources
    Thread thread = new Thread(new Runnable(){
      @Override    
      public void run(){
        readConfig();
        translation.setLang(language);
        rewrite();
        shaderController = new ShaderController();
        loadModels();
        main = new Main();
        isLoaded = true;
      }
    });
    thread.start();
  }

  public void emptyLoading(State state){
    // here is lambda Runnable class which loads resources
    Thread thread = new Thread(new Runnable(){
      @Override    
      public void run(){
        //readConfig();
        main = new Main(state);
        isLoaded = true;
      }
    });
    thread.start();
  }

  public void emptyLoading(){
    // here is lambda Runnable class which loads resources
    Thread thread = new Thread(new Runnable(){
      @Override    
      public void run(){
        //readConfig();
        main = new Main();
        isLoaded = true;
      }
    });
    thread.start();
  }
  
  public boolean getIsLoaded(){
    return isLoaded;
  }
  
  public void draw(){
    pushMatrix();
    resetMatrix();
    translate(0, 0, - 2 * height);
    
    background(0);
    
    textureMode(NORMAL); 
    beginShape();
    texture(bgImage);
    vertex(-2 * width, -2*height, 0, 0);
    vertex(2 * width, -2*height, 1, 0);
    vertex(2 * width, 2. *height, 1, 1);
    vertex(-2*width, 2. *height, 0, 1);
    endShape();
    
    textSize(120 * displayDensity);
    hint(DISABLE_DEPTH_TEST);
    fill(255);
    textAlign(LEFT);
    //text(text, - cam.getX() - 1.9 * width, - 1.8 * height + cam.getY(), - 2 * height);
    text(translation.get("loading"), -1.5 * width,  1.5 * height, 0);
    arc(1.5 * width, 1.5 *height, height / 4., height / 4., 0, 2 * PI * (counter % COUNTER_MAX) / COUNTER_MAX);

    counter++;

    popMatrix();
    hint(ENABLE_DEPTH_TEST);
  }
}

if(JAVA){
  void mouseDragged() {
    if(inGame){
      mouseMovementX = 0.05*(mouseX - CENTER_X);
      mouseMovementY = 0.05*(mouseY - CENTER_Y);
      warpPointer(CENTER_X, CENTER_Y);
    }
  }

  void mouseMoved() {
    if(inGame){
      mouseMovementX = 0.05*(mouseX - CENTER_X);
      mouseMovementY = 0.05*(mouseY - CENTER_Y);
      warpPointer(CENTER_X, CENTER_Y);
    }
  }

  // Function to set the cursor position
  void warpPointer(int x, int y) {
    try {
      Robot robot = new Robot();
      robot.mouseMove(x, y);
    } catch (AWTException e) {
      e.printStackTrace();
    }
  }
}

class Timer extends Thread{
  private volatile boolean isInt = false;
  private long msecs;
  
  public Timer(long msecs){
      this.msecs = msecs;
  }        
          
  @Override    
  public void run(){
    try{
        Thread.sleep(msecs);
        isInt = true;
      }
    catch(InterruptedException e){
      e.printStackTrace();
    }
  }
          
  public boolean isInt(){
    return isInt;
  }
}


void resetAll(State state){
  currentRadius = INIT_RADIUS;
  radiusMultiplier = 1.0f;
  enemyKilled = 0;
  fireRatePlayer = MULTIPLIER_FIRE_RATE_PLAYER;
  shaderController.resetAll();
  audioController.continuePlayers();
  timeBoss = -1;
  rl = new ResourcesLoader();
  rl.emptyLoading(state);
}

void resetAll(){
  currentRadius = INIT_RADIUS;
  radiusMultiplier = 1.0f;
  enemyKilled = 0;
  fireRatePlayer = MULTIPLIER_FIRE_RATE_PLAYER;
  shaderController.resetAll();
  audioController.continuePlayers();
  timeBoss = -1;
  rl = new ResourcesLoader();
  rl.emptyLoading();
}