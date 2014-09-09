#include "pitches.h"

Servo lockServo;
Servo transportServo;

int numberOfTrays = 4;
int holeAngle = 180 / (numberOfTrays + 1);
int lockAngleOffset = 7;
int transportAngleOffset = 11;
int servoDelay = 500;
int lastLockPosition = 0;
int lastTransportPosition = 0;
int buzzerPin = A4;

int melody[] = {
  NOTE_C4, NOTE_G3,NOTE_G3, NOTE_A3, NOTE_G3, 0, NOTE_B3, NOTE_C4};
int noteDurations[] = {
  4, 8, 8, 4, 4, 4, 4, 4 };

void lockTo(int pos, bool skipDelay=false) {
  lockServo.write(180 - (pos * (holeAngle - 2) + lockAngleOffset));
  if (!skipDelay) delay(servoDelay * abs(lastLockPosition - pos));
  lastLockPosition = pos;
}

void transportTo(int pos, bool skipDelay=false) {
  transportServo.write(pos * (holeAngle - 1) + transportAngleOffset);
  if (!skipDelay) delay(servoDelay * abs(lastTransportPosition - pos));
  lastTransportPosition = pos;
}

int servePill(int pos) {
  // Test for oob position
  if ((pos < 0) || (pos > numberOfTrays - 1)) return 404;

  // 0 tray is drop zone. Increase position
  pos++;

  // Lock
  lockTo(pos < numberOfTrays - 1 ? pos + 1 : pos);

  // Move transport under tray
  transportTo(pos);

  // Unlock...
  /*delay(servoDelay);*/
  lockTo(pos);

  // Move transport to drop zone

  transportTo(0, true);
  delay(servoDelay);

  // ...and lock again
  lockTo(0);

  return 200;
}

int beepCommand(String command="") {
  for (int i=0; i<8; i++) {
    int noteDuration = 500/noteDurations[i];

    if (melody[i] == 0) {
      noTone(buzzerPin);
    } else {
      tone(buzzerPin, melody[i]);
    }

    delay(noteDuration);

    noTone(buzzerPin);
    int pauseBetweenNotes = noteDuration * 1.30;
    delay(pauseBetweenNotes);
  }

  return 200;
}

int servePillCommand(String command) {
  int returnCode;

  String currentCommand = command;
  while (currentCommand.indexOf(",") > -1) {
      int pos = currentCommand.substring(0, currentCommand.indexOf(",")).toInt();
      String newCommand = currentCommand.substring(currentCommand.indexOf(",") + 1);
      currentCommand = newCommand;
      Serial.println(currentCommand);
      returnCode = servePill(pos);
  }

  int pos = currentCommand.toInt();
  returnCode = servePill(pos);

  beepCommand();

  return returnCode;
}

int goToCommand(String command) {
  int pos = command.toInt();
  lockTo(pos);
  transportTo(pos);
  return 200;
}

void setup() {
  lockServo.attach(A0);
  transportServo.attach(A1);

  lockTo(0);
  transportTo(0);

  Spark.function("serve", servePillCommand);
  Spark.function("goto", goToCommand);
  Spark.function("beep", beepCommand);

  Serial.begin(9600);
}

void loop() {

}
