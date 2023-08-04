#include <Arduino.h>

  #include "Adafruit_VL53L0X.h"

Adafruit_VL53L0X lox = Adafruit_VL53L0X();



const int hallPin = 9;
int hallState = 0 ; 


unsigned long startMillis;  //some global variables available anywhere in the program
unsigned long currentMillis;
const unsigned long period = 50;

unsigned long time_to_spin =1000;

void setup() {
startMillis = millis();
pinMode (hallPin , INPUT);
hallState = digitalRead (hallPin); 
Serial.begin(9600);
Wire.begin();
lox.startRangeContinuous();
}

void loop() {
  hallState = digitalRead (hallPin); 

  // currentMillis = millis();
  // if (currentMillis - startMillis >= period) {
  //     Serial.print(currentMillis-startMillis);
  //     startMillis = currentMillis;
  //     //Serial.print("true");
  // }

  if (hallState == LOW){
    Serial.print("true");
  }
  Serial.print("true");
//hallState == LOW && 
  // if (lox.isRangeComplete()) {
  //   Serial.print("Distance in mm: ");
  //   Serial.print(lox.readRange());
  //   //angle
  //   Serial.print(" Angle: ");
  //   Serial.println(currentMillis - startMillis / time_to_spin);
  // }
}


