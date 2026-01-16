#include <Servo.h>

#define SAMPLE_COUNT 4

#define SERVO_PIN 11
#define MIC_COUNT 3 

Servo arm0;
static int mic_pins[] = {10, 9, 8};
int sample_avg [MIC_COUNT] = {0};


void setup() {
  for(int i = 0; i < MIC_COUNT; i++) {
    pinMode(mic_pins[i], INPUT);
  }
  arm0.attach(SERVO_PIN);
  Serial.begin(9600);
}

void loop() {
  int temp_sum = 0;

  for(int i = 0; i < MIC_COUNT; i++) { // Get samples from each mic and average them

    for(int j = 0; j < SAMPLE_COUNT; j++)
      temp_sum += analogRead(mic_pins[i]);
    
    sample_avg[i] = temp_sum / SAMPLE_COUNT;
    temp_sum = 0;
  }


  arm0.write(localization_algorithm(sample_avg, SAMPLE_COUNT, 512));
  //Serial.println(0);
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
static int localization_algorithm(int signal[], int samples, int threshold) {
  int avg_sig = 0; // Calc average sig from all sources
  for(int i = 0; i < samples; i++) avg_sig += signal[i]; 
  avg_sig /= samples; 

  if (avg_sig < threshold) return 0; 
  // Return if sig < threshold
  


  return 0;
}
