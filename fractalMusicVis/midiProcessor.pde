// Tutorial from: https://github.com/hamoid/Fun-Programming/tree/master/processing/ideas/2017/04/MidiViz
import java.util.concurrent.ConcurrentHashMap;

class midiProcessor implements Receiver {
  Sequencer sequencer;
  long time;

  // loads midi sequencer given path 
  public void load(String path) {
    File midiFile = new File(path);
    try {
      sequencer = MidiSystem.getSequencer();
      if (sequencer == null) {
        println("No midi sequencer");
        exit();
      } else {
        sequencer.open();
        Transmitter transmitter = sequencer.getTransmitter();
        transmitter.setReceiver(this);
        Sequence seq = MidiSystem.getSequence(midiFile);
        sequencer.setSequence(seq);
        time = millis();
      }
    } 
    catch(Exception e) {
      e.printStackTrace();
      exit();
    }
  }
  
  // start sequencer
  public void start() {
    sequencer.start();
  }
  
  // called each time a note is received
  // t is timestamp 
  @Override public void send(MidiMessage message, long t) {
    if (message instanceof ShortMessage) {
      ShortMessage sm = (ShortMessage) message;
      int cmd = sm.getCommand();
      // handle note onsets 
      if (cmd == ShortMessage.NOTE_ON) {   
        int note = sm.getData1();
        int velocity = sm.getData2();
        if (velocity > 0) {
          // handle fractal change based on new note
          float ratio = velocity / 127.0;
          //long curr_time = millis();
          //if (curr_time != time) {
            //time = curr_time;
          k0.updateSize(ratio);
          k1.updateSize(ratio);
          k2.updateSize(ratio);
          k3.updateSize(ratio);
          k4.updateSize(ratio);
          k5.updateSize(ratio);
          k6.updateSize(ratio);
          k7.updateSize(ratio);
          //}
          
          // handle color changes
          // pass in which note it is and the opacity to use 
          if (note < 33) {
            k0.changeColor((note - 21) % 12, 150);
          }
          else if (note < 45) {
            k1.changeColor((note - 21) % 12, 165);
          }
          else if (note < 57) {
            k2.changeColor((note - 21) % 12, 180);
          }
          else if (note < 69) {
            k3.changeColor((note - 21) % 12, 195);
          }
          else if (note < 81) {
            k4.changeColor((note - 21) % 12, 210);
          }
          else if (note < 93) {
            k5.changeColor((note - 21) % 12, 225);
          }
          else if (note < 105) {
            k6.changeColor((note - 21) % 12, 240);
          }
          else {
            k7.changeColor((note - 21) % 12, 255);
          }
        } 
      }
      // revert to original size with note off messages 
      else if (cmd == ShortMessage.NOTE_OFF) {
        k0.revertSize();
        k1.revertSize();
        k2.revertSize();
        k3.revertSize();
        k4.revertSize();
        k5.revertSize();
        k6.revertSize();
        k7.revertSize();
      }
    }
  }

  @Override public void close() {
  }
}
