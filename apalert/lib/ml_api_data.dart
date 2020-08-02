

import 'dart:convert';

import 'package:apalert/pollution_status.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weather/weather_library.dart';
import 'package:http/http.dart' as http;
import 'package:charts_flutter/flutter.dart' as charts;

class MLAPIData extends StatefulWidget {

  final MLData;
  final APIData;

  MLAPIData(this.MLData,this.APIData);

  @override
  _MLAPIDataState createState() => _MLAPIDataState();
}

class _MLAPIDataState extends State<MLAPIData> {


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('API Vs ML Prediction'), centerTitle: true,),
      body: SafeArea(
        child: SingleChildScrollView(
            child: new Column(
              children: <Widget>[
                layout("Weather API Prediction(Every 3 hours)", widget.APIData),
                layout("ML Model Prediction(Every 3 hours)", widget.MLData),


              ],
            )
        ),
      ),
    );
  }

  _getSeriesData(data) {
    List<charts.Series<AirData, int>> series = [
      charts.Series(
          id: "Data",
          data: data,
          domainFn: (AirData series, _) => series.x,
          measureFn: (AirData series, _) => series.y,
          colorFn: (AirData series, _) => charts.MaterialPalette.blue.shadeDefault
      )
    ];
    return series;
  }

  Widget layout(title,data){
    return Container(
        height: 400,
        margin: EdgeInsets.all(15),
        child: Card(
          child: Column(
            children: <Widget>[
              Text(
                "$title",
                style: TextStyle(
                    fontWeight: FontWeight.bold
                ),
              ),
              SizedBox(height: 20,),
              Expanded(
                child: new charts.LineChart(_getSeriesData(data), animate: true,),
              )
            ],
          ),
        )
    );
  }


}
