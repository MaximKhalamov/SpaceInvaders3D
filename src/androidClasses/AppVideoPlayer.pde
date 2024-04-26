import android.media.MediaPlayer;
import android.media.AudioManager;
import android.content.res.AssetFileDescriptor;
import android.content.res.AssetManager;
import android.app.Activity;
import android.view.SurfaceHolder;
import android.view.SurfaceView;
import android.content.Context;
import android.media.MediaMetadataRetriever;
import android.content.Context;
import android.view.ViewGroup;
import android.content.Intent;

class VideoPlayer{
    public String name;
    public AssetFileDescriptor afd;
}

class AppVideoPlayer{
    private boolean videoPlaying = false;
    private volatile boolean isKillable = false;
    private volatile boolean isStoppedPlaying = true;

    private Activity activity;
    private Context context;
    private SurfaceView surfaceView;
    private SurfaceHolder surfaceHolder;
    private MediaPlayer mediaPlayer;
    private Map<String, AssetFileDescriptor> afds;
    private volatile boolean isPlaying = true;


    public AppVideoPlayer(Activity activity){
        this.activity = activity;
        context = activity.getApplicationContext();
        afds = new HashMap<>();
        
        if( abs(width / height - 16. / 9.) < abs(width / height - 2)){
          prepareVideoPlayer("video/16x9_01.mp4", "cutscene1");
          prepareVideoPlayer("video/16x9_02.mp4", "cutscene2");
        }else{
          prepareVideoPlayer("video/18x9_01.mp4", "cutscene1");
          prepareVideoPlayer("video/18x9_02.mp4", "cutscene2");
        }
        
        surfaceView = new SurfaceView(activity);
        surfaceView.setZOrderOnTop(true) ;
        surfaceHolder = surfaceView.getHolder();
        surfaceHolder.setType(SurfaceHolder.SURFACE_TYPE_PUSH_BUFFERS);
        surfaceHolder.addCallback(new SurfaceHolder.Callback() {
          public void surfaceCreated(SurfaceHolder surfaceHolder) {
            mediaPlayer.setDisplay(surfaceHolder);
          }
      
          public void surfaceChanged(SurfaceHolder surfaceHolder, int i, int i2, int i3) {
            mediaPlayer.setDisplay(surfaceHolder);
          }
      
          public void surfaceDestroyed(SurfaceHolder surfaceHolder) {}
        });
    }

    private void prepareVideoPlayer(String fileName, String name) {
        try {
          AssetFileDescriptor afd = context.getAssets().openFd(fileName);
          MediaMetadataRetriever metaRetriever = new MediaMetadataRetriever();
          metaRetriever.setDataSource(afd.getFileDescriptor(), afd.getStartOffset(), afd.getLength());
          String height = metaRetriever.extractMetadata(MediaMetadataRetriever.METADATA_KEY_VIDEO_HEIGHT); 
          // metaRetriever.close();
          if (int(height) < 2) {
            throw new IOException();
          }
          afds.put(name, afd);        
        }
        catch (IllegalArgumentException e) { e.printStackTrace(); }
        catch (IllegalStateException e) { e.printStackTrace(); } 
        catch (IOException e) { e.printStackTrace(); }
    }

    public void playVideo(String name) {
      isPlaying = true;
      isStoppedPlaying = false;
      videoPlaying = true;
      activity.runOnUiThread(new Runnable() {
          public void run() {
            try {
              mediaPlayer = new MediaPlayer();
              AssetFileDescriptor afd = afds.get(name);
              mediaPlayer.setDataSource(afd.getFileDescriptor(), afd.getStartOffset(), afd.getLength());
              surfaceHolder = surfaceView.getHolder();
              surfaceHolder.setType(SurfaceHolder.SURFACE_TYPE_PUSH_BUFFERS);
              mediaPlayer.setOnPreparedListener(new MediaPlayer.OnPreparedListener() {
              @Override
              public void onPrepared(MediaPlayer mp) {
                  // MediaPlayer is prepared, you can start playback or perform other operations
                Thread timer = new Thread(new Runnable(){
                  private boolean isRewinded = false;

                  @Override    
                  public void run(){
                    try{
                      Thread.sleep(1);
                      while(true){
                        try{
                          // if(isPlaying)
                          //   continue;
                          if(!isRewinded){
                            mediaPlayer.seekTo(0);
                            isRewinded = true;
                          }
                          if (videoPlaying && mediaPlayer.getCurrentPosition() >= mediaPlayer.getDuration()){
                            isKillable = true;
                            break;
                          }
                        } catch(IllegalStateException e){
                        } catch(NullPointerException e){
                      }
                    }
                    }catch(InterruptedException e){
                      e.printStackTrace();
                    }
                  }
                });
                timer.start();
              }
      });
      mediaPlayer.prepare();
      activity.addContentView(surfaceView, new ViewGroup.LayoutParams(width, height));
      if (mediaPlayer.isPlaying() == false) {
        isPlaying = false;
        mediaPlayer.start();
      }
      }
    catch (IllegalArgumentException e) { e.printStackTrace(); }
    catch (IllegalStateException e) { e.printStackTrace(); } 
    catch (IOException e) { e.printStackTrace(); }
    }
    });


  }

    public boolean isStoppedPlaying(){
      if(isKillable){
        isKillable = false;
        mediaPlayer.stop();
        mediaPlayer.release();
        //print("KILL!");
        isStoppedPlaying = true;
        runOnUiThread(new Runnable() {
          @Override
          public void run() {
            ((ViewGroup) surfaceView.getParent()).removeView(surfaceView);
            prepareVideoPlayer("video/16x9_01.mp4", "cutscene1");
            prepareVideoPlayer("video/16x9_02.mp4", "cutscene2");
          }
        });
      }
      return isStoppedPlaying;
    }
}