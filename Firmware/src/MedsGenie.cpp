#include <Arduino.h>
#include <Debounce.h>
#include <U8x8lib.h>
#include "application.h"

#ifdef U8X8_HAVE_HW_SPI
#include <SPI.h>
#endif
#ifdef U8X8_HAVE_HW_I2C
#include <Wire.h>
#endif

SYSTEM_THREAD(ENABLED);

#include "pitches.h"
#include "types.h"

// Pins
int lockServoPin = A4;
int transportServoPin = D0;
int buzzerPin = RX;
int CLKPin = A3;
int MOSIPin = A5;
int RESPin = A0;
int DCPin = A1;
int CSPin = A2;
int btnPin = D1;

int numberOfTrays = 4;
int servoDelay = 200;
int lastLockPosition = 0;
int lastTransportPosition = 0;
int lockAngles[] = {170, 140, 98, 56, 17};
int transportAngles[] = {16, 45, 86, 128, 168};
/*int lockAngles[] = {180, 140, 100, 63, 22};
int transportAngles[] = {11, 45, 86, 128, 168};*/
bool isSignaling;
bool switchState;
unsigned long bootTime;
bool alreadyEnteredListenMode;

int melody[] = {
  NOTE_C4, NOTE_G3,NOTE_G3, NOTE_A3, NOTE_G3, 0, NOTE_B3, NOTE_C4};
int noteDurations[] = { 4, 8, 8, 4, 4, 4, 4, 4 };
state_type state = READY;

//#define USE_SCREEN

// LED status for the test signal that can be triggered from the cloud
class LEDCloudSignalStatus: public LEDStatus {
public:
  explicit LEDCloudSignalStatus(LEDPriority priority) :
        LEDStatus(LED_PATTERN_CUSTOM, priority),
        ticks_(0),
        index_(0) {
    updateColor();
  }

protected:
  virtual void update(system_tick_t t) override {
    if (t >= ticks_) {
      // Change LED color
      if (++index_ == COLOR_COUNT) {
        index_ = 0;
      }
      updateColor();
    } else {
      ticks_ -= t; // Update timing
    }
  }

private:
  uint16_t ticks_;
  uint8_t index_;

  void updateColor() {
    setColor(COLORS[index_]);
    ticks_ = 100;
  }

  static const uint32_t COLORS[];
  static const size_t COLOR_COUNT;
};
const uint32_t LEDCloudSignalStatus::COLORS[] = { 0xEE82EE, 0x4B0082, 0x0000FF, 0x00FF00, 0xFFFF00, 0xFFA500, 0xFF0000 }; // VIBGYOR
const size_t LEDCloudSignalStatus::COLOR_COUNT = sizeof(LEDCloudSignalStatus::COLORS) / sizeof(LEDCloudSignalStatus::COLORS[0]);

U8X8_SH1106_128X64_NONAME_4W_HW_SPI u8x8(CSPin, DCPin, RESPin);
Debounce button = Debounce();
Servo lockServo;
Servo transportServo;
LEDCloudSignalStatus rainbowSignal(LED_PRIORITY_IMPORTANT);

/**
 * Private functions
 */
#pragma mark Private functions

void _attachServos() {
  SPI.end();
  lockServo.attach(lockServoPin);
  transportServo.attach(transportServoPin);
}

void _updateScreen() {
  u8x8.clear();

  switch(state) {
    case READY:
      u8x8.draw2x2String(0, 1, "PRESS TO");
      u8x8.draw2x2String(0, 5, "DISPENCE");
      break;
    case WORKING:
      u8x8.draw2x2String(1, 2, "WORKING");
      u8x8.draw2x2String(1, 4, "  ...");
      break;
    case CONFIRM:
      u8x8.draw2x2String(1, 1, "CONFIRM");
      u8x8.draw2x2String(1, 5, "   ?");
      break;
  }

  u8x8.refreshDisplay();
}

