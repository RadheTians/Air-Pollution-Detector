import 'package:flutter/material.dart';
import 'dart:async';
import 'package:weather/weather_library.dart';

enum AppState { NOT_DOWNLOADED, DOWNLOADING, FINISHED_DOWNLOADING }


class WeatherAPI extends StatefulWidget {
  @override
  _WeatherAPIState createState() => _WeatherAPIState();
}

class _WeatherAPIState extends State<WeatherAPI> {
  String key = '856822fd8e22db5e1ba48c0e7d69844a';
  WeatherStation ws;
  List<Weather> _data = [];
  AppState _state = AppState.NOT_DOWNLOADED;
  double lat, lon;

  @override
  void initState() {
    super.initState();
    ws = new WeatherStation(key);
  }

  void queryForecast() async {
    /// Removes keyboard
    FocusScope.of(context).requestFocus(FocusNode());
    setState(() {
      _state = AppState.DOWNLOADING;
    });

    List<Weather> forecasts = await ws.fiveDayForecast(lat, lon);
    setState(() {
      _data = forecasts;
      _state = AppState.FINISHED_DOWNLOADING;
    });
  }

  void queryWeather() async {
    /// Removes keyboard
    FocusScope.of(context).requestFocus(FocusNode());

    setState(() {
      _state = AppState.DOWNLOADING;
    });

    Weather weather = await ws.currentWeather(lat, lon);
    setState(() {
      _data = [weather];
      _state = AppState.FINISHED_DOWNLOADING;
    });
  }

  Widget contentFinishedDownload() {
    return Center(
      child: ListView.separated(
        itemCount: _data.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(_data[index].toString()),
          );
        },
        separatorBuilder: (context, index) {
          return Divider();
        },
      ),
    );
  }

  Widget contentDownloading() {
    return Container(
        margin: EdgeInsets.all(25),
        child: Column(children: [
          Text(
            'Fetching Weather...',
            style: TextStyle(fontSize: 20),
          ),
          Container(
              margin: EdgeInsets.only(top: 50),
              child: Center(child: CircularProgressIndicator(strokeWidth: 10)))
        ]));
  }

  Widget contentNotDownloaded() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'Press the button to download the Weather forecast',
          ),
        ],
      ),
    );
  }

  Widget _resultView() => _state == AppState.FINISHED_DOWNLOADING
      ? contentFinishedDownload()
      : _state == AppState.DOWNLOADING
      ? contentDownloading()
      : contentNotDownloaded();

  void _saveLat(String input) {
    lat = double.tryParse(input);
    print(lat);
  }

  void _saveLon(String input) {
    lon = double.tryParse(input);
    print(lon);
  }

  Widget _latTextField() {
    return Container(
        decoration: BoxDecoration(
            border: Border(
                bottom: BorderSide(color: Theme.of(context).dividerColor))),
        padding: EdgeInsets.all(10),
        child: TextField(
            decoration: InputDecoration(
                border: OutlineInputBorder(), hintText: 'Enter longitude'),
            keyboardType: TextInputType.number,
            onChanged: _saveLat,
            onSubmitted: _saveLat));
  }

  Widget _lonTextField() {
    return Container(
        decoration: BoxDecoration(
            border: Border(
                bottom: BorderSide(color: Theme.of(context).dividerColor))),
        padding: EdgeInsets.all(10),
        child: TextField(
            decoration: InputDecoration(
                border: OutlineInputBorder(), hintText: 'Enter longitude'),
            keyboardType: TextInputType.number,
            onChanged: _saveLon,
            onSubmitted: _saveLon));
  }

  Widget _weatherButton() {
    return  new Container(
      width: 288.0,
      child: ButtonTheme(
        height: 40.0,
        minWidth: 100,
        buttonColor: Colors.deepOrange[400],
        child: RaisedButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            onPressed: queryWeather,
            child: Center(
              child: Text(
                'Fetch Weather',
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.white,
                ),
              ),
            )),
      ),
    );
  }

  Widget _forecastButton() {
    return new Container(
      width: 288.0,
      child: ButtonTheme(
        height: 40.0,
        minWidth: 100,
        buttonColor: Colors.deepOrange[400],
        child: RaisedButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            onPressed: queryForecast,
            child: Center(
              child: Text(
                'Fetch Forecast',
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.white,
                ),
              ),
            )),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text('Weather API Data'),
        ),
        body: Column(
          children: <Widget>[
            _latTextField(),
            _lonTextField(),
            _weatherButton(),
            _forecastButton(),
            Text(
              'Output:',
              style: TextStyle(fontSize: 20),
            ),
            Divider(
              height: 20.0,
              thickness: 2.0,
            ),
            Expanded(child: _resultView())
          ],
        )
    );
  }
}