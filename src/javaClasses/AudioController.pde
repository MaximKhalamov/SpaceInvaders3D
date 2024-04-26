boolean isSoundOn;
boolean isMusicOn;

class AudioController{
  boolean isLooped = false;
  boolean isPlayable;
  
  int number = 0;

  boolean started;
  
  //private AudioPlayer startSound;
  //private AudioPlayer loopSound;
  private AudioPlayer mainTheme;

  private AudioPlayer music;

  private List<AudioPlayer> musics;


  private AudioSample explosionSound;
  private AudioSample damageSound;
  private AudioSample shotSound;
  
  public void update(){
    if(isMusicOn){
      mainTheme.unmute();

      for(AudioPlayer ap : musics){
        ap.unmute();
      }
    } else {
      mainTheme.mute();
      for(AudioPlayer ap : musics){
        ap.mute();
      }
    }
  }

  public AudioController(Minim minim){
    musics = new ArrayList<>();

    mainTheme = minim.loadFile(MUSIC_MAIN_THEME);

    musics.add(minim.loadFile(MUSIC_BACKGROUND_PATH1));
    musics.add(minim.loadFile(MUSIC_BACKGROUND_PATH2));
    musics.add(minim.loadFile(MUSIC_BACKGROUND_PATH3));

    explosionSound = minim.loadSample(SOUND_EXPLOSION_PATH);
    damageSound = minim.loadSample(SOUND_DAMAGE_PATH);
    shotSound = minim.loadSample(SOUND_SHOT_PATH);

    mainTheme.loop();
  
  }
  
  public void stopPlayers(){
    if(music != null){
      music.rewind();
      music.pause();
    }
    // mainTheme.play();
  }

  public void continuePlayers(){
      //loopSound.loop();
      if(music == null)
        music = getRandomAudioPlayer(music);
      else if(!music.isPlaying()){
        music.rewind();
        music.pause();
        music = getRandomAudioPlayer(music);
      }
      music.play();
      // mainTheme.pause();
    //}     
  }
  
  private AudioPlayer getRandomAudioPlayer(AudioPlayer ap){
    number = (number + 1) % musics.size();
    return musics.get(number);
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
      if(music == null)
        music = getRandomAudioPlayer(music);
      else if(!music.isPlaying()){
        music.rewind();
        music.pause();
        music = getRandomAudioPlayer(music);
      }
      music.play();
      // mainTheme.pause();
  }
  
  public void stopLoopSounds(boolean isStopMusic){
    if(isStopMusic)
      music.close();
  }
}
