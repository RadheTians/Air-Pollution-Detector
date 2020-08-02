
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:weather/src/model/todo.dart';

class Graph extends StatefulWidget{

  final List<Todo> _todoList;

  Graph(this._todoList);

  @override
  State<StatefulWidget> createState() => _GarphState();

}

class _GarphState extends State<Graph>{

  @override
  Widget build(BuildContext context) {

    return new Scaffold(
        appBar: new AppBar(
          title: new Text('Graph Analysis'),
        ),
        body: charts.LineChart(_createSampleData(),
        animate: true,
        defaultRenderer: new charts.LineRendererConfig(includePoints: true)),
       
        );
  }

  List<charts.Series<LinearSales, int>> _createSampleData() {

    final data = [
      new LinearSales(0, 5),
      new LinearSales(1, 25),
      new LinearSales(2, 100),
      new LinearSales(3, 75),
    ];

     final data1 = [
      new LinearSales(0, 15),
      new LinearSales(1, 45),
      new LinearSales(2, 90),
      new LinearSales(3, 35),
    ];
    
    List<LinearSales> temp = new List();
    var i = 1;
    for (var item in widget._todoList) {
      temp.add(new LinearSales(i, item.temperature));
      i++;
    }
    
  

    List<LinearSales> humidity = new List();
    i = 1;
    for (var item in widget._todoList) {
      humidity.add(new LinearSales(i, item.humidity));
      i++;
    }

    return [
      new charts.Series<LinearSales, int>(
        id: 'Temperature',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (LinearSales sales, _) => sales.year,
        measureFn: (LinearSales sales, _) => sales.sales,
        data: temp,
      ),
      new charts.Series<LinearSales, int>(
        id: 'Humidity',
        colorFn: (_, __) => charts.MaterialPalette.red.shadeDefault,
        domainFn: (LinearSales sales, _) => sales.year,
        measureFn: (LinearSales sales, _) => sales.sales,
        data: humidity,
      ),
      
    ];
  }

}

/// Sample linear data type.
class LinearSales {
  final int year;
  final double sales;

  LinearSales(this.year, this.sales);
}