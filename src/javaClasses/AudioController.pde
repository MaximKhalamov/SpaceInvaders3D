boolean isSoundOn;
boolean isMusicOn;

class AudioController{
  boolean isLooped = false;
  boolean isPlayable;
  
  boolean started;
  
  //private AudioPlayer startSound;
  //private AudioPlayer loopSound;
  private AudioPlayer music;
  private AudioSample explosionSound;
  private AudioSample damageSound;
  private AudioSample shotSound;
  
  public void update(){
    if(isMusicOn){
      music.unmute();
    } else {
      music.mute();
    }
    
    //if(isSoundOn){
    //  loopSound.unmute();
    //  startSound.unmute();
    //} else {
    //  loopSound.mute();
    //  startSound.mute();
    //}
  }

  public AudioController(Minim minim){
    //startSound = minim.loadFile(SOUND_FLYING_START_PATH);
    //loopSound = minim.loadFile(SOUND_FLYING_LOOP_PATH);
    music = minim.loadFile(MUSIC_BACKGROUND_PATH);
    explosionSound = minim.loadSample(SOUND_EXPLOSION_PATH);
    damageSound = minim.loadSample(SOUND_DAMAGE_PATH);
    shotSound = minim.loadSample(SOUND_SHOT_PATH);
  }
  
  public void stopPlayers(){
    //startSound.close();
    //loopSound.pause();
    music.pause();
    //explosionSound.close();
    //damageSound.close();
    //shotSound.close();       
  }

  public void continuePlayers(){
      //loopSound.loop();
      music.loop();
    //}     
  }
  
  public void playOnceExplosion(){
    if(isSoundOn){
      explosionSound.trigger();
    }
  }
  
  public void playOnceDamage(){
    if(isSoundOn){
      damageSound.trigger(); 
    }
  }
  
  public void playOnceShot(){
    if(isSoundOn){
      shotSound.trigger();
    }
  }

  public void playBattleSpeach(){
    if(isSoundOn){
      // TODO
    }
  }
  
  public void playLoopSounds(){
    if(!started){
      music.loop();
      //startSound.play();
      started = true;
    } 
    //else if(!startSound.isPlaying() && !isLooped){
    //  isLooped = true;
    //  //loopSound.loop();
    //}
  }
  
  public void stopLoopSounds(boolean isStopMusic){
    //loopSound.close();
    //startSound.close();
    if(isStopMusic)
      music.close();
  }
}