void _setNewState(state_type newState) {
  state = newState;
#ifdef USE_SCREEN
  _updateScreen();
#endif
}

void _lockTo(int pos, bool skipDelay=false) {
  _attachServos();
  lockServo.write(lockAngles[pos]);
  if (!skipDelay) delay(servoDelay * abs(lastLockPosition - pos));
  lastLockPosition = pos;
}

void _transportTo(int pos, bool skipDelay=false) {
  _attachServos();
  transportServo.write(transportAngles[pos]);
  if (!skipDelay) delay(servoDelay * abs(lastTransportPosition - pos));
  lastTransportPosition = pos;
}

int _servePill(int pos) {
  // Test for oob position
  if ((pos < 0) || (pos > numberOfTrays - 1)) return 404;

  // 0 tray is drop zone. Increase position
  pos++;

  // Lock
  _lockTo(numberOfTrays);

  // Move transport under tray
  _transportTo(pos);

  // Unlock...
  _lockTo(pos, pos == numberOfTrays);

  // Let it drop
  delay(200);

  // Lock again
  _lockTo(4, pos == numberOfTrays);

  // Move transport to drop zone
  _transportTo(0);

  return 200;
}

/**
 * Particle functions
 */
#pragma mark Particle functions

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

  _setNewState(WORKING);
  SPI.end();
  lockServo.attach(lockServoPin);
  transportServo.attach(transportServoPin);
  rainbowSignal.setActive(true);

  String currentCommand = command;
  while (currentCommand.indexOf(",") > -1) {
      int pos = currentCommand.substring(0, currentCommand.indexOf(",")).toInt();
      String newCommand = currentCommand.substring(currentCommand.indexOf(",") + 1);
      currentCommand = newCommand;
      Serial.println(currentCommand);
      returnCode = _servePill(pos);
  }

  int pos = currentCommand.toInt();
  returnCode = _servePill(pos);


  rainbowSignal.setActive(false);
  u8x8.begin();
  _setNewState(CONFIRM);

  return returnCode;
}

int goToCommand(String command) {
  int pos = command.toInt();
  _lockTo(pos);
  _transportTo(pos);
  return 200;
}

int setTransCommand(String command) {
  transportServo.write(command.toInt());
  return 200;
}

int setLockCommand(String command) {
  lockServo.write(command.toInt());
  return 200;
}

int setStateCommand(String command) {
  _setNewState((state_type)command.toInt());
  return 200;
}

int notifyCommand(String command) {
  Particle.publish("pills-taken");
  return 200;
}

/**
 * Main functions
 */
#pragma mark Main functions

void setup() {
  bootTime = millis();

  lockServo.attach(lockServoPin);
  transportServo.attach(transportServoPin);

  _lockTo(0);
  _transportTo(0);

  button.attach(btnPin, INPUT_PULLUP);
  button.interval(20);

  Particle.function("serve", servePillCommand);
  Particle.function("goto", goToCommand);
  Particle.function("beep", beepCommand);

  Particle.function("trans", setTransCommand);
  Particle.function("lock", setLockCommand);
  Particle.function("state", setStateCommand);
  Particle.function("notify", notifyCommand);

  Serial.begin(9600);

#ifdef USE_SCREEN
  u8x8.begin();
  u8x8.setFont(u8x8_font_amstrad_cpc_extended_u);
#endif
  _setNewState(READY);

  System.set(SYSTEM_CONFIG_SOFTAP_PREFIX, "diana");
  System.set(SYSTEM_CONFIG_SOFTAP_SUFFIX, "hi:)");
}

void loop() {
  if (WiFi.connecting() && (millis() - bootTime > 20000) && !alreadyEnteredListenMode) {
    alreadyEnteredListenMode = true;
    WiFi.listen();
  }

  if (button.update() && (button.read() == LOW)) {
    switch(state) {
      case READY:
        servePillCommand("1,2");
        break;
      case CONFIRM:
        notifyCommand("");
        _setNewState(READY);
        break;
    }
  }
}
