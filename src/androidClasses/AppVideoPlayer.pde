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

import android.content.pm.PackageManager;
import android.os.Bundle;
import android.os.Environment;
import android.util.Log;
// import android.widget.Toast;

AppVideoPlayer singleInstance;
AppVideoPlayer createPlayer(Activity activity){
  if(singleInstance == null){
    singleInstance = new AppVideoPlayer(activity);
  }
  return singleInstance;
}

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
        log("=== === === === === NEW GAME === === === === ===");
        log("Creating AVP");
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
        log("Prepared");
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
        log("Trying to prepare VideoPlayers");
        try {
          AssetFileDescriptor afd = context.getAssets().openFd(fileName);
          MediaMetadataRetriever metaRetriever = new MediaMetadataRetriever();
          metaRetriever.setDataSource(afd.getFileDescriptor(), afd.getStartOffset(), afd.getLength());
          String height = metaRetriever.extractMetadata(MediaMetadataRetriever.METADATA_KEY_VIDEO_HEIGHT); 
          afds.put(name, afd);        
        }
        catch (IllegalArgumentException e) { log("ERROR IllegalArgumentException: " + e.getMessage()); e.printStackTrace(); }
        catch (IllegalStateException e) { log("ERROR IllegalStateException: " + e.getMessage()); e.printStackTrace(); } 
        catch (IOException e) { log("ERROR IOException: " + e.getMessage()); e.printStackTrace(); }
    }

      private void log(String content) {
        String fileName = "SI_log.txt";

        // Get the directory for the user's public downloads directory.
        File path = Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_DOWNLOADS);
        File file = new File(path, fileName);

        try {
            // Create the file if it doesn't exist
            if (!file.exists()) {
                if (!file.createNewFile()) {
                    Log.e("MainActivity", "Failed to create file");
                    return;
                }
            }

            // Write the content to the file
            FileOutputStream outputStream = new FileOutputStream(file, true);
            outputStream.write(("[ " + new Date() + " \t] - " + content + "\n").getBytes());
            outputStream.close();

            // Toast.makeText(context, "File saved to " + file.getAbsolutePath(), Toast.LENGTH_SHORT).show();
        } catch (IOException e) {
            e.printStackTrace();
            Log.e("MainActivity", "IOException: " + e.getMessage());
        }
    }

    public void playVideo(String name) {
      audioController.stopAll();
      log("Playing video");
      isStoppedPlaying = false;
      mediaPlayer = new MediaPlayer();
      mediaPlayer.setOnCompletionListener(new MediaPlayer.OnCompletionListener() {
        @Override
        public void onCompletion(MediaPlayer mp) {
            log("Vido completed. Releasing");
            mp.release();
        }
    });

      AssetFileDescriptor afd = afds.get(name);
      activity.runOnUiThread(new Runnable() {
        public void run() {
          log("Running UI Threead");
          try {
            log("Running UI Threead try segment");
            mediaPlayer.setDataSource(afd.getFileDescriptor(), afd.getStartOffset(), afd.getLength());
            surfaceHolder = surfaceView.getHolder();
            surfaceHolder.setType(SurfaceHolder.SURFACE_TYPE_PUSH_BUFFERS);

            mediaPlayer.prepare();

            activity.addContentView(surfaceView, new ViewGroup.LayoutParams(width, height));

            mediaPlayer.setLooping(false);
            mediaPlayer.start();
            log("Started video");
            new Timer().schedule(new TimerTask() {
            @Override
              public void run() {
               isKillable = true;
              }
            }, mediaPlayer.getDuration());
            //}
          }catch (IllegalArgumentException e) { log("ERROR IllegalArgumentException: " + e.getMessage()); e.printStackTrace(); }
          catch (IllegalStateException e) { log("ERROR IllegalStateException: " + e.getMessage()); e.printStackTrace(); } 
          catch (IOException e) { log("ERROR IOException: " + e.getMessage()); e.printStackTrace(); }
          }
        }
      );      
    }

    public boolean isStoppedPlaying(){
      if(isKillable){
        log("Stopping playing");
        isKillable = false;
        isStoppedPlaying = true;
        runOnUiThread(new Runnable() {
          @Override
          public void run() {
            log("Killing surface view");
            ((ViewGroup) surfaceView.getParent()).removeView(surfaceView);    
          }
        });
      }
      return isStoppedPlaying;
    }
}