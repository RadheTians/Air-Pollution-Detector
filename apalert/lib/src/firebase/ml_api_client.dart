import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:weather/src/api/http_exception.dart';


class MLApiClient {

  static const baseUrl = 'https://morning-scrubland-75035.herokuapp.com';
  final http.Client httpClient;

  MLApiClient(this.httpClient);

  Future<Map<String, dynamic>> getHomeMessage() async{

    final url = '$baseUrl';
    print('fetching $url');
    final res = await this.httpClient.get(url);
    if (res.statusCode != 200) {
      throw HTTPException(res.statusCode, "unable to fetch weather data");
    }
    final message = json.decode(res.body);
    return message;
  }

  Future<Map<String, dynamic>> getPrediction(year,month,day,hour,minute,humidity) async{

    final url = '$baseUrl/date/?name=$year,$month,$day,$hour,$minute,$humidity';
    print('fetching $url');
    final res = await this.httpClient.get(url);
    if (res.statusCode != 200) {
      throw HTTPException(res.statusCode, "unable to fetch weather data");
    }
    final predictionData = json.decode(res.body);
    return predictionData;
  }



}