

import 'dart:convert';

import 'package:apalert/http_exception.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MLData extends StatefulWidget {
  @override
  _MLDataState createState() => _MLDataState();
}

class _MLDataState extends State<MLData> {

  static const baseUrl = 'https://morning-scrubland-75035.herokuapp.com';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('ML Prediction Data'),
        centerTitle: true,
      ),
      body: new SafeArea(
          child: showlayout(),
      ),
    );
  }

  Widget showlayout(){
    return FutureBuilder(
        future: getPrediction(DateTime.now().year, DateTime.now().month, DateTime.now().day,DateTime.now().hour, DateTime.now().minute, 55),
        builder: (context, snapshot){
          if (snapshot.hasError)
            return new Text('Error: ${snapshot.error}');
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return new Center(
                child: new Text(
                  'Loading......',
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                    color: Colors.black,
                  ),
                ),
              );
            default:
              dynamic keys = snapshot.data.keys.toList();
              DateTime time = new DateTime.now();
              return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context, int index) {
                  final temp = snapshot.data[keys[index]].round().toString();
                  var newtime = time.add(new Duration(hours: 4* (index+1)));
                  var now = timePormat(
                      newtime.year, newtime.month, newtime.day, newtime.hour,
                      newtime.minute);
                  return Card(
                      color: Colors.deepOrange[400],
                      elevation: 10,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: new Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          new Column(
                            children: <Widget>[
                              SizedBox(height: 20,),
                              Text("Date Time",
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(height: 20,),
                              Text(
                                "Temperature",
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(height: 20,),
                              Text(
                                "Humidity",
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(height: 20,),
                            ],
                          ),


                          new Column(
                            children: <Widget>[
                              SizedBox(height: 20,),
                              Text(
                                now,
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(height: 20,),
                              Text(
                                '$temp *C',
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(height: 20,),
                              Text(
                                '55',
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(height: 20,),
                            ],
                          ),

                        ],
                      )
                  );
                },
              );
          }


        }
    );


  }

  dynamic timePormat(year,month,day,hour,minutes){
    return '$year-$month-$day $hour:$minutes';
  }

  Future getPrediction(year,month,day,hour,minute,humidity) async{

    final url = '$baseUrl/date/?name=$year,$month,$day,$hour,$minute,$humidity';
    final res = await http.get(url);
    if (res.statusCode != 200) {
      throw HTTPException(res.statusCode, "unable to fetch weather data");
    }
    return json.decode(res.body);

  }

}


//Fluttertoast.showToast(
//msg: key,
//toastLength: Toast.LENGTH_SHORT,
//gravity: ToastGravity.CENTER,
//timeInSecForIosWeb: 1,
//backgroundColor: Colors.red,
//textColor: Colors.white,
//fontSize: 16.0
//);