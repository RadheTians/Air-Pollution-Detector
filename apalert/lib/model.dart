
import 'package:cloud_firestore/cloud_firestore.dart';

class Model {
  Timestamp time;
  double LPG;
  double CO;
  double smoke;
  double temperature;
  double humidity;
  double airquality;
  double CO2;
  double NH4;
  Model(this.humidity, this.temperature, this.time);

  Model.fromSnapshot(snapshot) :
        humidity = snapshot["humidity"],
        temperature = snapshot["temperature"],
        LPG = snapshot["LPG"],
        CO = snapshot["CO"],
        smoke = snapshot["smoke"],
        airquality = snapshot["airquality"],
        CO2 = snapshot["CO2"],
        NH4 = snapshot["NH4"],
        time = snapshot["time"];

  toJson() {
    return {
      "humidity": humidity,
      "temperature": temperature,
      "time": time,
    };
  }
}