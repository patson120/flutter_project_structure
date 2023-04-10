import 'package:connectivity_plus/connectivity_plus.dart';

class CheckConnectivityPlus {
  // class permettant de vérifier si le téléphone de l'utilisateur a la connexion internet ou non
  static Future<bool> isInternetConnection() async {
    ConnectivityResult connectivityResult =
        await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.wifi ||
        connectivityResult == ConnectivityResult.mobile) {
      return true;
    }
    return false;
  }
}
