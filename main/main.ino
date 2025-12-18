#include <Servo.h>
#include <Ultrasonic.h>

#define ULTRASONIC_TRIG 12 
#define ULTRASONIC_EMITTER 13
#define SERVO_PIN 11

Ultrasonic ultrasonic(ULTRASONIC_TRIG, ULTRASONIC_EMITTER); 
Servo arm0;

void setup() {
  arm0.attach(SERVO_PIN);
}

void loop() {
 arm0.write(map(ultrasonic.read(), 0, 10, 0, 180));
  // arm0.write(0);
  // delay(1000);
  // arm0.write(180);
  // delay(1000);
}

