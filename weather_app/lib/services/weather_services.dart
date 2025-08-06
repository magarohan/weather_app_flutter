import 'dart:convert';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart'
    as http;
import 'package:weather_app/models/weather_model.dart';

class WeatherService {
  static const String
  baseUrl =
      'https://api.openweathermap.org/data/2.5/';
  final String
  apiKey;

  WeatherService(
    this.apiKey,
  );

  Future<
    Weather
  >
  getWeather(
    String
    cityName,
  ) async {
    final response = await http.get(
      Uri.parse(
        '${baseUrl}weather?q=$cityName&appid=$apiKey&units=metric',
      ),
    );

    if (response.statusCode ==
        200) {
      return Weather.fromJson(
        json.decode(
          response.body,
        ),
      );
    } else {
      throw Exception(
        'Failed to load weather data',
      );
    }
  }

  Future<
    String
  >
  getCurrentCity() async {
    try {
      LocationPermission
      permission = await Geolocator.checkPermission();
      if (permission ==
          LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission ==
            LocationPermission.denied) {
          return 'Permission Denied';
        }
      }

      Position
      position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      List<
        Placemark
      >
      placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      return placemarks[0].locality ??
          'Unknown City';
    } catch (
      e
    ) {
      print(
        'Error getting city: $e',
      );
      return 'Unknown City';
    }
  }
}
