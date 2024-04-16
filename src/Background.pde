private float KAPPA = 0.25;
//private float KAPPA = 0.3;
private float CAM_LENGTH = 48F;

class Background{
  private List<Planet> planets;
  
  private PShape skySphereModel;
  
  private float skyBoxSize = 80000f;

  private PShape starModel;

  private float paramT = 0;
  
  private float skySphereRotation;
  
  private float middlePointBezierX;
  private float middlePointBezierY;

  private float vec1x;
  private float vec1y;

  private float xCamCin;
  private float yCamCin;
  
    
  public Background(List<Planet> planets){
    this.planets = planets;
    
    skySphereModel = loadShape(SKYSPHERE_MODEL_PATH);
    skySphereModel.scale(skyBoxSize);
    
    starModel = loadShape(STAR_MODEL_PATH);
    starModel.setEmissive(color(255, 190, 0));

    starModel.scale(STAR_SIZE);
    
    setBezierPoints(planets.get(0), planets.get(1));
  }
  
  private float hermit(float x) { return 3 * x * x - 2 * x * x * x; }
  
  private float getQuarter(float p1, float p2){
    return (p2 - p1) / 6;
  }
  
  private void setBezierPoints(Planet planetFrom, Planet planetTo){
    float xFrom = planetFrom.getX();  
    float yFrom = planetFrom.getY();  
    float xTo = planetTo.getX();  
    float yTo = planetTo.getY();
    
    float l = 0.5;
    float distX = (1 - l) * xFrom + l * xTo;
    float distY = (1 - l) * yFrom + l * yTo;
    
    float hx =   (yFrom - yTo) * 1;
    float hy = - (xFrom - xTo) * 1;
    
    middlePointBezierX = hx + distX;
    middlePointBezierY = hy + distY;
  }
  
  private float getBezier2nd(float p1, float p2, float p3, float t){
    return (1 - t) * (1 - t) * p1 
           + 2 * t * (1 - t) * p2
                     + t * t * p3;
  }

  private float getBezier2ndDeriv(float p1, float p2, float p3, float t){
    return     - 2 * (1 - t) * p1
           + 2 * (1 - 2 * t) * p2 
                     + 2 * t * p3;
  }
  
  private float getRotation(float x, float y){
    return acos(x / sqrt(x * x + y * y)) * Math.signum(y);
  }
  
  private float getHeight(float paramT, float t0, float t1, Planet planetFrom, Planet planetTo){
    return map(paramT, t0, t1, (16 + planetFrom.getDeltaH()) * planetFrom.getMultiplierSize(), (16 + planetTo.getDeltaH()) * planetTo.getMultiplierSize());
  }
  
  private float getDistanceXY(Planet planetFrom, Planet planetTo){
    return sqrt(pow(planetFrom.getX() - planetTo.getX(), 2) + pow(planetFrom.getY() - planetTo.getX(), 2));
  }
  
  private float getPitchAngle(Planet planetFrom, Planet planetTo){
    float hFrom = getHeight(0, 0, 1, planetFrom, planetTo);
    float hTo   = getHeight(1, 0, 1, planetFrom, planetTo);
    
    return atan((hTo - hFrom) / getDistanceXY(planetFrom, planetTo));
  }
  
