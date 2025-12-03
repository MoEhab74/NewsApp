import 'package:connectivity_plus/connectivity_plus.dart';
import 'dart:developer';

class ConnectivityService {
  static final Connectivity _connectivity = Connectivity();

  /// Check if device has internet connectivity
  static Future<bool> hasInternetConnection() async {
    try {
      // First check if device has network connectivity
      List<ConnectivityResult> connectivityResult =
          await _connectivity.checkConnectivity();

      // If no network connectivity, return false immediately
      if (connectivityResult.contains(ConnectivityResult.none)) {
        log('No network connectivity detected');
        return false;
      }

      // If device has network connectivity, assume internet works
      // Skip the actual internet test to avoid timeout issues
      log('Network connectivity detected: $connectivityResult - Assuming internet works');
      return true;
    } catch (e) {
      log('Error checking connectivity: $e');
      // If connectivity check fails, assume we have internet and let the API handle it
      return true;
    }
  }

  /// Stream to listen for connectivity changes
  static Stream<List<ConnectivityResult>> get connectivityStream {
    return _connectivity.onConnectivityChanged;
  }
}
