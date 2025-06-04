import 'package:geolocator/geolocator.dart';

class Locationservice {
  late bool serviceEnabled;
  late LocationPermission permission;
  Future<Position> determinePosition() async {
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      print("Location is not enabled");
      return Future.error("Location is disabled");
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      print("location permissions are not granted will request them now");
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error("Location permissions are denied");
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error("Location denied permanently");
    }
    return await Geolocator.getCurrentPosition();
  }
}
