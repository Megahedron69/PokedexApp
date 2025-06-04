import 'package:flutter/material.dart';
import 'package:location/location.dart' as loc;
import 'package:new_app/core/api/LocationService.dart';

class LocationScreen extends StatefulWidget {
  @override
  _LocationScreenState createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  final Locationservice _locationService = Locationservice();
  loc.LocationData? _locationData;
  String _locationText = "Tap the button to get your location";
  bool _isLoading = false;

  Future<void> _getLocation() async {
    setState(() {
      _isLoading = true;
      _locationText = "Getting location...";
    });

    final location = await _locationService.determinePosition();

    setState(() {
      _isLoading = false;
      if (location != null) {
        _locationText =
            "Latitude: ${location.latitude}\nLongitude: ${location.longitude}";
      } else {
        _locationText =
            "Unable to get location. Please check your permissions.";
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Location Demo')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                _locationText,
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 20),
            _isLoading
                ? CircularProgressIndicator()
                : ElevatedButton(
                  onPressed: _getLocation,
                  child: Text('Get Location'),
                ),
          ],
        ),
      ),
    );
  }
}
