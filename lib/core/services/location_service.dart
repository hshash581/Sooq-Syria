import 'package:geolocator/geolocator.dart';

class LocationService {
  static final LocationService _instance = LocationService._internal();
  factory LocationService() => _instance;
  LocationService._internal();

  Future<bool> requestPermission() async {
    final permission = await Geolocator.requestPermission();
    return permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always;
  }

  Future<bool> isPermissionGranted() async {
    final permission = await Geolocator.checkPermission();
    return permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always;
  }

  Future<Position?> getCurrentPosition() async {
    try {
      final permission = await requestPermission();
      if (!permission) return null;
      return await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 30),
        ),
      );
    } catch (e) {
      return null;
    }
  }

  Future<String?> getAddressFromLatLng(double latitude, double longitude) async {
    return null;
  }

  Future<Map<String, dynamic>> getLocationData() async {
    final position = await getCurrentPosition();
    if (position == null) return {};
    final address = await getAddressFromLatLng(
      position.latitude,
      position.longitude,
    );
    return {
      'latitude': position.latitude,
      'longitude': position.longitude,
      'address': address ?? '',
    };
  }
}
