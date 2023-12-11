
import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
class Connectivity_provider extends ChangeNotifier{

  Future<bool> isOnlineNet() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      return true;
    } else {
      return false;
    }
  }
}