#define MQ2pin (0)
float sensorValue;

void setup()  {
  Serial.begin(9600);
  delay(10000); 
}
void loop() {
  sensorValue = analogRead(MQ2pin); 
  Serial.println(sensorValue);
}