  private void move(Planet planetFrom, Planet planetTo){
    if(IS_CINEMATOGRAPHIC_CAMERA){
      if(paramT == 0.0f){
        float startPosX = planetFrom.getX() + getQuarter(planetFrom.getX(), planetTo.getX());
        float startPosY = planetFrom.getY() + getQuarter(planetFrom.getY(), planetTo.getY());

        vec1x = planetFrom.getX() - planetTo.getX();
        vec1y = planetFrom.getY() - planetTo.getY();
      
        xCamCin = startPosX - Math.signum(planetFrom.getX() * vec1y - planetFrom.getY() * vec1x) * getQuarter(planetFrom.getY(), planetTo.getY());
        yCamCin = startPosY + Math.signum(planetFrom.getX() * vec1y - planetFrom.getY() * vec1x) * getQuarter(planetFrom.getX(), planetTo.getX());
      }
      
      if(planetTo.getBossStatus()){
        pushMatrix();
        translate(  map(paramT, 0.2f, 0.7f, planetFrom.getX(), planetTo.getX()), 
                    map(paramT, 0.2f, 0.7f, planetFrom.getY(), planetTo.getY()), 
                    getHeight(paramT, 0.2f, 0.7f, planetFrom, planetTo));
        rotateX(PI/2);
        rotateY(getRotation( planetTo.getX() - planetFrom.getX(), planetTo.getY() - planetFrom.getY() ) );
        rotateZ(PI);
        rotateX(PI/2);
        scale(0.1);
        rotateY(getPitchAngle(planetFrom, planetTo));
        shape(BOSS_STARSHIP_MODEL);
        popMatrix();
        
        pushMatrix();
        translate(  map(paramT, 0.0f, 1.0f, 2*planetFrom.getX()-planetTo.getX(), planetTo.getX()),
                    map(paramT, 0.0f, 1.0f, 2*planetFrom.getY()-planetTo.getY(), planetTo.getY()),
                    getHeight(paramT, 0.5f, 1.0f, planetFrom, planetTo));
        rotateX(PI/2);      
        rotateY(PI + getRotation( planetTo.getX() - planetFrom.getX(), planetTo.getY() - planetFrom.getY() ) );
        scale(0.3);
        rotateZ(-getPitchAngle(planetFrom, planetTo));
        shape(PLAYER_STARSHIP_MODEL);
        popMatrix();

    } else {
        pushMatrix();
        translate(  map(paramT, 0f, 1f, planetFrom.getX(), planetTo.getX()), 
                    map(paramT, 0f, 1f, planetFrom.getY(), planetTo.getY()), 
                    getHeight(paramT, 0.0f, 1.0f, planetFrom, planetTo));
        rotateX(PI/2);      
        rotateY(PI + getRotation( planetTo.getX() - planetFrom.getX(), planetTo.getY() - planetFrom.getY() ) );
        scale(0.3);
        rotateZ(-getPitchAngle(planetFrom, planetTo));
        //rotateZ(PI/3);
        shape(PLAYER_STARSHIP_MODEL);
        popMatrix();      
      }
      
      if(paramT < 0.45 && planetTo.getBossStatus()){
        camera(xCamCin, yCamCin, getHeight(0, 0.0f, 1.0f, planetFrom, planetTo) - 8,
              planetFrom.getX(), planetFrom.getY(), getHeight(0, 0.0f, 1.0f, planetFrom, planetTo),
              0, 0, -1);
      } else if(paramT < 1.0 && planetTo.getBossStatus()){
        float starshipPoseX = map(paramT, 0.5f, 1f, planetFrom.getX(), planetTo.getX());
        float starshipPoseY = map(paramT, 0.5f, 1f, planetFrom.getY(), planetTo.getY());
        float starshipPoseZ = getHeight(paramT, 0.5f, 1.0f, planetFrom, planetTo);
        
        camera(  sigmoidMap(paramT, 0.45f, 1.00f, xCamCin, starshipPoseX + CAM_LENGTH * cos(getRotation(planetFrom.getX() - planetTo.getX(), planetFrom.getY() - planetTo.getY())) * KAPPA),
                 sigmoidMap(paramT, 0.45f, 1.00f, yCamCin, starshipPoseY + CAM_LENGTH * sin(getRotation(planetFrom.getX() - planetTo.getX(), planetFrom.getY() - planetTo.getY())) * KAPPA),
                 sigmoidMap(paramT, 0.45f, 1.00f, getHeight(0, 0.0f, 1.0f, planetFrom, planetTo) - 8, starshipPoseZ - CAM_INIT_Y * KAPPA),
    
                 constStraightMap(paramT, 0.45f, 0.55f, 1.00f, planetFrom.getX(), map(0.55f, 0.45f, 1.00f, planetFrom.getX(), planetTo.getX()), planetTo.getX() + (planetTo.getX() - planetFrom.getX()) * 0.01 ), 
                 constStraightMap(paramT, 0.45f, 0.55f, 1.00f, planetFrom.getY(), map(0.55f, 0.45f, 1.00f, planetFrom.getY(), planetTo.getY()), planetTo.getY() + (planetTo.getY() - planetFrom.getY()) * 0.01 ), 
                 starshipPoseZ - map(paramT, 0.45f, 1.00f, 0f, CAM_INIT_Y * KAPPA),
                 
                 0, 0, -1);

    } else if(planetTo.getBossStatus()){
        camera(  map(paramT, 0.0f, 1.0f, 2*planetFrom.getX()-planetTo.getX(), planetTo.getX()) + CAM_LENGTH * cos(getRotation(planetFrom.getX() - planetTo.getX(), planetFrom.getY() - planetTo.getY())) * KAPPA,
                 map(paramT, 0.0f, 1.0f, 2*planetFrom.getY()-planetTo.getY(), planetTo.getY()) + CAM_LENGTH * sin(getRotation(planetFrom.getX() - planetTo.getX(), planetFrom.getY() - planetTo.getY())) * KAPPA, 
                 getHeight(paramT, 0.0f, 1.0f, planetFrom, planetTo) - CAM_INIT_Y * KAPPA,
                 
                 map(paramT, 0.0f, 1.0f, 2*planetFrom.getX()-planetTo.getX(), planetTo.getX()) + CAM_LENGTH * cos(getRotation(planetFrom.getX() - planetTo.getX(), planetFrom.getY() - planetTo.getY())) * KAPPA + (planetTo.getX() - planetFrom.getX()) * 0.01,
                 map(paramT, 0.0f, 1.0f, 2*planetFrom.getY()-planetTo.getY(), planetTo.getY()) + CAM_LENGTH * sin(getRotation(planetFrom.getX() - planetTo.getX(), planetFrom.getY() - planetTo.getY())) * KAPPA + (planetTo.getY() - planetFrom.getY()) * 0.01, 
                 getHeight(paramT, 0.0f, 1.0f, planetFrom, planetTo) - CAM_INIT_Y * KAPPA,
                 
                 0, 0, -1);   
      }else{
        camera(xCamCin, yCamCin, 8,
              map(paramT, 0f, 1f, planetFrom.getX(), planetTo.getX()), 
              map(paramT, 0f, 1f, planetFrom.getY(), planetTo.getY()), 
              getHeight(paramT, 0.0f, 1.0f, planetFrom, planetTo),
              0, 0, -1);      
      }


    }
    
    //else {
    //  float xCam = getBezier2nd(planetFrom.getX(), middlePointBezierX, planetTo.getX(), hermit(paramT));
    //  float yCam = getBezier2nd(planetFrom.getY(), middlePointBezierY, planetTo.getY(), hermit(paramT));
      
    //  float xCamDeriv = getBezier2ndDeriv(planetFrom.getX(), middlePointBezierX, planetTo.getX(), hermit(paramT));
    //  float yCamDeriv = getBezier2ndDeriv(planetFrom.getY(), middlePointBezierY, planetTo.getY(), hermit(paramT));
      
    //  pushMatrix();
    //  translate(xCam, yCam, PLANET_SIZE + 1);
    //  rotateX(PI/2);
    //  rotateY(3*PI /2 + atan(yCamDeriv / xCamDeriv));
    //  translate(0, 0, 1000);
    //  popMatrix();

    //  camera( xCam, yCam, PLANET_SIZE + 1,
    //          xCam + xCamDeriv, yCam + yCamDeriv, PLANET_SIZE + 1,
    //           0, 0, -1);
    //}
    if(planets.indexOf(planetTo) == 1 || planets.indexOf(planetTo) == 2){
      paramT += 0.010 / 3.0;    
    }else{
      paramT += 0.005;
    }
}
  
