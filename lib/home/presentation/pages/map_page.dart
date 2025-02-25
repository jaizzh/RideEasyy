import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:pickup/home/presentation/components/my_button.dart';
import 'package:pickup/home/presentation/components/my_drawer.dart';
import 'package:pickup/pickup/presentation/pages/pickup_screen.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  late GoogleMapController mapController;
  final Location _locationController = Location();
  final LatLng _currentPosition = const LatLng(11.03, 76.9585);
  LatLng currentP = const LatLng(11.03, 76.9585); // Initialize it

  @override
  void initState() {
    super.initState();
    getLocationUpdates();
  }

  void startPickup() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PickupScreen(startLocation: currentP),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.white),
          title: const Row(
            children: [
              Text(
                "Ride Easy",
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
              ),
              SizedBox(
                width: 5,
              ),
              Icon(
                Icons.local_taxi,
                color: Colors.white,
              ),
            ],
          ),
          backgroundColor: Colors.black,
        ),
        drawer: const MyDrawer(),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.all(5),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
                height: 500,
                width: double.infinity,
                child: GoogleMap(
                  onMapCreated: (GoogleMapController controller) {
                    mapController = controller;
                  },
                  initialCameraPosition: CameraPosition(
                    target: _currentPosition,
                    zoom: 14.0,
                  ),
                  markers: {
                    Marker(
                      markerId: const MarkerId("_currentPosition"),
                      icon: BitmapDescriptor.defaultMarker,
                      position: currentP,
                    ),
                  },
                  myLocationEnabled: true,
                ),
              ),
            ),
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: MyButton(
                  title: "Start Pickup",
                  icon: Icons.run_circle,
                  ontap: startPickup,
                )),
            const SizedBox(
              height: 20,
            )
          ],
        ));
  }

  Future<void> getLocationUpdates() async {
    bool serviceEnabled;
    PermissionStatus permissionGranted;

    serviceEnabled = await _locationController.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await _locationController.requestService();
      if (!serviceEnabled) return; // Exit if service is still disabled
    }

    permissionGranted = await _locationController.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await _locationController.requestPermission();
      if (permissionGranted != PermissionStatus.granted) return;
    }

    _locationController.onLocationChanged
        .listen((LocationData currentLocation) {
      if (currentLocation.latitude != null &&
          currentLocation.longitude != null) {
        setState(() {
          currentP =
              LatLng(currentLocation.latitude!, currentLocation.longitude!);
        });

        // Move the camera to the new location
        mapController.animateCamera(
          CameraUpdate.newLatLng(currentP),
        );
      }
    });
  }
}
