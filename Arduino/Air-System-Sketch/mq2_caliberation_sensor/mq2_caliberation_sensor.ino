
#include <SimpleDHT.h>
#include <SD.h>

int pinDHT11 = 2;  //define which digital input channel you are going to use for DHT-11
SimpleDHT11 dht11(pinDHT11);

const int inputPin1 = A0;  //define which analog input channel you are going to use for MQ-135
const int inputPin2 = A1;  //define which analog input channel you are going to use for MQ-7
const int inputPin3 = A2;  //define which analog input channel you are going to use for MQ-2


float R01;  //define the load resistance on the board for MQ-135, in kilo 
float R02;  //define the load resistance on the board for MQ-7, in kilo 
float R03;  //define the load resistance on the board for MQ-2, in kilo 


/*****************************Globals for MO-2 Sensor***********************************************/
float LPGCurve[3] = {2.3,0.21,-0.47};   //two points are taken from the curve. 
                                        //with these two points, a line is formed which is "approximately equivalent"
                                        //to the original curve. 
                                        //data format:{ x, y, slope}; point1: (lg200, 0.21), point2: (lg10000, -0.59) 
float COCurve[3] = {2.3,0.72,-0.34};    //two points are taken from the curve. 
                                        //with these two points, a line is formed which is "approximately equivalent" 
                                        //to the original curve.
                                        //data format:{ x, y, slope}; point1: (lg200, 0.72), point2: (lg10000,  0.15) 
float SmokeCurve[3] = {2.3,0.53,-0.44};    //two points are taken from the curve. 
                                           //with these two points, a line is formed which is "approximately equivalent" 
                                           //to the original curve.
                                           //data format:{ x, y, slope}; point1: (lg200, 0.53), point2: (lg10000,  -0.22) 

/*****************************Globals for MO-135 Sensor***********************************************/
float AirQuality[3] = {2.3,0.50,-0.30};   //two points are taken from the curve. 
                                        //with these two points, a line is formed which is "approximately equivalent"
                                        //to the original curve. 
                                        //data format:{ x, y, slope}; point1: (lg200, 0.50), point2: (lg10000, 0.49) 
float CO2Curve[3] = {2.3,0.30,-0.34};    //two points are taken from the curve. 
                                        //with these two points, a line is formed which is "approximately equivalent" 
                                        //to the original curve.
                                        //data format:{ x, y, slope}; point1: (lg200, 0.30), point2: (lg10000,  0.15) 
float NH4[3] = {2.3,0.35,-0.35};    //two points are taken from the curve. 
                                           //with these two points, a line is formed which is "approximately equivalent" 
                                           //to the original curve.
                                           //data format:{ x, y, slope}; point1: (lg200, 0.35), point2: (lg10000,  0.13)                                            

void setup() {

  
  Serial.begin(9600);  //Baud rate 
  pinMode(inputPin1, INPUT);  // initializing input pin for MQ-135
  pinMode(inputPin2, INPUT);  // initializing input pin for MQ-7
  pinMode(inputPin3, INPUT);  // initializing input pin for MQ-2
  R01 = R0Calculate(A0);  //Calibrating the MQ-135 sensor. Please make sure the sensor is in clean air 
  R02 = R0Calculate(A1);  //Calibrating the MQ-7 sensor. Please make sure the sensor is in clean air 
  R03 = R0Calculate(A2);  //Calibrating the MQ-2 sensor. Please make sure the sensor is in clean air 
  delay(10000);  // delay unit of 10 seconds
}

void loop() {
  
  Caliberation(inputPin3,R03,LPGCurve,COCurve,SmokeCurve); // Data caliberation from MQ-2 sensor
  
  float sensor_volt;
  float RS_gas; 
  float ratio; 

  float sensorValue = analogRead(inputPin2); // Data caliberation from MQ-7 sensor
  
  sensor_volt = sensorValue*(5.0/1023.0);
  RS_gas = ((5.0*10.0)/sensor_volt)-10.0; 
  ratio = RS_gas/R02;
  Serial.println(ratio);
  
  Caliberation(inputPin1,R01,AirQuality,CO2Curve,NH4);  // Data caliberation from MQ-135 sensor

  
  byte temperature = 0;
  byte humidity = 0;
  int err = SimpleDHTErrSuccess;
  dht11.read(&temperature, &humidity, NULL); // Data caliberation from DHT-11 sensor
  
 
  Serial.print((int)temperature);
  Serial.print(","); 
  Serial.println((int)humidity);

  
  delay(2000); // delay unit of 3 seconds

}

/*****************************  Caliberation **********************************
Input:   pin - analog channel
         R0 - the load resistance
         *curve1 - curve points one
         *curve2 - curve points two
         *curve3 - curve points three
Output:  ppm of the target gas
Remarks: This function passes different curves to the MQGetPercentage function which 
         calculates the ppm (parts per million) of the target gas.
************************************************************************************/ 
void Caliberation(int pin, float R0, float *curve1, float *curve2, float *curve3) {
  
  float sensor_volt;
  float RS_gas; 
  float ratio; 

  float sensorValue = analogRead(pin); //reading analog signal
  
  sensor_volt = sensorValue*(5.0/1023.0);
  RS_gas = ((5.0*10.0)/sensor_volt)-10.0; 
  ratio = RS_gas/R0;  
  
  double  v1 = MQGetPercentage(ratio,curve1);  //It calculates the ppm (parts per million) of the target gas.
  Serial.print(v1);
  Serial.print(",");
  
  double  v2 = MQGetPercentage(ratio,curve2); //It calculates the ppm (parts per million) of the target gas.
  Serial.print(v2);
  Serial.print(",");

  double  v3 = MQGetPercentage(ratio,curve3); //It calculates the ppm (parts per million) of the target gas.
  Serial.println(v3);
  
}

/***************************** R0Calculate ****************************************
Input:   pin - analog channel
Output:  Ro of the sensor
Remarks: This function assumes that the sensor is in clean air. It uses  
         10000 samples to calculates the sensor resistance in clean air 
         and then divides it with 10000 ,which differs slightly between different sensors.
************************************************************************************/ 
float R0Calculate(int pin){

  float RS_air; 
  float R0;
  float sensorValue=0.0;
  float sensor_volt;
  
  for(int x = 0 ; x < 10000 ; x++) 
  {
    sensorValue = sensorValue + analogRead(pin);
  }

  sensorValue = sensorValue/10000.0;
  
  sensor_volt = sensorValue*(5.0/1023.0); 
  RS_air = ((5.0*10.0)/sensor_volt)-10.0;
  R0 = RS_air/3.7;
  
  return R0;
  
}

/*****************************  MQGetPercentage **********************************
Input:   rs_ro_ratio - Rs divided by Ro
         pcurve      - pointer to the curve of the target gas
Output:  ppm of the target gas
Remarks: By using the slope and a point of the line. The x(logarithmic value of ppm) 
         of the line could be derived if y(rs_ro_ratio) is provided. As it is a 
         logarithmic coordinate, power of 10 is used to convert the result to non-logarithmic 
         value.
************************************************************************************/ 
double  MQGetPercentage(float rs_ro_ratio, float *pcurve)
{
  return (pow(10,( ((log(rs_ro_ratio)-pcurve[1])/pcurve[2]) + pcurve[0])));
}
