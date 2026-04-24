import 'package:geolocator/geolocator.dart';

class LocationService {

  static Future<String> getLocationLink() async {
    try {

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

      // 🔥 STEP 3: Force high accuracy (IMPORTANT FIX)
      await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      // 🔥 STEP 4: Get LAST KNOWN first (fast + stable)
      Position? lastPosition = await Geolocator.getLastKnownPosition();

      if (lastPosition != null) {
        return _buildMapLink(lastPosition);
      }

      // 🔥 STEP 5: REAL-TIME LOCATION fallback
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