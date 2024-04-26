import ddf.minim.*;
import processing.video.*;

class AppVideoPlayer{
    private Map<String, Movie> movies;
    private Map<String, AudioPlayer> sounds;
    private Minim minim;
    private SpaceInvaders papplet;
    private volatile String plaingVideoName;
    private volatile boolean isFirstFrame = false;

    public AppVideoPlayer(SpaceInvaders papplet){
        movies = new HashMap<>();  
        sounds = new HashMap<>();  
        this.papplet = papplet;
        minim = new Minim(papplet);
        if( abs(width / height - 16. / 9.) < abs(width / height - 2)){
          prepareVideoPlayer("video/16x9_01.mp4", "cutscene1");
          prepareVideoPlayer("video/16x9_02.mp4", "cutscene2");
        }else{
          prepareVideoPlayer("video/18x9_01.mp4", "cutscene1");
          prepareVideoPlayer("video/18x9_02.mp4", "cutscene2");
        }
        //prepareVideoPlayer("nekoarc.mp4", "nekoarc");
    }

    public void playVideo(String name) {
      plaingVideoName = name;
      isFirstFrame = true;
    }
    
    private void prepareVideoPlayer(String fileName, String name) {
      Movie mov = new Movie(papplet, fileName);
      println("data/" + fileName.substring(0, fileName.length() - 1) + "3");
      AudioPlayer ap = minim.loadFile("data/" + fileName.substring(0, fileName.length() - 1) + "3");
      movies.put(name, mov);
      sounds.put(name, ap);
    }
    
    public boolean isStoppedPlaying(){
      if(plaingVideoName != null){
        //println("playing");
        if(isFirstFrame){
          isFirstFrame = false;
          movies.get(plaingVideoName).play();
          sounds.get(plaingVideoName).play();
        }
        
        Movie m = movies.get(plaingVideoName);
          if (m.time() > m.duration() - 0.2) {
            println("OaoaaoOaoaaoOaoaaoOaoaaoOaoaao");
            stopPlaying();
            return true;
          }        
        pushMatrix();
        resetMatrix();

        translate(0, 0, -height);
        background(0);
        image(m, -width, -height, 2*width, 2*height);

        
        popMatrix();
        return false;
      }
      return true;
    }
    
    private void stopPlaying(){
      movies.get(plaingVideoName).stop();
      sounds.get(plaingVideoName).pause();
      sounds.get(plaingVideoName).rewind();
      plaingVideoName = null;
    }
}

void movieEvent(Movie m) {       
    m.read(); //<>//
}
