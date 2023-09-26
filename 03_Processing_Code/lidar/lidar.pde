import processing.serial.*;
import java.util.ArrayList;

Serial myPort;
int angle;
float distance;
float maxDistance = 1524; // Set the maximum distance for the visualization

// Store lines and their timestamp
class SonarLine {
  float x1, y1, x2, y2;
  long timestamp;

  SonarLine(float x1, float y1, float x2, float y2, long timestamp) {
    this.x1 = x1;
    this.y1 = y1;
    this.x2 = x2;
    this.y2 = y2;
    this.timestamp = timestamp;
  }
}

ArrayList<SonarLine> sonarLines = new ArrayList<>();
int lineStorageTime = 1960; // 20 seconds in milliseconds

void setup() {
  size(1280, 1024);
  background(0);
  stroke(0, 0, 255); // Green stroke color
  noFill();

  // Replace 'COMx' with your specific serial port and set the baud rate accordingly
  myPort = new Serial(this, "COM11", 115200);
}

void draw() {
  if (myPort.available() > 0) {
    String data = myPort.readStringUntil('\n');
    if (data != null) {
      data = data.trim();
      String[] values = split(data, ',');
      if (values.length == 2) {
        angle = int(values[0]);
        distance = float(values[1]);
        drawSonar();
      }
    }
  }
}

void drawSonar() {
  // Clear the background to start fresh for each frame
  background(0);

  // Draw the sonar line for the current angle and distance
  float x = width / 2 + distance * cos(radians(angle));
  float y = height / 2 + distance * sin(radians(angle));

  // Map the distance to a color based on the maximum distance
  //float colorValue = map(distance, 0, maxDistance, 255, 0);
  stroke(0, 0, 255);

  line(width / 2, height / 2, x, y);

  // Store the line and timestamp
  long currentTime = millis();
  sonarLines.add(new SonarLine(width / 2, height / 2, x, y, currentTime));

  // Remove old lines
  for (int i = sonarLines.size() - 1; i >= 0; i--) {
    SonarLine line = sonarLines.get(i);
    if (currentTime - line.timestamp > lineStorageTime) {
      sonarLines.remove(i);
    }
  }

  // Draw stored lines
  for (SonarLine line : sonarLines) {
    line(line.x1, line.y1, line.x2, line.y2);
  }
  
  // Draw outer edge using the most recent lines
  if (sonarLines.size() > 2) {
    beginShape();
    for (int i = sonarLines.size() - 1; i >= 0; i--) {
      SonarLine line = sonarLines.get(i);
      vertex(line.x2, line.y2);
    }
    endShape(CLOSE);
  }
}
