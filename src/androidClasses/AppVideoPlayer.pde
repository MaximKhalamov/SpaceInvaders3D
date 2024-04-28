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
import android.os.Looper;
import java.util.TimerTask;
import java.util.Timer;

class VideoPlayer{
    public String name;
    public AssetFileDescriptor afd;
}

class AppVideoPlayer{
    private volatile boolean isStoppedPlaying = true;
    private volatile boolean isKillable = false;

    private Activity activity;
    private Context context;
    private MediaPlayer mediaPlayer;
    private Map<String, AssetFileDescriptor> afds;
    private SurfaceView surfaceView;
    private SurfaceHolder surfaceHolder;

    public AppVideoPlayer(Activity activity){

        this.activity = activity;
        context = activity.getApplicationContext();
        afds = new HashMap<>();
        Looper.prepare();
        mediaPlayer = new MediaPlayer();

        if( width / height < 17. / 9.){
          prepareVideoPlayer("video/16x9_01.mp4", "cutscene1");
          prepareVideoPlayer("video/16x9_02.mp4", "cutscene2");
          prepareVideoPlayer("video/16x9_03.mp4", "cutscene3");
        }else{
          prepareVideoPlayer("video/18x9_01.mp4", "cutscene1");
          prepareVideoPlayer("video/18x9_02.mp4", "cutscene2");
          prepareVideoPlayer("video/18x9_03.mp4", "cutscene3");
        }
      
        surfaceView = new SurfaceView(activity);
        surfaceView.setZOrderOnTop(true);
        surfaceHolder = surfaceView.getHolder();
        surfaceHolder.setType(SurfaceHolder.SURFACE_TYPE_PUSH_BUFFERS);
        surfaceHolder.addCallback(new SurfaceHolder.Callback() {
          public void surfaceCreated(SurfaceHolder surfaceHolder) {
            mediaPlayer.setDisplay(surfaceHolder);
          }
          public void surfaceChanged(SurfaceHolder surfaceHolder, int i, int i2, int i3) {
            mediaPlayer.setDisplay(surfaceHolder);
          }
          public void surfaceDestroyed(SurfaceHolder surfaceHolder) {
          }
        }
  );
    }

    private void prepareVideoPlayer(String fileName, String name) {
        try {
          AssetFileDescriptor afd = context.getAssets().openFd(fileName);
          MediaMetadataRetriever metaRetriever = new MediaMetadataRetriever();
          metaRetriever.setDataSource(afd.getFileDescriptor(), afd.getStartOffset(), afd.getLength());
          String height = metaRetriever.extractMetadata(MediaMetadataRetriever.METADATA_KEY_VIDEO_HEIGHT); 
          //metaRetriever.close();
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
      isStoppedPlaying = false;
      mediaPlayer = new MediaPlayer();
      AssetFileDescriptor afd = afds.get(name);
      activity.runOnUiThread(new Runnable() {
        public void run() {
          try {
            mediaPlayer.setDataSource(afd.getFileDescriptor(), afd.getStartOffset(), afd.getLength());
            surfaceHolder = surfaceView.getHolder();
            surfaceHolder.setType(SurfaceHolder.SURFACE_TYPE_PUSH_BUFFERS);
            mediaPlayer.prepare();
            activity.addContentView(surfaceView, new ViewGroup.LayoutParams(width, height));
            // if (mediaPlayer.isPlaying() == false) {
            mediaPlayer.start();
            new Timer().schedule(new TimerTask() {
            @Override
              public void run() {
               isKillable = true;
              }
            }, mediaPlayer.getDuration());
            //}
          }catch (IllegalArgumentException e) { e.printStackTrace(); }
          catch (IllegalStateException e) { e.printStackTrace(); } 
          catch (IOException e) { e.printStackTrace(); }
          }
        }
      );      
    }

    public boolean isStoppedPlaying(){
      if(isKillable){
        isKillable = false;
        print("KILL!");
        isStoppedPlaying = true;
        runOnUiThread(new Runnable() {
          @Override
          public void run() {
            ((ViewGroup) surfaceView.getParent()).removeView(surfaceView);    
          }
        });
      }
      return isStoppedPlaying;
    }
}