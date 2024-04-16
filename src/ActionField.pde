int enemyKilled = 0;
float fireRatePlayer = MULTIPLIER_FIRE_RATE_PLAYER;

float CAM_INIT_X = 0;
float CAM_INIT_Y = -18;
float CAM_INIT_Z = -48;

enum ActionFieldState{
  INIT,
  PREPARING,
  PREBATTLE_INFO,
  BATTLE,
  GAMEOVER,
  CLEARED,
  VICTORY,
  RESTART,
  WAIT_FOR_SCREEN
}


class ActionField{
  private MainStarship mainStarship;
  private List<List<Starship>> enemies;
  private List<Bullet> bullets;
  private List<Planet> planets;
  private List<ExplosionEffect> effects;
  private Control control;
  private List<WaveController> waveControllers;
  private UIInfo uiInfo;
  private MenuController restartController;
  
  if(ANDROID){
  private UIControllerActionField uiController;
  }

  private int bulletTiming = 40;
  private int prepareTiming;
  private int clearedTiming;

  private ActionFieldState state = ActionFieldState.INIT;
  private PreparingInfo preparingInfo;

  private int currentLevel;
  //private int enemyNumber;
  private List<Starship> waveList;

  private PShape skySphereModel;
  private PImage skySphereTexture;

  private boolean isTouchable = false;
  
  private float skyBoxSize = 17000f;
  private float skyBoxRotation;

  private PImage crosshair = loadImage(CROSSHAIR_IMG_PATH);

  private int redScreenTiming = 0;

  private float camInitX = 0, camInitY = -18, camInitZ = -48;
  private float easing = 0.09;
  private Timer timer;

  //private float tx = WIDTH / 2;
  //private float ty = HEIGHT / 2;

  private StarDrawer sd;

  //private BackgroundCamera cam = new BackgroundCamera(camInitX, camInitY, camInitZ,
  //                                                    camInitX, camInitY, camInitZ + 0.1,
  //                                                    0, 1, 0);
                                                      
  private BackgroundCamera cam = new BackgroundCamera(-WIDTH / 2, HEIGHT / 2, camInitZ,
                                                      -WIDTH / 2, HEIGHT / 2, camInitZ + 0.1,
                                                      0, 1, 0);

  public ActionField(List<Planet> planets){
    bullets = new ArrayList<>();
    this.planets = planets;

    skySphereModel = loadShape(SKYSPHERE_MODEL_PATH);
    skySphereTexture = loadImage(SKYSPHERE_TEXTURE_PATH);
    skySphereModel.setTexture(skySphereTexture);
    skySphereModel.scale(skyBoxSize);

    waveControllers = new ArrayList<>();
    mainStarship = new MainStarship(PLAYER_HEALTH, PLAYER_SHIELD, WIDTH / 2f, HEIGHT / 2f);

    control = new Control();

    List<UIElement> UIElements = new ArrayList<>();

    if(ANDROID){
    UIElements.add(new UIElementShot(width * 0.8, height * 0.6));
    UIElements.add(new UIElementJoystick(width * 0.2, height * 0.6));
    UIElement button = new UIButton(width * 0.90, height * 0.08, height * 0.1, height * 0.1, "menu");

    UIElements.add(button);
    uiController = new UIControllerActionField(UIElements, button);
    }

    UIElements = new ArrayList<>();
    UIElements.add(new UIButton(12 * width / 16, height / 2, 3 * width / 8, height / 10, "restart"));
    UIElements.add(new UIButton(4 * width / 16, height / 2, 3 * width / 8, height / 10, "exit"));

    restartController = new MenuController(UIElements);
  }

  private void displayAxis(float x, float y, float z){
    pushMatrix();

      //X  - red
      stroke(192,0,0);
      line(x, y, z, x + AXIS_SCALE * 1000, y, z);
      text("X", x + AXIS_SCALE * 1000, y, z);

      //Y - green
      stroke(0,192,0);
      line(x, y, z, x, y + AXIS_SCALE * 1000, z);
      text("Y", x, y + AXIS_SCALE * 1000, z);

      //Z - blue
      stroke(0,0,192);
      line(x, y, z, x, y, z + AXIS_SCALE * 1000);
      text("Z", x, y, z + AXIS_SCALE * 1000);
    popMatrix();  
  }

