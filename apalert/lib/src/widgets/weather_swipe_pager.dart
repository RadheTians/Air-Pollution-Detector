import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:weather/main.dart';
import 'package:weather/src/model/weather.dart';
import 'package:weather/src/widgets/current_conditions.dart';
import 'package:weather/src/widgets/empty_widget.dart';
import 'package:weather/src/widgets/temperature_line_chart.dart';

class WeatherSwipePager extends StatelessWidget {
  const WeatherSwipePager({
    Key key,
    @required this.weather,
  }) : super(key: key);

  final Weather weather;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 300,
      child: Swiper(
        itemCount: 2,
        index: 0,
        itemBuilder: (context, index) {
          if (index == 0) {
            return CurrentConditions(
              weather: weather,
            );
          } else if (index == 1) {
            return TemperatureLineChart(
              weather.forecast,
              animate: true,
            );
          }
          return EmptyWidget();
        },
        pagination: new SwiperPagination(
            margin: new EdgeInsets.all(5.0),
            builder: new DotSwiperPaginationBuilder(
                size: 5,
                activeSize: 5,
                color: AppStateContainer.of(context)
                    .theme
                    .accentColor
                    .withOpacity(0.4),
                activeColor:
                AppStateContainer.of(context).theme.accentColor)),
      ),
    );
  }
}