  public Signal drawBG(int planetMoveTo){
    if(paramT == 0.0f){
      skySphereRotation = random(-PI, PI);
      shaderController.randomize();
    }
    noLights();
    pushMatrix();
    rotateY(skySphereRotation);
    shaderController.useHueShader();
    shape(skySphereModel);
    shaderController.resetShaders();
    popMatrix();

    lights();
    pointLight(255,255,255,0,0,0);
    
    pushMatrix();
    rotateX(-PI/2);
    noStroke();
    fill(255,255,255, 255);
    hint(DISABLE_DEPTH_TEST);
    shape(starModel);
    hint(ENABLE_DEPTH_TEST);
    popMatrix();

    for(Planet planet: planets){
      planet.drawPlanet();
    }

    move( planets.get( planetMoveTo - 1 ), planets.get( planetMoveTo ) );

    if(planets.get( planetMoveTo ).getBossStatus() == true){
      if(paramT >= 1.0f){
        paramT = 0.0f;
        return Signal.SWITCH;
      }
    } else {
      if(paramT >= 1.0f){
        paramT = 0.0f;
        return Signal.SWITCH;
      }        
    }
    return Signal.CONTINUE;
  }
  
  private float constStraightMap(float t, float t1, float t2, float t3, float x1, float x2, float x3){
    if(t > t2)
      return map(t, t2, t3, x2, x3);
    else{
      float[][] matrix = {  {pow(t1, 3),  t1*t1,  t1,  1},
                            {pow(t2, 3),  t2*t2,  t2,  1}, 
                            {3*t1*t1,     2*t1,   1,   0}, 
                            {3*t2*t2,     2*t2,   1,   0}};    
    
    float[] sol = {x1, x2, 0, (x3 - x2) / (t3 - t2)};

    float[] a = solveGauss(matrix, sol);
    
    return a[0] * pow(t, 3) + a[1] * t * t + a[2] * t + a[3];
    }
  }

    private float sigmoidMap(float t, float t1, float t2, float x1, float x2){
      float t0 = hermit(map(t, t1, t2, 0.0f, 1.0f));
      return map(t0, 0.0f, 1.0f, x1, x2);
    }
  
    private float[] solveGauss(float[][] A, float[] b) {
        int n = b.length;

        for (int i = 0; i < n - 1; i++) {
            for (int j = i + 1; j < n; j++) {
                float factor = A[j][i] / A[i][i];
                for (int k = i; k < n; k++) {
                    A[j][k] -= factor * A[i][k];
                }
                b[j] -= factor * b[i];
            }
        }

        float[] x = new float[n];
        for (int i = n - 1; i >= 0; i--) {
            float sum = 0.0;
            for (int j = i + 1; j < n; j++) {
                sum += A[i][j] * x[j];
            }
            x[i] = (b[i] - sum) / A[i][i];
        }

        return x;
    }
}