  private void displayAll(){
    if(JAVA){
      boolean pressed = mousePressed;
    }
    if(ANDROID){
      boolean pressed = touches.length != 0;
    }
    pushMatrix();
    noLights();
    rotateY(skyBoxRotation);
    shaderController.useHueShader();
    shape(skySphereModel);
    shaderController.resetShaders();
    popMatrix();
    lights();

    float tx = cam.getX();
    float ty = cam.getY();

    Iterator<ExplosionEffect> iterEffect = effects.iterator();
    while(iterEffect.hasNext()){
      ExplosionEffect effect = iterEffect.next(); 
      if(!effect.display()){
        iterEffect.remove();
      }
    }

    if(ANDROID){
      cam.setX(lerp(cam.getX(), -coeffX*control.getX(), easing));
      cam.setY(lerp(cam.getY(), coeffY*control.getY(), easing));
      
      bulletTiming--;
      if(control.isPressed() && state == ActionFieldState.BATTLE){
        if( bulletTiming < 0 ){
            mainStarship.shot(bullets);
            audioController.playOnceShot();
          bulletTiming = (int)(10. / fireRatePlayer);    
        }
      }
    }

    if(JAVA){
      cam.setX(lerp(cam.getX(), -coeffX*control.getX(mouseMovementX), easing));
      cam.setY(lerp(cam.getY(), coeffY*control.getY(mouseMovementY), easing));
      
      bulletTiming--;
      if(pressed && (mouseButton == LEFT) && state == ActionFieldState.BATTLE){
        if( bulletTiming < 0 ){
            mainStarship.shot(bullets);
            audioController.playOnceShot();
          bulletTiming = (int)(10. / fireRatePlayer);    
        }
      }
    }

    mainStarship.setPosX(cam.getX() - camInitX);
    mainStarship.setPosY(cam.getY() - camInitY);
    mainStarship.setPosZ(cam.getZ() - camInitZ);
    pointLight(255,255,127, cam.getX() - camInitX + random(-5, 5), cam.getY() - camInitY + 1 + random(-5, 5), cam.getZ() - camInitZ - 40 + random(-5, 5));
    mainStarship.display(cam.getX(), cam.getY(), cam.getZ(), 0, 0, 1, 0.015 * (tx - cam.getX()));

    //displayAxis(cam.getX() - camInitX, cam.getY() - camInitY, cam.getZ() - camInitZ);

    pushMatrix();
    //translate(cam.getX(), cam.getY(), -cam.getZ());
    translate(tx, ty, -cam.getZ());
    sd.update();
    sd.show();
    popMatrix();

    pushMatrix();
    translate(cam.getX() - camInitX - 100, cam.getY() - camInitY - 100, cam.getZ() - camInitZ + 600); 
    scale(2);
    hint(DISABLE_DEPTH_TEST);
    image(crosshair, 0, 0);
    hint(ENABLE_DEPTH_TEST);
    popMatrix();

    camera(cam.getX(), cam.getY(), cam.getZ(), cam.getX(), cam.getY(), cam.getZ() + 0.1, 0, 1, 0);
    
    hint(DISABLE_DEPTH_TEST);
    pushMatrix();
    resetMatrix();
    translate(cam.getX(), cam.getY(), cam.getZ()+0.1);
    fill(255,255,255);
    rect(100, 100, 500, 500);
    popMatrix();
    hint(ENABLE_DEPTH_TEST);
  }

  private void displayAllEnemies(){
    for(Starship ss : enemies.get(0)){
      ss.display(cam.getX(), cam.getY(), cam.getZ(), 0, 0, 1); 
    }
  }
 
