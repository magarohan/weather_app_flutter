import 'package:flutter/material.dart';
import 'package:weather_app/models/weather_model.dart';
import 'package:weather_app/services/weather_services.dart';

class WeatherPage
    extends
        StatefulWidget {
  const WeatherPage({
    super.key,
  });

  @override
  State<
    WeatherPage
  >
  createState() =>
      _WeatherPageState();
}

class _WeatherPageState
    extends
        State<
          WeatherPage
        > {
  final _weatherService = WeatherService(
    '501ab99f2d94d7d934e7784214924d75',
  );
  Weather?
  _weather;
  bool
  _isLoading =
      true;
  String?
  _errorMessage;

  Future<
    void
  >
  _fetchWeather() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      String
      cityName = await _weatherService.getCurrentCity();

      if (cityName ==
              'Unknown City' ||
          cityName ==
              'Permission Denied') {
        setState(
          () {
            _errorMessage = 'Could not determine your location. Please enable location services and try again.';
          },
        );
        return;
      }

      final weather = await _weatherService.getWeather(
        cityName,
      );

      setState(
        () {
          _weather = weather;
        },
      );
    } catch (
      e
    ) {
      setState(
        () {
          _errorMessage = 'An error occurred while fetching weather data.\n$e';
        },
      );
    } finally {
      setState(
        () {
          _isLoading = false;
        },
      );
    }
  }

  @override
  void
  initState() {
    super.initState();
    _fetchWeather();
  }

  @override
  Widget
  build(
    BuildContext
    context,
  ) {
    return Scaffold(
      backgroundColor: Colors.blueAccent,
      body: Center(
        child: _isLoading
            ? const CircularProgressIndicator(
                color: Colors.white,
              )
            : _errorMessage !=
                  null
            ? Padding(
                padding: const EdgeInsets.all(
                  16.0,
                ),
                child: Text(
                  _errorMessage!,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                  textAlign: TextAlign.center,
                ),
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _weather!.cityName,
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Text(
                    '${_weather!.temperature.round()} °C',
                    style: const TextStyle(
                      fontSize: 24,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Text(
                    _weather!.mainCondition,
                    style: const TextStyle(
                      fontSize: 20,
                      color: Colors.white70,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ElevatedButton.icon(
                    onPressed: _fetchWeather,
                    icon: const Icon(
                      Icons.refresh,
                    ),
                    label: const Text(
                      "Refresh",
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.blueAccent,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
