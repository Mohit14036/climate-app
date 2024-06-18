import 'package:climate_app/city_search_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'main_weather_screen.dart';
import 'user_profile_screen.dart';

class NavAtStart extends StatefulWidget {
  @override
  _NavAtStartState createState() => _NavAtStartState();
}

class _NavAtStartState extends State<NavAtStart> {
  @override
  void initState() {
    super.initState();
    _navigateToNextScreen();
  }

  _navigateToNextScreen() async {
    await Future.delayed(Duration(seconds: 2), () {});

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? name = prefs.getString('name');
    String? email = prefs.getString('email');
    String? location = prefs.getString('location');

    if (name != null && email != null && location != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => WeatherScreen()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => UserProfileScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FlutterLogo(size: 100),
      ),
    );
  }
}
