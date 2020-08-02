#include <SimpleDHT.h>
#include <SD.h>

// for DHT11, 
//      VCC: 5V or 3V
//      GND: GND
//      DATA: 2
int pinDHT11 = 2;
SimpleDHT11 dht11(pinDHT11);

void setup() {
  Serial.begin(9600);
}

void loop() {
 
  byte temperature = 0;
  byte humidity = 0;
  int err = SimpleDHTErrSuccess;
  dht11.read(&temperature, &humidity, NULL);
  
 
  Serial.print((int)temperature);
  Serial.print(","); 
  Serial.println((int)humidity);
 
  delay(2000);
  
}
