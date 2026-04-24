import 'package:geolocator/geolocator.dart';
import 'package:flutter/foundation.dart';

class LocationService {

  static Future<String> getLocationLink() async {
    try {

      // 🌐 WEB HANDLING
      if (kIsWeb) {
        // Web supports geolocation but needs permission via browser
        Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
        );

        return _buildMapLink(position);
      }

      // 📱 MOBILE FLOW

      // 🔥 STEP 1: Check GPS
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return "❌ Turn ON GPS/Location";
      }

      // 🔥 STEP 2: Permission check
      LocationPermission permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied) {
        return "❌ Location permission denied";
      }

      if (permission == LocationPermission.deniedForever) {
        return "❌ Permission permanently denied (go to settings)";
      }

      // 🔥 STEP 3: Get location
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      return _buildMapLink(position);

    } catch (e) {
      return "❌ Location error: $e";
    }
  }

  // 🌍 helper function
  static String _buildMapLink(Position position) {
    return "https://maps.google.com/?q=${position.latitude},${position.longitude}";
  }
}