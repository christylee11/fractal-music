import java.util.Collection;
import javax.sound.midi.*;

// midi processor object
midiProcessor midiProc;
// 8 koch snowflakes (for 8 ranges of notes)
KochSnowflake k0;
KochSnowflake k1;
KochSnowflake k2;
KochSnowflake k3;
KochSnowflake k4;
KochSnowflake k5;
KochSnowflake k6;
KochSnowflake k7;
// background koch snowflake (will infinitely zoom into itself) 
KochSnowflake backgroundK;

void setup() {  
  fullScreen();
  background(0); // black background 
  
  // initialize variables 
  midiProc = new midiProcessor();
  k0 = new KochSnowflake(2.45, false);
  k1 = new KochSnowflake(1.75, false);
  k2 = new KochSnowflake(1.25, false);
  k3 = new KochSnowflake(0.85, false);
  k4 = new KochSnowflake(0.55, false);
  k5 = new KochSnowflake(0.35, false);
  k6 = new KochSnowflake(0.2, false);
  k7 = new KochSnowflake(0.1, false);
  backgroundK = new KochSnowflake(1.5, true);
  
  // load and start midi processor 
  midiProc.load(dataPath("../music/aladdin.mid"));
  midiProc.start();
}

void draw() {
  // render each fractal 
  clear();
  k0.render();
  k1.render();
  k2.render();
  k3.render();
  k4.render();
  k5.render();
  k6.render();
  k7.render();
  backgroundK.render();
  
  // slowly rotate in opposite directions every other fractal
  k0.rotatePosition(PI/500);
  k1.rotatePosition(-PI/500);
  k2.rotatePosition(PI/500);
  k3.rotatePosition(-PI/500);
  k4.rotatePosition(PI/500);
  k5.rotatePosition(-PI/500);
  k6.rotatePosition(PI/500);
  k7.rotatePosition(-PI/500);
  
  // continuous zoom for background fractal
  backgroundK.backgroundZoom();
};
