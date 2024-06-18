import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:material_floating_search_bar_2/material_floating_search_bar_2.dart';
import 'detail_weather_screen.dart';
import 'weather_provider.dart';
import 'package:provider/provider.dart';
import 'city_search_screen.dart';

class MainWeatherScreen extends StatefulWidget {
  final String? loadLocation;

  MainWeatherScreen({this.loadLocation});

  @override
  _MainWeatherScreenState createState() => _MainWeatherScreenState();
}

class _MainWeatherScreenState extends State<MainWeatherScreen> {
  final FloatingSearchBarController _searchController = FloatingSearchBarController();
  String _homeLocation = '';
  DateTime _currentDateTime = DateTime.now();

  @override
  void initState() {
    super.initState();
    if (widget.loadLocation != null) {
      _homeLocation = widget.loadLocation!;
      _loadWeatherData();
    } else {
      _loadHomeLocation();
    }
  }

  _loadHomeLocation() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _homeLocation = prefs.getString('location') ?? 'New York';
    });
    Provider.of<WeatherProvider>(context, listen: false).fetchWeather(_homeLocation);
  }

  _loadWeatherData() {
    Provider.of<WeatherProvider>(context, listen: false).fetchWeather(_homeLocation);
  }

  _searchWeather(String query) {
    if (query.isNotEmpty) {
      Provider.of<WeatherProvider>(context, listen: false).fetchWeather(query);
      _homeLocation = query;
    }
  }

  @override
  Widget build(BuildContext context) {
    var weatherData = Provider.of<WeatherProvider>(context).weatherData;

    return Scaffold(
      backgroundColor: Colors.blue,
      body:
      Column(

        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  FloatingSearchAppBar(
                    title: Text(
                      DateFormat('MMMM d, yyyy  h:mm a').format(_currentDateTime),
                      style: TextStyle(fontFamily: 'NotoSans', fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                    hint: 'Search...',
                    controller: _searchController,
                    onSubmitted: _searchWeather,
                    body: Padding(
                      padding: EdgeInsets.only(left: 13.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 10),
                          Padding(padding: EdgeInsets.only(top: 30)),
                          Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  _homeLocation,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                                ),
                                SizedBox(height: 10),
                                weatherData != null
                                    ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    _buildWeatherImage('${weatherData['weather'][0]['main']}'),
                                    SizedBox(height: 5),
                                    Text(
                                      '${weatherData['main']['temp']}°',
                                      style: TextStyle(
                                        fontFamily: 'Quicksand',
                                        fontSize: 70,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    SizedBox(height: 10),
                                    Text(
                                      '${weatherData['weather'][0]['main']}',
                                      style: TextStyle(
                                        fontFamily: 'NotoSans',
                                        fontWeight: FontWeight.bold,
                                        fontSize: 25,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    SizedBox(height: 10),
                                    Text(
                                      'H: ${weatherData['main']['temp_max']}°  L: ${weatherData['main']['temp_min']}°',
                                      style: TextStyle(
                                        fontFamily: 'NotoSans',
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    SizedBox(height: 20),
                                    SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        children: [
                                          _buildWeatherDetail('Humidity', '${weatherData['main']['humidity']}%', Icons.water_drop),
                                          _buildWeatherDetail('Pressure', '${weatherData['main']['pressure']} hPa', Icons.speed),
                                          _buildWeatherDetail('Wind Speed', '${weatherData['wind']['speed']} m/s', Icons.air),
                                        ],
                                      ),
                                    ),
                                  ],
                                )
                                    : CircularProgressIndicator(),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    actions: [
                      FloatingSearchBarAction.searchToClear(),
                      FloatingSearchBarAction.icon(
                        icon: Icons.menu,
                        onTap: () {
                          // Handle menu button press
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeatherImage(String weatherType) {
    String imagePath = '';
    switch (weatherType) {
      case 'Clear':
        imagePath = 'assets/sunny.png';
        break;
      case 'Clouds':
        imagePath = 'assets/clouds.png';
        break;
      case 'Rain':
        imagePath = 'assets/rainy.png';
        break;
    // Add more cases as needed for different weather types
      default:
        imagePath = 'assets/clear.png';
    }
    return SizedBox(
      width: 200.0,
      height: 200.0,
      child: Image.asset(imagePath,
        fit: BoxFit.cover,),
    );
  }

  Widget _buildWeatherDetail(String label, String value, IconData iconData) {
    return Container(
      width: 100,
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisSize:
        MainAxisSize.min,
        children: [
          Icon(iconData),
          SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(
            value,
            style: TextStyle(fontSize: 14),
          ),
        ],
      ),
    );
  }
}
