import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class WeatherProvider with ChangeNotifier {
  Map<String, dynamic>? _weatherData;
  List<dynamic>? _hourlyForecast;

  Map<String, dynamic>? get weatherData => _weatherData;
  List<dynamic>? get hourlyForecast => _hourlyForecast;

  Future<void> fetchWeather(String city) async {
    final apiKey = 'ad387776aa5773041941d73df29fa5be'; // Replace with your OpenWeatherMap API key
    final url = 'https://api.openweathermap.org/data/2.5/weather?q=$city&appid=$apiKey&units=metric';

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      _weatherData = json.decode(response.body);
      notifyListeners();
    } else {
      throw Exception('Failed to load weather data');
    }
  }



  }

