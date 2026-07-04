import 'package:permission_handler/permission_handler.dart';

class PermissionUtils {
  static Future<bool> requestLocationPermission() async {
    final status = await Permission.location.request();
    return status.isGranted;
  }

  static Future<bool> requestCameraPermission() async {
    final status = await Permission.camera.request();
    return status.isGranted;
  }

  static Future<bool> requestGalleryPermission() async {
    final status = await Permission.photos.request();
    return status.isGranted;
  }

  static Future<bool> requestStoragePermission() async {
    final status = await Permission.storage.request();
    return status.isGranted;
  }

  static Future<bool> requestNotificationPermission() async {
    final status = await Permission.notification.request();
    return status.isGranted;
  }

  static Future<bool> isLocationGranted() async {
    return await Permission.location.isGranted;
  }

  static Future<bool> isCameraGranted() async {
    return await Permission.camera.isGranted;
  }

  static Future<bool> isGalleryGranted() async {
    return await Permission.photos.isGranted;
  }

  static Future<bool> isStorageGranted() async {
    return await Permission.storage.isGranted;
  }

  static Future<bool> requestMultiplePermissions(List<Permission> permissions) async {
    final results = await permissions.request();
    return results.values.every((status) => status.isGranted);
  }
}
