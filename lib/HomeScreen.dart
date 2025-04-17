import 'dart:async';
import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:healthscout/Features/BasicMedicine.dart';
import 'package:healthscout/Features/HealthTips.dart';
import 'package:healthscout/Features/alarm.dart';
import 'package:healthscout/Features/doctor_appointment.dart';
import 'package:healthscout/Features/government_schemes.dart';
import 'package:healthscout/Functionalalities/HospitalCard1.dart';
import 'package:healthscout/Functionalalities/HospitalCard2.dart';
import 'package:healthscout/Functionalalities/HospitalCard3.dart';
import 'package:healthscout/Functionalalities/HospitalCard4.dart';
import 'package:healthscout/Functionalalities/HospitalCard5.dart';
import 'package:healthscout/Functionalalities/MedicineCard3.dart';
import 'package:healthscout/Functionalalities/MedicineCard4.dart';
import 'package:healthscout/Functionalalities/Medicinecard1.dart';
import 'package:healthscout/Functionalalities/Medicinecard2.dart';
import 'package:healthscout/Functionalalities/SafeHome.dart';
import 'package:healthscout/ProfileScreen.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  final List<Widget> _screens = [
    HomeContent(),
    GovernmentSchemes(),
    ProfileScreen()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.transparent,
        color: Colors.blueAccent,
        animationDuration: Duration(milliseconds: 300),
        index: _selectedIndex,
        onTap: _onItemTapped,
        items: [
          Icon(Icons.home_outlined, size: 30, color: Colors.white),
          Icon(Icons.policy_outlined, size: 30, color: Colors.white),
          Icon(Icons.person_outline, size: 30, color: Colors.white),
        ],
      ),
    );
  }
}

class HomeContent extends StatefulWidget {
  @override
  _HomeContentState createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  Position? _currentPosition;
  int _currentPage = 0;
  int _currentPage1 = 0;
  final PageController _pageController = PageController(initialPage: 0);
  final PageController _pageController1 = PageController(initialPage: 0);
  String _currentAddress = "Fetching location...";

  @override
  void initState() {
    super.initState();
    _getPermissionAndLocation();
    _startTimer();
  }

  void _startTimer() {
    Timer.periodic(Duration(seconds: 3), (Timer timer) {
      setState(() {
        _currentPage = (_currentPage + 1) % 4;
        _currentPage1 = (_currentPage1 + 1) % 5;
      });
      _pageController.animateToPage(
        _currentPage,
        duration: Duration(seconds: 1),
        curve: Curves.easeIn,
      );
      _pageController1.animateToPage(
        _currentPage1,
        duration: Duration(seconds: 1),
        curve: Curves.easeIn,
      );
    });
  }

  Future<void> _getPermissionAndLocation() async {
    var status = await Permission.location.request();
    if (status.isGranted) {
      _getCurrentLocation();
    } else {
      Fluttertoast.showToast(msg: "Location permission denied.");
    }
  }

  Future<void> _getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      setState(() {
        _currentPosition = position;
      });
      _getAddressFromLatLon();
    } catch (e) {
      Fluttertoast.showToast(msg: "Location Error: $e");
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
              "${place.locality}, ${place.postalCode},\n${place.subLocality}";
        });
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "Address Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blueAccent, Colors.indigoAccent],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Row(
                    children: [
                      Icon(Icons.location_on_outlined,
                          color: Colors.white, size: 30),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _currentAddress,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Poppins',
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                TextField(
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    hintText: "Search Lab Tests, Packages",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    prefixIcon: Icon(Icons.search, color: Colors.blueAccent),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                GridView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 1.0,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemCount: getFeatures(context).length,
                  itemBuilder: (context, index) {
                    var feature = getFeatures(context)[index];
                    return FeatureCard(
                      title: feature['title'],
                      icon: feature['icon'],
                      onTap: feature['onTap'],
                    );
                  },
                ),
                SizedBox(height: 20),
                Column(
                  children: [
                    Text(
                      "MEDICINES",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    SizedBox(height: 10),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: 200,
                      child: PageView(
                        controller: _pageController,
                        scrollDirection: Axis.horizontal,
                        children: [
                          MedicineCard1(),
                          MedicineCard2(),
                          MedicineCard3(),
                          MedicineCard4(),
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "POPULAR HOSPITALS",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    SizedBox(height: 10),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: 200,
                      child: PageView(
                        controller: _pageController1,
                        scrollDirection: Axis.horizontal,
                        children: [
                          HospitalCard1(),
                          HospitalCard2(),
                          HospitalCard3(),
                          HospitalCard4(),
                          HospitalCard5()
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

Future<void> _openGoogleMaps() async {
  Position position = await Geolocator.getCurrentPosition(
    desiredAccuracy: LocationAccuracy.high,
  );
  String url = "https://www.google.com/maps/search/hospitals+near+me/"
      "@${position.latitude},${position.longitude},15z";
  if (await canLaunchUrl(Uri.parse(url))) {
    await launchUrl(Uri.parse(url));
  } else {
    Fluttertoast.showToast(msg: "Could not open Google Maps");
  }
}

List<Map<String, dynamic>> getFeatures(BuildContext context) {
  return [
    {
      'title': "Book Appointment",
      'icon': Icons.event_available,
      'onTap': () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DoctorAppointment(),
            ));
      }
    },
    {
      'title': "Find \nHospitals",
      'icon': Icons.local_hospital,
      'onTap': _openGoogleMaps
    },
    {
      'title': "Medicine Reminder",
      'icon': Icons.alarm,
      'onTap': () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AlarmSettingScreen(),
            ));
      }
    },
    {
      'title': "Health \nTips",
      'icon': Icons.health_and_safety,
      'onTap': () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => HealthTipsWebView(),
            ));
      }
    },
    {
      'title': "Emergency \nLocation",
      'icon': Icons.location_on_rounded,
      'onTap': () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          backgroundColor: Colors.transparent,
          builder: (context) => SafeHome(),
        );
      }
    },
    {
      'title': " Basic \nMedicine",
      'icon': Icons.medical_information,
      'onTap': () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BasicMedicineWebView(),
            ));
      }
    },
  ];
}

class FeatureCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback? onTap;

  FeatureCard({required this.title, required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap, // Allows tapping on the card
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 6,
              spreadRadius: 3,
              offset: Offset(2, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 30, color: Colors.blueAccent),
            SizedBox(height: 6),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w400,
                color: Colors.blueAccent,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
