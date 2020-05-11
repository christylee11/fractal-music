class KochSnowflake {
  // points of original triangle 
  PVector point1; // bottom left
  PVector point2; // bottom right
  PVector point3; // top 
  
  ArrayList<KochLine> lines; // current 
  ArrayList<KochLine> origLines; // original 
  
  int count; // number of times it has recursed 
  float ratio; //fractal height = ratio * screen height 
  float maxZoom; // max percent of screen height that a fractal vary from its given size
  
  boolean background; // true if it is the background fractal
  int backgroundCount; // amount of times we have zoomed into the background fractal 

  // constructor creates snowflake with 5 levels recursion
  KochSnowflake(float ratio, boolean background) {
    backgroundCount = 0;
    this.background = background;
    this.maxZoom = 0.1; 
    this.ratio = ratio;
    
    float length = sqrt((pow(0.75, 2) + pow(0.75 / 2, 2)) * pow(height, 2)); // of a triangle edge
    float xOffset = (width - length) / 2.0; 
   
    point1 = new PVector((xOffset - width / 2) * ratio + width / 2, (0.25 *  height * ratio) + height / 2); // bottom left
    point2 = new PVector((width / 2 - xOffset) * ratio + width / 2, (0.25 *  height * ratio) + height / 2); // bottom right
    point3 = new PVector(width/2 , (-0.5 * height * ratio) + height / 2); // top
    
    lines = new ArrayList<KochLine>();
    origLines = new ArrayList<KochLine>();
    
    restart();
    color col;
    if (background) { // background fractal
      col = color(75); // grey
      for (int i = 0; i < 6; i++) this.nextLevel(); // for now recurse to 6 levels to start
      shiftToBottom();
    }
    else { // all other fractals
      col = color(255); // white
      for (int i = 0; i < 5; i++) this.nextLevel(); // for now recurse to 6 levels to start
      shiftToCorner();
    }
    for (KochLine l : lines) origLines.add(new KochLine(l.a, l.b, col)); // save a copy of the original lines
    
    // calculations for centering the fractal:
    //float length = sqrt((pow(ratio * 0.75, 2) + pow(ratio * 0.75 / 2, 2)) * pow(height, 2)); // of a triangle edge
    //point1 = new PVector(xOffset, 0.75 * ratio * height); // bottom left
    //point2 = new PVector(width - xOffset, 0.75 * ratio * height); // bottom right
    //point3 = new PVector(width/2 , 0.025 * height); // top
  }
  
  // shift to top left corner
  void shiftToCorner() {
    ArrayList<KochLine> newLines = new ArrayList<KochLine>();
    for (int i = 0; i < lines.size(); i++) {
      KochLine m = lines.get(i);
      color col = lines.get(i).c;
      PVector p1 = new PVector(m.a.x - width / 5, m.a.y - height/2);
      PVector p2 = new PVector(m.b.x - width / 5, m.b.y - height/2);
      newLines.add(new KochLine(p1, p2, col));
    }
    lines = newLines;
  }
  
  // shift to bottom half of screen 
  void shiftToBottom() {
    ArrayList<KochLine> newLines = new ArrayList<KochLine>();
    for (int i = 0; i < lines.size(); i++) {
      KochLine m = lines.get(i);
      color col = lines.get(i).c;
      PVector p1 = new PVector(m.a.x, m.a.y + height/2);
      PVector p2 = new PVector(m.b.x, m.b.y + height/2);
      newLines.add(new KochLine(p1, p2, col));
    }
    lines = newLines;
  }
  
  // map given note to a color, use the given alpha value to change color
  void changeColor(int note, int alpha) {
    // traditional color wheel
    //int[] colorsR = {125, 0, 0, 0, 0, 0, 125, 255, 255, 255, 255, 252};
    //int[] colorsG = {0, 0, 125, 255, 255, 255, 255, 255, 125, 0, 0, 184};
    //int[] colorsB = {255, 255, 255, 255, 125, 0, 0, 0, 0, 0, 125, 252};
    // a much prettier color wheel
    int[] colorsR = {221, 246, 255, 210, 161, 162, 174, 26, 0, 204, 250, 236};
    int[] colorsG = {50, 139, 239, 239, 206, 208, 209, 134, 101, 193, 198, 0};
    int[] colorsB = {50, 105, 108, 219, 94, 207, 233, 168, 169, 219, 204, 104};
    
    for (KochLine l : lines) {
      l.c = color(colorsR[note], colorsG[note], colorsB[note], alpha);
    }
  }
  
  // change the size of the fractal shape 
  void updateSize(float s) {
    ArrayList<KochLine> newLines = new ArrayList<KochLine>();
    for (int i = 0; i < lines.size(); i++) {
      KochLine m = lines.get(i);
      color col = lines.get(i).c;
      float change = 1 - maxZoom * s;
      PVector p1 = new PVector((m.a.x - 0.3 * width) * change + 0.3 * width, m.a.y * change);
      PVector p2 = new PVector((m.b.x - 0.3 * width) * change + 0.3 * width, m.b.y * change);
      newLines.add(new KochLine(p1, p2, col));
    }
    lines = newLines;
  }
  
  // change the size of the fractal shape 
  void revertSize() {
    ArrayList<KochLine> newLines = new ArrayList<KochLine>();
    for (int i = 0; i < lines.size(); i++) {
      KochLine l = lines.get(i);
      KochLine m = origLines.get(i);
      float change = dist(m.a.x, m.a.y, m.b.x, m.b.y) / dist(l.a.x, l.a.y, l.b.x, l.b.y);
      PVector p1 = new PVector((l.a.x - 0.3 * width) * change + 0.3 * width, l.a.y * change);
      PVector p2 = new PVector((l.b.x - 0.3 * width) * change + 0.3 * width, l.b.y * change);
      newLines.add(new KochLine(p1, p2, l.c));
    }
    lines = newLines;
  }
  
  // zoom into background fractal
  void backgroundZoom() {
    if (backgroundCount > 105) {
      lines = origLines;
      backgroundCount = 1;
    }
    else {
      ArrayList<KochLine> newLines = new ArrayList<KochLine>();
      for (int i = 0; i < lines.size(); i++) {
        KochLine l = lines.get(i);
        float change = 1.01;
        PVector p1 = new PVector((l.a.x - 0.5 * width) * change + 0.5 * width, (l.a.y - height) * change + height * 1.0075);
        PVector p2 = new PVector((l.b.x - 0.5 * width) * change + 0.5 * width, (l.b.y - height) * change + height * 1.0075);
        newLines.add(new KochLine(p1, p2, l.c));
      }
      lines = newLines;
      backgroundCount++;
    }
  }
  
  // change the position of where in the fractal shape you're looking
  void updatePosition(float x, float y) {
    ArrayList<KochLine> newLines = new ArrayList<KochLine>();
    for (int i = 0; i < lines.size(); i++) {
      KochLine m = lines.get(i);
      color col = lines.get(i).c;
      PVector p1 = new PVector(m.a.x - x, m.a.y - y);
      PVector p2 = new PVector(m.b.x - x, m.b.y - y);
      newLines.add(new KochLine(p1, p2, col));
    }
    lines = newLines;
  }
  
  // rotate fractal theta degrees
  void rotatePosition(float theta) {
    ArrayList<KochLine> newLines = new ArrayList<KochLine>();
    for (int i = 0; i < lines.size(); i++) {
      KochLine m = lines.get(i);
      // 0.3*width because in shiftToCorner() that's how much we shift the x (shift center to corner, rotate and shift back)
      PVector p1 = new PVector((m.a.x - 0.3 * width) * cos(theta) - m.a.y * sin(theta) + 0.3 * width, (m.a.x - 0.3 * width) * sin(theta) + m.a.y  * cos(theta));
      PVector p2 = new PVector((m.b.x - 0.3 * width) * cos(theta) - m.b.y * sin(theta) + 0.3 * width, (m.b.x - 0.3 * width) * sin(theta) + m.b.y * cos(theta));
      newLines.add(new KochLine(p1, p2, m.c));
    }
    lines = newLines;
  }
  
  void nextLevel() {
    lines = iterate(lines);
    count++;
  }
  
  void restart() {
    count = 0;
    color col = color(255);
    if (background) col = color(100);
    lines.clear();
    lines.add(new KochLine(point1, point3, col));
    lines.add(new KochLine(point3, point2, col));
    lines.add(new KochLine(point2, point1, col));
  }
  
  int getCount() {
    return count;
  }
  
  void render() {
    // do background changes here if there are any ?
    //background(random(0, 255), random(0, 255), random(0, 255));
    color white = color(255);
    for (KochLine l : lines) {
      if (l.c == white) l.c = color(random(0, 255), random(0, 255), random(0, 255));
      l.display(background);
    }
  }
  
  ArrayList iterate(ArrayList<KochLine> before) {
    ArrayList now = new ArrayList<KochLine>();    // Create empty list
    for(KochLine l : before) {
      // Calculate 5 koch PVectors (done for us by the line object)
      PVector a = l.start();                 
      PVector b = l.kochleft();
      PVector c = l.kochmiddle();
      PVector d = l.kochright();
      PVector e = l.end();
      // Make line segments between all the PVectors and add them
      now.add(new KochLine(a, b, l.c));
      now.add(new KochLine(b, c, l.c));
      now.add(new KochLine(c, d, l.c));
      now.add(new KochLine(d, e, l.c));
    }
    return now;
  }
}

