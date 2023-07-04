import 'package:flutter/material.dart';
import 'package:uas/models/weather.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CurrentWeatherPage extends StatefulWidget {
  @override
  _CurrentWeatherPageState createState() => _CurrentWeatherPageState();
}

class _CurrentWeatherPageState extends State<CurrentWeatherPage> {
  late Weather _weather;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FutureBuilder(
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              _weather = snapshot.data as Weather;
              // ignore: unnecessary_null_comparison
              if (_weather == null) {
                return Text("Error getting weather");
              } else {
                return weatherBox(_weather);
              }
            } else if (snapshot.hasError) {
              return Text("Error: ${snapshot.error}");
            } else {
              return CircularProgressIndicator();
            }
          },
          future: getCurrentWeather(),
        ),
      ),
    );
  }
}

Widget weatherBox(Weather _weather) {
  return Column(
    mainAxisSize: MainAxisSize.min,
    children: <Widget>[
      Container(
        margin: const EdgeInsets.all(10.0),
        child: Text(
          "${_weather.temp}°C",
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 55),
        ),
      ),
      Container(
        margin: const EdgeInsets.all(5.0),
        child: Text("${_weather.description}"),
      ),
      Container(
        margin: const EdgeInsets.all(5.0),
        child: Text("Feels:${_weather.feelsLike}°C"),
      ),
      Container(
        margin: const EdgeInsets.all(5.0),
        child: Text("H:${_weather.high}°C L:${_weather.low}°C"),
      ),
    ],
  );
}

Future<Weather> getCurrentWeather() async {
  String CITY_NAME = "Jakarta";
  String API_KEY = "517fa57ab981c9107a1da4e35022743c";
  var url =
      "https://api.openweathermap.org/data/2.5/weather?q={$CITY_NAME}&appid={$API_KEY}";

  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    return Weather.fromJson(jsonDecode(response.body));
  } else {
    throw Exception("Failed to get weather data");
  }
}
