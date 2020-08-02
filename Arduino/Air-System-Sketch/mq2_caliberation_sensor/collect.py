import serial

ser = serial.Serial('/dev/ttyACM0',baudrate=9600,timeout=2)

while True:
    arduinoData = ser.readline().decode('ascii')
    print('------------------- MQ-135 --------------------')
    print(arduinoData)

    arduinoData = ser.readline().decode('ascii')
    print('------------------- MQ-7 ----------------------')
    print(arduinoData)

    arduinoData = ser.readline().decode('ascii')
    print('------------------- MQ-2 ----------------------')
    print(arduinoData)

    arduinoData = ser.readline().decode('ascii')
    print('--------- Temperature & Humidity --------------')
    print(arduinoData)
