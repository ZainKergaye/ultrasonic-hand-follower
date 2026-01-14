#include <Servo.h>

#define SERVO_PIN 11
#define MIC_COUNT 3 

Servo arm0;
int[] mic_pins = {10, 9, 8};


void setup() {
  arm0.attach(SERVO_PIN);
  Serial.begin(9600);
}

void loop() {
  arm0.write(0);
  Serial.println(0);
  delay(5000);
}


/* 
* localization_algorithm - Takes an array of signals with samples and threshold. 
* Returns the angle it came from
* signal - array of signals 
* samples - number of samples 
* threshold - minimum signal noise
* 
* returns int
*/
static int localization_algorithm(double signal[], int samples, double threshold) {

  for(int i = 0; i < samples; i++) {
     
  }

  return 0;
}
