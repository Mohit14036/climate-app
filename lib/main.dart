
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'user_profile_screen.dart';
import 'main_weather_screen.dart';
import 'weather_provider.dart';
import 'nav_at_start.dart';
import 'city_search_screen.dart';
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => WeatherProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Weather App',
        theme: ThemeData.light(),
        darkTheme: ThemeData.dark(),
        themeMode: ThemeMode.system,
        home: NavAtStart(),
        routes: {
          '/user-profile': (context) => UserProfileScreen(),
          '/weather': (context) => MainWeatherScreen(),
          '/search-screen':(context) => WeatherScreen(),
        },
      ),
    );
  }
}
