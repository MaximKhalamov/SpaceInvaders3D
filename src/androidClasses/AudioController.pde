AudioController globalController;
boolean isSoundOn;
boolean isMusicOn;

AudioController getAudioController(){
  if(globalController == null)
    globalController = new AudioController();
  globalController.update();
  return globalController;
}

class AudioController{
  boolean isLooped = false;
  boolean isPlayable;
  
  boolean started;
  
  //private MediaPlayer startSound;
  //private MediaPlayer loopSound;
  private MediaPlayer music;

  //private MediaPlayer explosionSound;
  //private MediaPlayer damageSound;
  
  private List<SoundFile> damageSounds;
  private List<SoundFile> shotSounds;
  
  private int counterShot = 0;
  private int counterDamage = 0;
  private int THREAD_NUMBER = 20;
  
  public void update(){
    if(isMusicOn){
      music.setVolume(1,1);
    } else {
      music.setVolume(0,0);
    }
    
    //if(isSoundOn){
    //  loopSound.setVolume(1,1);
    //  startSound.setVolume(1,1);
    //} else {
    //  loopSound.setVolume(0,0);
    //  startSound.setVolume(0,0);
    //}
  }

  public AudioController(){
    isPlayable = true;
    //startSound = getPlayer(SOUND_FLYING_START_PATH);    
    
    //loopSound = getPlayer(SOUND_FLYING_LOOP_PATH);
    //loopSound.setLooping(true);
    
    music = getPlayer(MUSIC_BACKGROUND_PATH);
    music.setLooping(true);

    //music MUSIC_BACKGROUND_PATH);

    //explosionSound = getPlayer(SOUND_EXPLOSION_PATH);
    //damageSounds = getPlayer(SOUND_DAMAGE_PATH);
    
    //explosionSound.play();
    //damageSound.play();
    
    shotSounds = new ArrayList<>();
    for(int i = 0; i < THREAD_NUMBER; i++){
      shotSounds.add(new SoundFile(SIA, SOUND_SHOT_PATH));
    }
    
    damageSounds = new ArrayList<>();
    for(int i = 0; i < THREAD_NUMBER; i++){
      damageSounds.add(new SoundFile(SIA, SOUND_DAMAGE_PATH));
    }
  }
  
  private File createTempFile(InputStream inputStream) throws IOException {
        File tempFile = File.createTempFile("temp_audio", ".mp3", context.getCacheDir());

        try (FileOutputStream outputStream = new FileOutputStream(tempFile)) {
            byte[] buffer = new byte[1024];
            int length;
            while ((length = inputStream.read(buffer)) > 0) {
                outputStream.write(buffer, 0, length);
            }
        } finally {
            inputStream.close();
        }

        return tempFile;
    }
  
  private MediaPlayer getPlayer(String fileName){
    File tempFile = new File("");
    try {
        tempFile = createTempFile(assetManager.open(fileName));
    } catch (IOException e) {
        e.printStackTrace();
    }

    MediaPlayer mediaPlayer = new MediaPlayer();
    try {
        mediaPlayer.setDataSource(tempFile.getPath());
        mediaPlayer.prepare();
     } catch (IOException e) {
        e.printStackTrace();
     }
    return mediaPlayer;
  }
  
  public void stopPlayers(){
    try{
      //startSound.pause();
      //if(isLooped)
        //loopSound.pause();
      music.pause();
      //explosionSound.pause();
      //damageSound.pause();

    }catch(NullPointerException e){
      println("ok and?");
    }
        
  }

  public void continuePlayers(){
    try{      
      //startSound.start();
      //loopSound.start();
      music.start();
    }catch(NullPointerException e){
      println("ok and?");
    }
        
  }
  
  public void playOnceExplosion(){
    if(isSoundOn){
      damageSounds.get(counterDamage % THREAD_NUMBER).play();  
      counterDamage++;    
    }
  }
  
  public void playOnceDamage(){
    if(isSoundOn){
      damageSounds.get(counterDamage % THREAD_NUMBER).play();  
      counterDamage++;
    }
  }

  public void playBattleSpeach(){
    if(isSoundOn){
      // TODO
    }
  }

  public void playOnceShot(){
    if(isSoundOn){
      shotSounds.get(counterShot % THREAD_NUMBER).play();  
      counterShot++;
    }
  }
  
  public void playLoopSounds(){
    if(isPlayable)
    if(!started){
      music.start();
      //startSound.start();
      started = true;
    } else if(!isLooped){
    //} else if(!startSound.isPlaying() && !isLooped){
    //} else if(!isLooped){
      isLooped = true;
      //loopSound.start();
    }
  }
  
  public void stopLoopSounds(boolean isStopMusic){
    //if(isLooped){
      //startSound.stop();    
      //if(isLooped)
      //  loopSound.stop();
      //isLooped = true;
      
    //}else{

    //}
    if(isStopMusic)
      music.stop();
  }
}
