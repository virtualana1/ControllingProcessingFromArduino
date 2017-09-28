import processing.serial.*;

Serial myPort;

String value;

int ellipseSize = 100;

int rectangleSize = 100;

int triangleSize = 100;

int quadSize = 100;

int temperature, soundlevel, potlevel, touch  =0;

void setup(){
  size (1023, 1023);
  
  printArray(Serial.list());
  
  String portName = Serial.list()[3];
  
  myPort = new Serial(this, portName, 9600);
  
}

void draw(){
  fill(0, 0, 200, 60);
  rectMode (CORNER);
  rect(0, 0, width, height);
  if(myPort.available() > 0) {
    value = myPort.readStringUntil('\n');
  }
  if(value!=null) {
    value= value.trim();
        int mysensors[] = int(split(value, '\t'));
    
    //make sure we have all 3 values
    if(mysensors.length == 4){
      //assign those values to the corrresponding variables
      temperature = mysensors[0];
      potlevel = mysensors[1];
      soundlevel = mysensors[2];
      touch = mysensors [3];
    }
  }
  
  // map the temperature value from the range of -40...125 to a range of 0...255
  // to be used as a color value
  // see https://processing.org/reference/map_.html for details
  float processedColor = map(temperature, -40, 125, 0, 255);
  // draw our rectangle with a bit of opacity using re-mapped temperature value for the blue component
   noStroke();
   fill(255, 51, processedColor, 40);
  // make sure it's in the RADIUS mode,
  // so drawing from the center and using half its side as a measurement:
  ellipseMode(CENTER);
  // potentiometer will move the rectangle left and right
  // sound levels will determine the size
  ellipse(potlevel, height/2, soundlevel, soundlevel);
}
    