  public Signal calculateActions(int level){    

    if(JAVA){
      boolean pressed = mousePressed;
    }
    if(ANDROID){
      boolean pressed = touches.length != 0;
    }

    switch(state){
      case INIT:
        shaderController.randomize();
        mainStarship.setShield(PLAYER_SHIELD);
        mainStarship.improveStarship();
        preparingInfo = new PreparingInfo();
        effects = new ArrayList<>();
        skyBoxRotation = random(-PI, PI);
        bullets.clear();
        currentLevel = level;
        enemies = new ArrayList<>();
        waveControllers = new ArrayList<>();
        List<Starship> waveListGen = new ArrayList<>();
        
        if(planets.get(currentLevel).getBossStatus()){
          BossController bossController = new BossController(mainStarship, bullets);
          waveListGen = bossController.getStarships();
          enemies.add(waveListGen);
          waveControllers.add(bossController);
        }else if(planets.get(currentLevel + 1).getBossStatus()){
          LightBossController bossController = new LightBossController(mainStarship, bullets);
          waveListGen = bossController.getStarships();
          enemies.add(waveListGen);
          waveControllers.add(bossController);          
        }else{
          for(int j = 0; j < NUMBER_OF_WAVES; j++){
            
            waveControllers.add(new WaveController(planets.get(currentLevel).getEnemyNumber()));
            waveListGen = waveControllers.get(j).getStarships();
            enemies.add(waveListGen);
          }
        }    
        uiInfo = new UIInfo(mainStarship, enemies);
  
        sd = new StarDrawer();
        
        state = ActionFieldState.PREPARING;
        prepareTiming = (int)(80 * MULTIPLIER_SCREEN_TRANSISTION);
        clearedTiming = (int)(80 * MULTIPLIER_SCREEN_TRANSISTION);
        break;
      
      case PREPARING: 
        displayAllEnemies();
        displayAll();
        uiInfo.displayScreen(color(0,0,0, 180), translation.get("prepare"), color(240,200,80));
        
        pushMatrix();
        preparingInfo.display(cam.getX() + WIDTH / 2, cam.getY() - HEIGHT / 2, cam.getZ()+10);
        popMatrix();
        
        prepareTiming--;
        if(prepareTiming == 0){
          audioController.playBattleSpeach();
          state = ActionFieldState.BATTLE;
        }
        return Signal.CONTINUE;
      case CLEARED:
        displayAll();
        uiInfo.displayScreen(color(0,0,0, 180), translation.get("cleared"), color(95,85,149));
        clearedTiming--;
        if(clearedTiming == 0){
          state = ActionFieldState.INIT;
          return Signal.SWITCH;
        }
        return Signal.CONTINUE;
      case WAIT_FOR_SCREEN:
        displayAll();
        uiInfo.display(cam.getX(), cam.getY(), cam.getZ());

        if(timer.isInt()){
          if(currentLevel == planets.size() - 1){
            state = ActionFieldState.VICTORY;
          } else {
            state = ActionFieldState.CLEARED;
          }      
        }
        
        if(ANDROID){
          Signal sig = Signal.CONTINUE;
          uiController.check();   
          uiController.draw();
          if(uiController.isMenuCalling())
            sig = Signal.MENU;
          //state = ActionFieldState.CLEARED;
          return sig;    
        }

        if(JAVA){
          return Signal.CONTINUE;   
        }
      case VICTORY:
        displayAll();
        uiInfo.displayScreen(color(0,0,0, 180), translation.get("youwin"), color(102,185,42), enemyKilled);
        audioController.stopPlayers();
        if(isTouchable == false && !pressed)
          isTouchable = true;

        if(!isTouchable)
          return Signal.CONTINUE;
          
        if(pressed){
          isTouchable = false;
          state = ActionFieldState.RESTART;
        }

        return Signal.CONTINUE;
      case GAMEOVER:
        uiInfo.displayScreen(color(0,0,0, 180), translation.get("gameover"), color(115,41,25), enemyKilled);
        //audioController.stopLoopSounds(true);
        audioController.stopPlayers();
        
        if(isTouchable == false && !pressed)
          isTouchable = true;

        if(!isTouchable){
          return Signal.CONTINUE;
        }
        
        if(pressed){
          isTouchable = false;
          state = ActionFieldState.RESTART;
        }
        return Signal.CONTINUE;

      case RESTART:
        if(JAVA){
          inGame = false;
          cursor();
        }

        restartController.draw();
        
        if(isTouchable == false && !pressed)
          isTouchable = true;

        if(!isTouchable)
          return Signal.CONTINUE;
        
        if(restartController.getState(0)){
          //audioController.stopPlayers();
          //main = new Main();
          //audioController.playLoopSounds();
          currentRadius = INIT_RADIUS;
          radiusMultiplier = 1.0f;
          enemyKilled = 0;
          fireRatePlayer = MULTIPLIER_FIRE_RATE_PLAYER;
          shaderController.resetAll();
          audioController.continuePlayers();
          rl = new ResourcesLoader();
          rl.emptyLoading();
        }
        
        // Exit
        if(restartController.getState(1)){
          exit();
        }
        return Signal.CONTINUE;
      default:
        break;
      }
    
    audioController.playLoopSounds();

    ////Enemy collision check    
    waveList = enemies.get(0);
    Iterator<Starship> enemyIterator = waveList.iterator();
    while(enemyIterator.hasNext()){
      if(!bullets.isEmpty()){
        Starship enemy = enemyIterator.next();
        if(enemy.checkCollision(mainStarship)){
          mainStarship.setDamage(9999);
        }
        Iterator<Bullet> bulletIterator = bullets.iterator();
          while(bulletIterator.hasNext()){
            Bullet bullet = bulletIterator.next();
            if(bullet == null){
              bulletIterator.remove();
              continue;
            }
            if(bullet.isTimeOver()){
              bulletIterator.remove();
              continue;
            }else if(bullet.checkCollision(enemy)){
              bulletIterator.remove();
              if(enemy.setDamage( bullet.getDamage() )){
                effects.add( new ExplosionEffect( enemy.getPosX(), enemy.getPosY(), enemy.getPosZ(), enemy instanceof BossStarship ) );
                enemyIterator.remove();
                enemyKilled++;
              }; 
              break;      
            }
        }    
      } else {
        break;
      }
    }
    
    //  //enemy.move();                                      // HERE I NEED TO MOVE ENEMY'S STARSHIP
    //}
    //for(WaveController wc : ){
      waveControllers.get(0).moveFrame();
    //}
    
    ////Player collision check
    if(!bullets.isEmpty()){
      Iterator<Bullet> bulletIterator = bullets.iterator();
      while(bulletIterator.hasNext()){
        Bullet bullet = bulletIterator.next();
        if(bullet == null){
          bulletIterator.remove();
          continue;
        }
        if(bullet.checkCollision(mainStarship)){
          audioController.playOnceDamage();
          redScreenTiming = 4;
          bulletIterator.remove();
          if(mainStarship.setDamage( bullet.getDamage() )){
            state = ActionFieldState.GAMEOVER;
            audioController.playOnceExplosion();
            return Signal.CONTINUE;      
          }    
        }
      }
    }

    if(mainStarship.getHealth() <=0){
      state = ActionFieldState.GAMEOVER;
      audioController.playOnceExplosion();
      return Signal.CONTINUE;      
    }

    for(Bullet bullet : bullets){
      bullet.frameMove();
      bullet.display(cam.getX(), cam.getY(), cam.getZ(), 0, 0, 1);
    }

    displayAllEnemies();

    for(Starship ss: waveList){
        if(random(0, 100) < 1 * MULTIPLIER_FIRE_RATE_ENEMY){
          bullets.add(ss.shot());
        }
    }
    
    if(waveList.isEmpty()){
      enemies.remove(0);
      waveControllers.remove(0);
      if(!enemies.isEmpty()) waveList = enemies.get(0);
    }

    if(!enemies.isEmpty())
      if(waveList.get(0).getPosZ() < 0){
        audioController.playOnceExplosion();
        state = ActionFieldState.GAMEOVER;
        return Signal.CONTINUE;      
      }

    displayAll();

    if(redScreenTiming > 0){
      redScreenTiming--;
      //displayScreen(redScreen);
      uiInfo.displayScreen(color(255,0,0, 180), translation.get("damage"), color(0,0,0));
    }

    uiInfo.display(cam.getX(), cam.getY(), cam.getZ());

    if(enemies.isEmpty()){
        timer = new Timer(1000);
        
        timer.start();
        state = ActionFieldState.WAIT_FOR_SCREEN;
    }

    Signal sig = Signal.CONTINUE;
    if(ANDROID){
      uiController.check();   
      uiController.draw();
      if(uiController.isMenuCalling())
        sig = Signal.MENU;
    }
    return sig;    
  }
}