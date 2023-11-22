import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:loggy/loggy.dart';

class NetworkUtil {
  static bool lastNetworkCheck = false;

  static Future<bool> hasNetwork() async {
    try {
      // throw new Exception("Test Exception");
      final ConnectivityResult connectivityResult =
          await (Connectivity().checkConnectivity());
      lastNetworkCheck = connectivityResult == ConnectivityResult.wifi ||
          connectivityResult == ConnectivityResult.mobile;
    } catch (err) {
      logError(err);
      lastNetworkCheck = false;
    }
    return lastNetworkCheck;
  }
}
