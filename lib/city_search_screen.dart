import 'package:flutter/material.dart';
import 'main_weather_screen.dart';
import 'weather_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';

class WeatherScreen extends StatefulWidget {
  @override
  _WeatherScreenState createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  TextEditingController _searchController = TextEditingController();
  List<String> searchedCities = [];
  String? _homeLocationWeather;
  double? _homeLocationTemperature;
  String? _homeLocationName;

  @override
  void initState() {
    super.initState();
    // Initialize variables
    _homeLocationName = '';
    _homeLocationTemperature = 0.0;
    _homeLocationWeather = '';
    searchedCities = [];
    _loadHomeLocation();
  }

  _loadHomeLocation() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? homeLocation = prefs.getString('location') ?? 'New York';
    setState(() {
      _homeLocationName = homeLocation;
    });
    if (!_isCityAlreadySearched(homeLocation)) {
      _searchWeather(homeLocation);
    }
  }

  _searchWeather(String query) {
    if (query.isNotEmpty) {
      Provider.of<WeatherProvider>(context, listen: false).fetchWeather(query);
      setState(() {
        if(_homeLocationName!=query){
          searchedCities.add(query);}
      });
      _searchController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    var weatherProvider = Provider.of<WeatherProvider>(context);
    var weatherData = weatherProvider.weatherData;

    if (weatherData != null) {
      setState(() {
        _homeLocationTemperature = weatherData['main']['temp'];
        _homeLocationWeather = weatherData['weather'][0]['main'];
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Weather Information'),
      ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Display home location weather
            if (_homeLocationTemperature != null &&
                _homeLocationWeather != null) ...[
              Text(
                '$_homeLocationName',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text('Temperature: $_homeLocationTemperature°C'),
              Text('Weather: $_homeLocationWeather'),
              SizedBox(height: 20),
            ],
            // Search bar
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      labelText: 'Enter a city name',
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            // Search button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  String query = _searchController.text.trim();
                  if (query.isNotEmpty && !_isCityAlreadySearched(query)) {
                    _searchWeather(query);
                  }
                },
                child: Text('Search'),
              ),
            ),
            SizedBox(height: 20),
            // Display searched cities as buttons
            Wrap(
              spacing: 8.0,
              runSpacing: 8.0,
              children: searchedCities.map((city) {
                return SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MainWeatherScreen(
                            loadLocation: city,
                          ),
                        ),
                      );
                    },
                    child: Text(city),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  // Check if the city is already searched
  bool _isCityAlreadySearched(String city) {
    return searchedCities.contains(city);
  }
}

void main() {
  runApp(MaterialApp(
    home: MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => WeatherProvider()),
      ],
      child: WeatherScreen(),
    ),
  ));
}
