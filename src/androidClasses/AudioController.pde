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
  
  int number = 0;

  boolean started;
  
  private MediaPlayer mainTheme;

  private MediaPlayer music;

  private List<MediaPlayer> musics;

  private List<SoundFile> damageSounds;
  private List<SoundFile> shotSounds;
  
  private int counterShot = 0;
  private int counterDamage = 0;
  private int THREAD_NUMBER = 20;
  
  public void update(){
    if(music != null){
      if(isMusicOn) music.setVolume(1,1); else music.setVolume(0,0);
    }
    if(mainTheme != null){
      if(isMusicOn) mainTheme.setVolume(1,1); else mainTheme.setVolume(0,0);
    }
  }

  public AudioController(){
    isPlayable = true;
    musics = new ArrayList<>();

    mainTheme = getPlayer(MUSIC_MAIN_THEME);
    mainTheme.setLooping(true);

    musics.add(getPlayer(MUSIC_BACKGROUND_PATH3));
    musics.add(getPlayer(MUSIC_BACKGROUND_PATH1));
    musics.add(getPlayer(MUSIC_BACKGROUND_PATH2));

    
    shotSounds = new ArrayList<>();
    for(int i = 0; i < THREAD_NUMBER; i++){
      shotSounds.add(new SoundFile(SIA, SOUND_SHOT_PATH));
    }
    
    damageSounds = new ArrayList<>();
    for(int i = 0; i < THREAD_NUMBER; i++){
      damageSounds.add(new SoundFile(SIA, SOUND_DAMAGE_PATH));
    }
    mainTheme.start();
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
      mainTheme.pause();
      music.seekTo(0);
      music.pause();
    }catch(NullPointerException e){

    }
        
  }
  
  private MediaPlayer getRandomAudioPlayer(MediaPlayer mp){
    number = (number + 1) % musics.size();
    return musics.get(number);
  }

  public void continuePlayers(){
    try{      
      if(music == null)
        music = getRandomAudioPlayer(music);
      else if(!music.isPlaying()){
        music.pause();
        music.seekTo(0);
        music = getRandomAudioPlayer(music);
      }

      music.start();
      mainTheme.start();
    }catch(NullPointerException e){
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
  }

  public void playOnceShot(){
    if(isSoundOn){
      shotSounds.get(counterShot % THREAD_NUMBER).play();  
      counterShot++;
    }
  }
  
  public void playLoopSounds(){
    // === BROKEN ===
    // if(isPlayable)
    // if(!started){
    //   music.start();
    //   //startSound.start();
    //   started = true;
    // } else if(!isLooped){
    // //} else if(!startSound.isPlaying() && !isLooped){
    // //} else if(!isLooped){
    //   isLooped = true;
    //   //loopSound.start();
    // }
    // === END BROKEN ===

    try{      
      if(music == null)
        music = getRandomAudioPlayer(music);
      else if(!music.isPlaying()){
        music.pause();
        music.seekTo(0);
        music = getRandomAudioPlayer(music);
      }

      mainTheme.start();
      music.start();
    }catch(NullPointerException e){
    }
  }
  
  public void stopLoopSounds(boolean isStopMusic){
  }

  public void playTheme(){
      if(mainTheme != null)
        mainTheme.start();    
  }

  public void stopAll(){
    if(mainTheme != null){
      mainTheme.stop();
      mainTheme.release();
    }

    if(music != null){
      music.stop();
      music.release();
    }


    mainTheme = getPlayer(MUSIC_MAIN_THEME);
    mainTheme.setLooping(true);

    musics.add(getPlayer(MUSIC_BACKGROUND_PATH1));
    musics.add(getPlayer(MUSIC_BACKGROUND_PATH2));
    musics.add(getPlayer(MUSIC_BACKGROUND_PATH3));

    music = getRandomAudioPlayer(music);
  }
}
