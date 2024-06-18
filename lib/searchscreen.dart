import 'package:flutter/material.dart';
import 'main_weather_screen.dart';
import 'weather_provider.dart';

class WeatherScreen extends StatefulWidget {
  @override
  _WeatherScreenState createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  TextEditingController _searchController = TextEditingController();
  List<String> searchedCities = [];

  // Dummy data for home location weather
  double homeLocationTemperature = 25.0;
  String homeLocationWeather = "Sunny";

  @override
  Widget build(BuildContext context) {
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
            Text(
              'Home Location',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text('Temperature: $homeLocationTemperature°C'),
            Text('Weather: $homeLocationWeather'),
            SizedBox(height: 20),
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
                    setState(() {
                      searchedCities.add(query);
                    });
                    _searchController.clear();
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
                  width: double.infinity, // Adjust the width to 80% of the screen width
                  child: ElevatedButton(
                    onPressed: () {
                      // Handle button press, e.g., navigate to detailed weather screen for the selected city
                      Navigator.push(
                        context,
                        MaterialPageRoute(

                          builder: (context) => MainWeatherScreen(loadLocation: city), // Navigate to MainWeatherScreen
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
    home: WeatherScreen(),
  ));
}
