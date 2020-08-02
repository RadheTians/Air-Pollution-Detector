import serial
import math

import firebase_admin
from firebase_admin import credentials
from firebase_admin import firestore

cred = credentials.Certificate("firebase-key.json")
firebase_admin.initialize_app(cred)
db = firestore.client()
col_ref = db.collection('coliberation')

LPGCurve = [2.3,0.21,-0.47] 
COCurve = [2.3,0.72,-0.34]
SmokeCurve = [2.3,0.53,-0.44] 


def MQGetPercentage(rs_ro_ratio, pcurve):
	return pow(10,((math.log(rs_ro_ratio)-pcurve[1])/pcurve[2]) + pcurve[0])



def R0Calculate():

	sensorValue = 0.0
  
	for _ in range(10000): 

		arduinoData = ser.readline().decode('ascii')
		value = float(arduinoData)
		sensorValue += value
  
	sensorValue /= 10000.0
	sensor_volt = sensorValue*(5.0/1023.0)
	RS_air = ((5.0*10.0)/sensor_volt)-10
	R0 = RS_air/3.7
	return R0
  

if __name__ == "__main__":
	

	ser = serial.Serial('/dev/ttyACM0',baudrate=9600,timeout=1)
	R0 = R0Calculate()

	while True:
		arduinoData = ser.readline().decode('ascii')
		sensorValue = float(arduinoData)
		sensor_volt = sensorValue*(5.0/1023.0)
		RS_gas = ((5.0*10.0)/sensor_volt)-10
		ratio = RS_gas/R0
		print(MQGetPercentage(ratio,LPGCurve))
		print(MQGetPercentage(ratio,COCurve))
		print(MQGetPercentage(ratio,SmokeCurve))
