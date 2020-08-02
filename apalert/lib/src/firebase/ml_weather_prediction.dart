

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:weather/src/api/http_exception.dart';
import 'package:weather/src/firebase/ml_api_client.dart';
import 'package:http/http.dart' as http;

class MLPredictionData extends StatefulWidget{


  @override
  State<StatefulWidget> createState() => new _MLPredictionDataState();

}

class _MLPredictionDataState extends State<MLPredictionData> {

  List<dynamic> _mldata;
  static const baseUrl = 'https://morning-scrubland-75035.herokuapp.com';
  var prediction;
  @override
  void initState() {
    super.initState();
    MLApiClient mlApiClient = MLApiClient(http.Client());
    //print(mlApiClient.getHomeMessage());
    prediction = mlApiClient.getPrediction(2020, 5, 20, 5, 45, 60);


  }


  @override
  Widget build(BuildContext context) {

    return new Scaffold(
      appBar: new AppBar(
        title: new Text('ML Prediction'),
      ),
      backgroundColor: Colors.red,
      body: showlayout(),
    );

  }

  Widget showlayout(){


    return FutureBuilder(
        future: prediction,
        builder: (context, projectSnap){
          if(projectSnap.connectionState == ConnectionState.none &&
              projectSnap.hasData == null) {
            print('project snapshot data is: ${projectSnap.data}');
            return Container();
          }
          if(prediction!=null)
          return ListView.builder(
            itemCount: projectSnap.data.length,
            itemBuilder: (BuildContext context, int index){
              //print(projectSnap.data.values[0]);
              final data = projectSnap.data.values;

              return Card(
                color: Colors.black26,
                elevation: 10,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
                child: Text(data.toString()),
              );

            },
          );


        }
    );

  }



  void fromJson(json) async{
    _mldata = new List();
    for (final item in json.values) {
      _mldata.add(item);
    }
  }

  Future<Map<String,dynamic>> getPrediction(year,month,day,hour,minute,humidity) async{

    final url = '$baseUrl/date/?name=$year,$month,$day,$hour,$minute,$humidity';
    print('fetching $url');
    final res = await http.Client().get(url);
    if (res.statusCode != 200) {
      throw HTTPException(res.statusCode, "unable to fetch weather data");
    }
    final predictionData = json.decode(res.body);
    return predictionData;
  }


}




