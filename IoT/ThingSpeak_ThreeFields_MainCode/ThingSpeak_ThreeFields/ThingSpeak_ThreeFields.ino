
 /** Connections for Communication:
 * ESP01   ->  Arduino
 * Vcc     ->  3.3V
 * GND     ->  GND
 * TxD     ->  Rx1 (Pin 19)
 * RxD     ->  Tx1 (Pin 18)
 * CH_PD   ->  3.3V
 **/
 


#include <SimpleDHT.h>
#include <TimeLib.h>

#define TIME_HEADER  "T" 
#define TIME_REQUEST  7  

int pinDHT11 = 2;
SimpleDHT11 dht11(pinDHT11);

int gas_sensor = A0; 
float m = -0.3376;  
float b = 0.7165; 
float R0 = 2.82; 

int CO_sensor = A1; 
float m1 = -0.6527;
float b1 = 1.30; 
float R01 = 7.22; 


void setup() {
  
  Serial.begin(9600);      
  pinMode(gas_sensor, INPUT);
  pinMode(CO_sensor,INPUT);
  //setSyncProvider(requestSync); 
  
  
 } 

void loop() { 

//  if (Serial.available()) {
//    processSyncMessage();
//  }
//  if (timeStatus()!= timeNotSet) {
//    Serial.print(year()); 
//    Serial.print(",");
//    Serial.print(month());
//    Serial.print(",");
//    Serial.print(day());
//    Serial.print(",");
//    Serial.print(hour());
//    Serial.print(",");
//    Serial.print(minute());
//    Serial.print(",");
//  }

  byte temperature = 0;
  byte humidity = 0;
  int err = SimpleDHTErrSuccess;
  dht11.read(&temperature, &humidity, NULL);
  

  Serial.print((int)temperature); 
  Serial.print(",");
  Serial.print((int)humidity);
  Serial.print(","); 

  
  float sensor_volt;
  float RS_gas;  
  float ratio; 
  
  float sensorValue = analogRead(gas_sensor);  
  
  sensor_volt = sensorValue*(5.0/1023.0);
  RS_gas = ((5.0*10.0)/sensor_volt)-10.0;
  ratio = RS_gas/R0;  
  
  double ppm_log = (log10(ratio)-b)/m; 
  double ppm = pow(10, ppm_log); 
  //Serial.print("Our desired PPM = ");
  Serial.print(ppm);
  Serial.print(",");
  

  float sensor_volt1; 
  float RS_gas1;
  float ratio1; 
  
  float sensorValue1 = analogRead(CO_sensor); 
  sensor_volt1 = sensorValue1*(5.0/1023.0); 
  RS_gas1 = ((5.0*10.0)/sensor_volt1)-10.0; 
  ratio1 = RS_gas1/R01;  
  double ppm_log1 = (log10(ratio1)-b1)/m1;  
  double ppm1 = pow(10, ppm_log1); 
  //Serial.print("CO PPM = ");
  Serial.print(ppm1);
  Serial.println();
 
  delay(15000);
  
 }

 void processSyncMessage() {
  unsigned long pctime;
  const unsigned long DEFAULT_TIME = 1357041600;

  if(Serial.find(TIME_HEADER)) {
     pctime = Serial.parseInt();
     if( pctime >= DEFAULT_TIME) {
       setTime(pctime);
     }
  }
}

 time_t requestSync(){
  Serial.write(TIME_REQUEST);  
  return 0; 
}
