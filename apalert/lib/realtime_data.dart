

import 'package:apalert/features.dart';
import 'package:apalert/model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RealTimeData extends StatefulWidget {
  @override
  _RealTimeDataState createState() => _RealTimeDataState();
}

class _RealTimeDataState extends State<RealTimeData> {

  final _database = Firestore.instance.collection('coliberation');
  List<Model> _documents = new List();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //_cloudStoreData();

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Real Time Data'),
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _database.snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
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
              return ListView.builder(
                  shrinkWrap: true,
                  itemCount: snapshot.data.documents.length,
                  itemBuilder: (BuildContext context, int index) {
                    double CO = snapshot.data.documents[index]['CO'];
                    double CO2 = snapshot.data.documents[index]['CO2'];
                    double LPG = snapshot.data.documents[index]['LPG'];
                    double smoke = snapshot.data.documents[index]['smoke'];
                    double airquality = snapshot.data.documents[index]['airquality'];
                    double NH4 = snapshot.data.documents[index]['NH4'];
                    double temperature = snapshot.data.documents[index]['temperature'];
                    double humidity = snapshot.data.documents[index]['humidity'];
                    var newtime = snapshot.data.documents[index]['time'].toDate();
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
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            layout("Temperature",temperature, "Date Time", now, "Humidity", humidity),
                            //SizedBox(height: 20,),
                            layout("Air Quality", airquality, "CO2", CO2, "CO", CO),
                            //SizedBox(height: 20,),
                            layout("NH4",NH4, "LPG", LPG, "Smoke", smoke),

                          ],
                        )
                    );

                  });
          }
        },
      ),
    );
  }



  dynamic timePormat(year,month,day,hour,minutes){
    return '$year-$month-$day $hour:$minutes';
  }


  Widget layout(title1,text1,title2,text2,title3,text3){
    return new Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        SizedBox(height: 20,),
        Text(
          title1,
          style: new TextStyle(
            color: Colors.white,
            fontSize: 20,
          ),
        ),
        SizedBox(height: 5,),
        Text(
          text1.toString(),
          style: new TextStyle(
            color: Colors.white,
            fontSize: 15,
          ),
        ),
        SizedBox(height: 20,),
        Text(
          title2,
          style: new TextStyle(
            color: Colors.white,
            fontSize: 20,
          ),
        ),
        SizedBox(height: 5,),
        Text(
          text2.toString(),
          style: new TextStyle(
            color: Colors.white,
            fontSize: 15,
          ),
        ),
        SizedBox(height: 20,),
        Text(
          title3,
          style: new TextStyle(
            color: Colors.white,
            fontSize: 20,
          ),
        ),
        SizedBox(height: 5,),
        Text(
          text3.toString(),
          style: new TextStyle(
            color: Colors.white,
            fontSize: 15,
          ),
        ),
        SizedBox(height: 20,),

      ],
    );
  }

}