// Source: https://processing.org/examples/koch.html
// The Nature of Code
// @author Daniel Shiffman
// @author Christy Lee

// Koch Curve
// A class to describe one line segment in the fractal
class KochLine {

  PVector a; // left
  PVector b; // right
  color c;   // color

  // constructor 
  KochLine(PVector start, PVector end, color col) {
    a = start.copy();
    b = end.copy();
    c = col;
  }
  
  void editLinePos(float ax, float ay, float bx, float by) {
    a.x = ax;
    a.y = ay;
    b.x = bx;
    b.y = by;
  }
  
  void editLineColor(color col) {
    c = col;
  }

  void display(boolean background) {
    if (background) strokeWeight(1);
    else strokeWeight(1.5);
    stroke(c);
    line(a.x, a.y, b.x, b.y);
  }

  PVector start() {
    return a.copy();
  }

  PVector end() {
    return b.copy();
  }

  // This is easy, just 1/3 of the way
  PVector kochleft() {
    PVector v = PVector.sub(b, a);
    v.div(3);
    v.add(a);
    return v;
  }    

  // More complicated, have to use a little trig to figure out where this PVector is!
  PVector kochmiddle() {
    PVector v = PVector.sub(b, a);
    v.div(3);
    
    PVector p = a.copy();
    p.add(v);
    
    v.rotate(-radians(60));
    p.add(v);
    
    return p;
  }    

  // Easy, just 2/3 of the way
  PVector kochright() {
    PVector v = PVector.sub(a, b);
    v.div(3);
    v.add(b);
    return v;
  }
}
