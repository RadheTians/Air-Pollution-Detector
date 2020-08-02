

import 'package:flutter/cupertino.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';

class AirData {
  final dynamic x;
  final dynamic y;

  AirData(this.x, this.y);
}

class PollutionStatus extends StatefulWidget {

  final CO;
  final CO2;
  final NH4;
  final temp;
  final humidity;
  final LPG;
  final airquality;
  final smoke;
  PollutionStatus(this.CO,this.CO2,this.NH4,this.temp,this.humidity,this.LPG,this.airquality,this.smoke);

  @override
  _PollutionStatusState createState() => _PollutionStatusState();
}


class _PollutionStatusState extends State<PollutionStatus> {



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


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Air Pollution Status'), centerTitle: true,),
      body: SafeArea(
        child: SingleChildScrollView(
          child: new Column(
            children: <Widget>[
              layout("Temperature Data(time in decreasing order)", widget.temp),
              layout("Humidity Data(time in decreasing order)", widget.humidity),
              layout("Air Quality(time in decreasing order)", widget.airquality),
              layout("CO Gas Data(time in decreasing order)", widget.CO),
              layout("CO2 Gas Data(time in decreasing order)", widget.CO2),
              layout("NH4 Gas Data(time in decreasing order)", widget.NH4),
              layout("Smoke Data(time in decreasing order)", widget.smoke),
              layout("LPG Gas Data(time in decreasing order)", widget.LPG),

            ],
          )
        ),
      ),
    );
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


