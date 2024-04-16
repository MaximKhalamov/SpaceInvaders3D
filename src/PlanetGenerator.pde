class PlanetGenerator{
    private Random random = new Random();
    
    private float minMult = 0.15;
    private float midMult = 1.0;
    private float maxMult = 4.5;

    private int planetNumber = 0;

    private float minDH = -25f;
    private float maxDH =  25f;

    public PlanetGenerator(){}

    public Planet getNext(){
        int enemyNumber = (int)(MULTIPLIER_ENEMIES * sqrt(1 + planetNumber) * 10);
        float deltaH = minDH + (maxDH - minDH) * random.nextFloat();
        
        float multiplierSize;
        if(planetNumber < 3){
            multiplierSize = minMult + (midMult - minMult) * random.nextFloat();
        } else {
            multiplierSize = midMult + (maxMult - midMult) * random.nextFloat();      
        }

        Planet planet = new Planet(enemyNumber, planetNumber % NUMBER_OF_PLANETS == NUMBER_OF_PLANETS - 1, PLANET_SIZE, multiplierSize, deltaH);
        planetNumber++;
        return planet;
    }
}