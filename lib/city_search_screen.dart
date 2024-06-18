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
        if (_homeLocationName != query) {
          searchedCities.add(query);
        }
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
        if(_homeLocationWeather==''){
        _homeLocationTemperature = weatherData['main']['temp'];
        _homeLocationWeather = weatherData['weather'][0]['main'];}
      });
    }

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus(); // Dismiss keyboard
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'CITIES',
            style: TextStyle(fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Display home location weather
                if (_homeLocationTemperature != null &&
                    _homeLocationWeather != null)
                  ...[
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            '$_homeLocationName',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 25,
                            ),
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              ' $_homeLocationTemperature°C',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 25,
                              ),
                            ),
                            Text(
                              '$_homeLocationWeather',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 25,
                              ),
                            ),
                            SizedBox(height: 20),
                          ],
                        ),
                      ],
                    ),
                  ],
                // Search bar
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _searchController,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
                            labelText: 'Enter a city name',
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.search),
                        onPressed: () {
                          String query = _searchController.text.trim();
                          if (query.isNotEmpty && !_isCityAlreadySearched(query)) {
                            _searchWeather(query);
                          }
                        },
                      ),
                    ],
                  ),
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
                                searchedCities: searchedCities,
                              ),
                            ),
                          );
                        },
                        child: Text(city,style: TextStyle(color: Colors.white),),
                        style: ElevatedButton.styleFrom(
                           overlayColor: Colors.blue,
                          backgroundColor: Colors.lightBlue,// Text color
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Check if the city is already searched
  bool _isCityAlreadySearched(String city) {
    return searchedCities.contains(city);
  }
}
