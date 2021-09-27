import 'package:connectivity/connectivity.dart';

abstract class NetworkInfo {
  Future<bool> get isConnected;
}

class NetworkImpl implements NetworkInfo {
  final Connectivity connectivity;

  NetworkImpl(this.connectivity);

  @override
  Future<bool> get isConnected async {
    var mobileConnected = await connectivity.checkConnectivity();
    if (mobileConnected == ConnectivityResult.mobile || mobileConnected == ConnectivityResult.wifi) {
      return true;
    }

    return false;
  }
}