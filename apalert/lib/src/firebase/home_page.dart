

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:weather/src/model/todo.dart';

class RealTimeData extends StatefulWidget{


  @override
  State<StatefulWidget> createState() => new _RealTimeDataState();

}

class _RealTimeDataState extends State<RealTimeData> {

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  final Firestore _database = Firestore.instance;
  List<Todo> _todoList;

 
  @override
  Widget build(BuildContext context) {
    
    return new Scaffold(
        appBar: new AppBar(
          title: new Text('Real Time data of Imphal'),
          actions: <Widget>[
            new FlatButton(
                child: new Text('MainPage',
                    style: new TextStyle(
                        fontSize: 17.0,
                        color: Colors.white
                    ),
                ),
                onPressed: _showNotificationWithDefaultSound,
            )
          ],
        ),
        backgroundColor: Colors.red,
        body: StreamBuilder<QuerySnapshot>(
          stream: _database.collection('coliberation').snapshots(),
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError)
              return new Text('Error: ${snapshot.error}');
            switch (snapshot.connectionState) {
              case ConnectionState.waiting: return new Text('Loading...');
              default:
                return ListView.builder(
                    shrinkWrap: true,
                    itemCount: snapshot.data.documents.length,
                    itemBuilder: (BuildContext context, int index) {
                      double todoId = snapshot.data.documents[index]['CO'];
                      double temperature = snapshot.data.documents[index]['temperature'];
                      double humidity = snapshot.data.documents[index]['humidity'];
                      dynamic time = snapshot.data.documents[index]['time'].toDate();
                      return Card(
                          color: Colors.red,
                          elevation: 10,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          child: new Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              layout("Temperature",temperature, "Time", time, "Humidity", humidity),
                              //SizedBox(height: 20,),
                              layout("Air Quality", temperature, "CO2", humidity, "CO", todoId),
                              //SizedBox(height: 20,),
                              layout("NH4",temperature, "LPG", humidity, "Smoke", todoId),

                            ],
                          )
                      );

                    });
            }
          },
        ),
       
        );

  }

  @override
  void initState() {
    super.initState();
    var initializationSettingsAndroid = new AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettingsIOS = new IOSInitializationSettings();
    var initializationSettings = new InitializationSettings(initializationSettingsAndroid, initializationSettingsIOS);
    flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
    flutterLocalNotificationsPlugin.initialize(initializationSettings, onSelectNotification: SelectNotification);
    _todoList = new List();
    _database.collection("coliberation").orderBy("time").limit(10).getDocuments().then((QuerySnapshot snapshot) {
      snapshot.documents.forEach((f) => _todoList.add(Todo.fromSnapshot(f.data)));
    });


  }

  Future SelectNotification(String payload) async {
    showDialog(
      context: context,
      builder: (_) {
        return new AlertDialog(
          title: Text("PayLoad"),
          content: Text("Payload : $payload"),
        );
      },
    );
  }

  Future _showNotificationWithDefaultSound() async {
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
        'your channel id', 'your channel name', 'your channel description',
        importance: Importance.Max, priority: Priority.High);
    var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
    var platformChannelSpecifics = new NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      0,
      'New Post',
      'How to Show Notification in Flutter',
      platformChannelSpecifics,
      payload: 'Default_Sound',
    );
  }


  Widget showTodoList() {

    if(_todoList.length > 0){

      return ListView.builder(
        shrinkWrap: true,
        itemCount: _todoList.length,
        itemBuilder: (BuildContext context, int index) {
          double todoId = _todoList[index].CO;
          double temperature = _todoList[index].temperature;
          double humidity = _todoList[index].humidity;
          dynamic time = _todoList[index].time.toDate();
          return Card(
            color: Colors.red,
            elevation: 10,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: new Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                layout("Temperature",temperature, "Time", time, "Humidity", humidity),
                //SizedBox(height: 20,),
                layout("Air Quality", temperature, "CO2", humidity, "CO", todoId),
                //SizedBox(height: 20,),
                layout("NH4",temperature, "LPG", humidity, "Smoke", todoId),

              ],
            )
          );

        });

    }

  }



  Widget layout(title1,text1,title2,text2,title3,text3){
    return new Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        SizedBox(height: 20,),
        Text(
          title1.toString(),
          style: new TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
            fontFamily: 'Sf Pro',
          ),
        ),
        SizedBox(height: 5,),
        Text(
          text1.toString(),
          style: new TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 20,),
        Text(
          title2,
          style: new TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
            fontFamily: 'Sf Pro',
          ),
        ),
        SizedBox(height: 5,),
        Text(
          text2.toString(),
          style: new TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 20,),
        Text(
          title3.toString(),
          style: new TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
            fontFamily: 'Sf Pro',
          ),
        ),
        SizedBox(height: 5,),
        Text(
          text3.toString(),
          style: new TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 20,),

      ],
    );
  }

}

  
   

