
import 'dart:convert';

import 'package:apalert/MLData.dart';
import 'package:apalert/ml_api_data.dart';
import 'package:apalert/pollution_status.dart';
import 'package:apalert/realtime_data.dart';
import 'package:apalert/weather_api.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weather/weather_library.dart';
import 'package:http/http.dart' as http;

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {


  final _database = Firestore.instance.collection("coliberation");
  final key = '856822fd8e22db5e1ba48c0e7d69844a';
  WeatherStation weatherStation;
  static const baseUrl = 'https://morning-scrubland-75035.herokuapp.com';
  List<AirData> mlData = new List<AirData>();
  List<AirData> APIData = new List<AirData>();
  List<AirData> CO = new List<AirData>();
  List<AirData> CO2 = new List<AirData>();
  List<AirData> LPG = new List<AirData>();
  List<AirData> smoke = new List<AirData>();
  List<AirData> temp = new List<AirData>();
  List<AirData> humidity = new List<AirData>();
  List<AirData> NH4 = new List<AirData>();
  List<AirData> airquality = new List<AirData>();
  bool flag = true;

  Future _cloudStorageData() async{
    Query doc = await _database.orderBy("time",descending: true);
    var time = 1;
    doc.snapshots().listen((data){
      data.documents.forEach((snapshot){
        //var time = snapshot.data['time'].toDate().millisecond;
        CO.add(new AirData(time, snapshot.data['CO']));
        CO2.add(new AirData(time, snapshot.data['CO2']));
        LPG.add(new AirData(time, snapshot.data['LPG']));
        smoke.add(new AirData(time, snapshot.data['smoke']));
        airquality.add(new AirData(time, snapshot.data['airquality']));
        NH4.add(new AirData(time, snapshot.data['NH4']));
        temp.add(new AirData(time, snapshot.data['temperature']));
        humidity.add(new AirData(time, snapshot.data['humidity']));
        time++;
      });
    });
  }

  Future _weatherAPI() async{
    List<Weather> forecasts = await weatherStation.fiveDayForecast(27, 77);
    var x = 1;
    forecasts.forEach((snapshot){
      APIData.add(new AirData(x,snapshot.temperature.celsius.round()));
      x++;
    });
  }

  Future _getPrediction(year,month,day,hour,minute,humidity) async{

    setState(() async {
      final url = '$baseUrl/date/?name=$year,$month,$day,$hour,$minute,$humidity';
      final res = await http.get(url);

      var x = 1;
      for(dynamic y in json.decode(res.body).values){
        mlData.add(new AirData(x,y.round()));
        x++;
      }
    });

  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _cloudStorageData();
    weatherStation = new WeatherStation(key);
    _weatherAPI();
    _getPrediction(DateTime.now().year, DateTime.now().month, DateTime.now().day,DateTime.now().hour, DateTime.now().minute, 55);
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('AP Detector Home'),
        centerTitle: true,
      ),
      body: new SafeArea(
          child: new SingleChildScrollView(
            child: new Center(

              child:  new Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(height: height/18,),
                  singleButton("Real Time Data",RealTimeData()),
                  SizedBox(height: height/18,),
                  singleButton("Machine Learning Prediction",MLData()),
                  SizedBox(height: height/18,),
                  singleButton("Weather API Data",WeatherAPI()),
                  SizedBox(height: height/18,),
                  singleButton("Air Pollution Status",PollutionStatus(this.CO,this.CO2,this.NH4,this.temp,this.humidity,this.LPG,this.airquality,this.smoke)),
                  SizedBox(height: height/18,),
                  singleButton("Real And API Data",RealTimeData()),
                  SizedBox(height: height/18,),
                  singleButton("ML And API Data",MLAPIData(mlData,APIData)),


                ],
              ),
            )
          )
      ),

    );
  }

  Widget singleButton(text,nextPage) {

    return new Container(
      width: 288.0,
      child: ButtonTheme(
        height: 48.0,
        minWidth: 188,
        buttonColor: Colors.deepOrange[400],
        child: RaisedButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            onPressed: () {
              // add later
              Navigator.push(context, MaterialPageRoute(builder: (context) => nextPage));
            },
            child: Center(
              child: Text(
                '$text',
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.white,
                ),
              ),
            )),
      ),
    );
  }
}
