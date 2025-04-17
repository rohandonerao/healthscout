import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

class SafeHome extends StatefulWidget {
  @override
  State<SafeHome> createState() => _SafeHomeState();
}

class _SafeHomeState extends State<SafeHome> {
  Position? _currentPosition;
  String? _currentAddress;
  GoogleMapController? _mapController;
  Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    _getPermission();
    _getCurrentLocation();
  }

  Future<void> _getPermission() async {
    await [Permission.location, Permission.locationWhenInUse].request();
  }

  Future<void> _getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      setState(() {
        _currentPosition = position;
      });

      await _getAddressFromLatLon();
    } catch (e) {
      Fluttertoast.showToast(msg: "Failed to get location: ${e.toString()}");
    }
  }

  Future<void> _getAddressFromLatLon() async {
    try {
      if (_currentPosition != null) {
        List<Placemark> placemarks = await placemarkFromCoordinates(
          _currentPosition!.latitude,
          _currentPosition!.longitude,
        );
        Placemark place = placemarks[0];
        setState(() {
          _currentAddress =
              "${place.locality}, ${place.postalCode}, ${place.street}";
          _markers.clear();
          _markers.add(Marker(
            markerId: MarkerId('currentLocation'),
            position:
                LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
            infoWindow: InfoWindow(title: _currentAddress!),
          ));
        });
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "Failed to get address: ${e.toString()}");
    }
  }

  Future<void> _handleAlert() async {
    String defaultContact = "+918830815312"; // Emergency number

    if (_currentPosition == null) {
      Fluttertoast.showToast(msg: "Fetching location... Please try again.");
      return;
    }

    if (_currentAddress == null) {
      _currentAddress = "Unknown Address";
    }

    String messageBody =
        "I am in trouble. Please help me! My location is $_currentAddress. "
        "Google Maps link: https://www.google.com/maps?q=${_currentPosition!.latitude},${_currentPosition!.longitude}";

    Uri uri = Uri.parse(
        "sms:$defaultContact?body=${Uri.encodeComponent(messageBody)}");

    try {
      if (await launchUrl(uri, mode: LaunchMode.externalApplication)) {
        Fluttertoast.showToast(msg: "Opening messaging app with alert...");
      } else {
        Fluttertoast.showToast(msg: "Failed to open messaging app.");
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "Error: ${e.toString()}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [
          BoxShadow(color: Colors.black26, blurRadius: 10, spreadRadius: 2),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 5,
            decoration: BoxDecoration(
              color: Colors.grey[400],
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          SizedBox(height: 10),
          Text(
            "Safe Home",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          PrimaryButtonWidget(
            title: "Get Location",
            icon: Icons.location_on,
            color: Colors.blue,
            onPressed: _getCurrentLocation,
          ),
          SizedBox(height: 15),
          PrimaryButtonWidget(
            title: "Send Alert",
            icon: Icons.warning,
            color: Colors.red,
            onPressed: _handleAlert,
          ),
          SizedBox(height: 10),
        ],
      ),
    );
  }
}

class PrimaryButtonWidget extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onPressed;
  final Color color;

  PrimaryButtonWidget({
    required this.title,
    required this.icon,
    required this.onPressed,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      width: MediaQuery.of(context).size.width * 0.8,
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: EdgeInsets.symmetric(vertical: 12),
        ),
        icon: Icon(icon, size: 24, color: Colors.white),
        label: Text(title, style: TextStyle(fontSize: 17, color: Colors.white)),
        onPressed: onPressed,
      ),
    );
  }
}
