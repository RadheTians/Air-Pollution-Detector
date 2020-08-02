
## Necessary packages that need to run this sketch
import serial
from datetime import datetime
import firebase_admin
from firebase_admin import credentials
from firebase_admin import firestore

## Firebase credentials that needs  to connect with firebase firestore
cred = credentials.Certificate("firebase-key.json")  
## Initializing a firebase instance
firebase_admin.initialize_app(cred)
## Taking the reference of firestore client and collection (i.e `caliberation`)
db = firestore.client()
col_ref = db.collection('coliberation')
 
## Initializing Arduino serial port with baudrate 9600 and timelimit 1 second
ser = serial.Serial('/dev/ttyACM2',baudrate=9600,timeout=1)

## Iterating an infinite loop 
while True:
    ## Reading data from Arduino serial port after every 1 second
    arduinoData = ser.readline().decode('ascii')
    ## Splitting a line by `,` because data is CSV like
    sensorValue = arduinoData.split(',')

    ## Bulding a json quary to send data to firebase firestore
    if len(sensorValue)==3:
        ## MQ-2 sensor values
        LPG = float(sensorValue[0])
        _ = float(sensorValue[1])
        smoke = float(sensorValue[2])
        ## MQ-7 sensor value
        CO = float(sensorValue[3])
        ## MQ-135 sensor values
        airquality = float(sensorValue[4])
        CO2 = float(sensorValue[5])
        NH4 = float(sensorValue[6])
        ## DH-11 sensor values
        temperature = float(sensorValue[7])
        humidity = float(sensorValue[8])
        ## A json quary to sending data to database
        data = {
            "time" : datetime.now(),
            "LPG" : LPG,
            "CO" : CO,
            "smoke" : smoke,
            "temperature" : temperature,
            "humidity" : humidity,
            "airquality" : airquality,
            "CO2" : CO2,
            "NH4" : NH4 
        }
        ## Sending to firabase firestore
        col_ref.add(data)
        print(data)
        
