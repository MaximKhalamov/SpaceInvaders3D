import android.media.AudioFormat;
import android.media.AudioManager;
import android.media.AudioTrack;
import java.io.IOException;
import java.io.InputStream;

AudioController globalController;
boolean isSoundOn;
boolean isMusicOn;

AudioController getAudioController(){
  if(globalController == null)
    globalController = new AudioController(context);
  globalController.update();
  return globalController;
}

class AudioController{
  boolean isLooped = false;
  boolean isPlayable;
  
  private volatile boolean isPlaying;

  int number = 0;

  boolean started;
  
  private AudioTrack mainTheme;

  private AudioTrack music;

  private AudioTrack[] musics;

  private List<SoundFile> damageSounds;
  private List<SoundFile> shotSounds;
  
  private int counterShot = 0;
  private int counterDamage = 0;
  private int THREAD_NUMBER = 20;
  
  private int SAMPLE_RATE = 44100;
  private int CHANNEL_CONFIG = AudioFormat.CHANNEL_OUT_STEREO;
  private int AUDIO_FORMAT = AudioFormat.ENCODING_PCM_16BIT;
  private AssetManager assetManager;
  private Context context;

  public void update(){
    // if(music != null){
    //   if(isMusicOn) music.setVolume(1,1); else music.setVolume(0,0);
    // }
    // if(mainTheme != null){
    //   if(isMusicOn) mainTheme.setVolume(1,1); else mainTheme.setVolume(0,0);
    // }
  }

  public AudioController(Context context){
    isPlayable = true;
    this.context = context;

    // mainTheme = createAudioTrack(MUSIC_MAIN_THEME);
    // mainTheme.setLoopPoints(0, mainTheme.getBufferSizeInFrames(), -1);
    // mainTheme.play();

    // musics = new AudioTrack[] {
    //     createAudioTrack(MUSIC_BACKGROUND_PATH1),
    //     createAudioTrack(MUSIC_BACKGROUND_PATH2),
    //     createAudioTrack(MUSIC_BACKGROUND_PATH3)
    // };
    
    shotSounds = new ArrayList<>();
    for(int i = 0; i < THREAD_NUMBER; i++){
      shotSounds.add(new SoundFile(SIA, SOUND_SHOT_PATH));
    }
    
    damageSounds = new ArrayList<>();
    for(int i = 0; i < THREAD_NUMBER; i++){
      damageSounds.add(new SoundFile(SIA, SOUND_DAMAGE_PATH));
    }
    // mainTheme.play();
    playAudioFile(MUSIC_MAIN_THEME);
  }

  private void playAudioFile(final String filePath) {
        // AudioTrack audioTrack = createAudioTrack(filePath);
        isPlaying = true;
        assetManager = context.getAssets();
        
        try {
            InputStream inputStream = assetManager.open(filePath);
            AudioTrack audioTrack;
        
        int bufferSize = AudioTrack.getMinBufferSize(44100,
                AudioFormat.CHANNEL_CONFIGURATION_MONO, AudioFormat.ENCODING_PCM_16BIT);

        audioTrack = new AudioTrack(AudioManager.STREAM_MUSIC, 44100,
                AudioFormat.CHANNEL_CONFIGURATION_MONO, AudioFormat.ENCODING_PCM_16BIT,
                bufferSize, AudioTrack.MODE_STREAM);

        new Thread(new Runnable() {
            @Override
            public void run() {
                byte[] buffer = new byte[bufferSize];
                int bytesRead;
                audioTrack.play();
                try {
                    while ( isPlaying && (bytesRead = inputStream.read(buffer, 0, bufferSize)) >= 0) {
                        audioTrack.write(buffer, 0, bytesRead);
                    }
                    if(isPlaying == false)
                      isPlaying = true;
                    audioTrack.stop();
                    audioTrack.release();
                    inputStream.close();
                    println("You can now play video");            
                  } catch (IOException e) {
                    e.printStackTrace();
                }

                
            }
        }).start();


        } catch (IOException e) {
            e.printStackTrace();
        }
    }

  public void stopPlayers(){
    // try{
    //   mainTheme.pause();
    //   music.seekTo(0);
    //   music.pause();
    // }catch(NullPointerException e){

    // }
        
  }
  
  // private MediaPlayer getRandomAudioPlayer(MediaPlayer mp){
  //   number = (number + 1) % musics.size();
  //   return musics.get(number);
  // }

  public void continuePlayers(){
    // try{      
    //   if(music == null)
    //     music = getRandomAudioPlayer(music);
    //   else if(!music.isPlaying()){
    //     music.pause();
    //     music.seekTo(0);
    //     music = getRandomAudioPlayer(music);
    //   }

    //   music.start();
    //   mainTheme.start();
    // }catch(NullPointerException e){
    // }
        
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
    // try{      
    //   if(music == null)
    //     music = getRandomAudioPlayer(music);
    //   else if(!music.isPlaying()){
    //     music.pause();
    //     music.seekTo(0);
    //     music = getRandomAudioPlayer(music);
    //   }

    //   mainTheme.start();
    //   music.start();
    // }catch(NullPointerException e){
    // }
  }
  
  public void stopLoopSounds(boolean isStopMusic){
  }

  public void playTheme(){
      // if(mainTheme != null)
      //   mainTheme.start();    
  }

  public void stopAll(){
    // if(mainTheme != null){
    //   mainTheme.stop();
    //   mainTheme.release();
    // }
    isPlaying = false;
    // if(music != null){
    //   music.stop();
    //   music.release();
    // }


    // mainTheme = getPlayer(MUSIC_MAIN_THEME);
    // mainTheme.setLooping(true);

    // musics.add(getPlayer(MUSIC_BACKGROUND_PATH1));
    // musics.add(getPlayer(MUSIC_BACKGROUND_PATH2));
    // musics.add(getPlayer(MUSIC_BACKGROUND_PATH3));

    // music = getRandomAudioPlayer(music);
  }
}
