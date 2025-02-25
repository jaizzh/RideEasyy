import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pickup/home/presentation/components/my_button.dart';

class JourneyScreen extends StatefulWidget {
  final Map<String, dynamic> route;
  final LatLng startLocation;
  final LatLng dropOffLocation;

  const JourneyScreen({
    super.key,
    required this.route,
    required this.startLocation,
    required this.dropOffLocation,
  });

  @override
  State<JourneyScreen> createState() => _JourneyScreenState();
}

class _JourneyScreenState extends State<JourneyScreen> {
  bool journeyStarted = false;
  double pricePerKm = 10;
  double totalFare = 0.0;

  void _startJourney() {
    setState(() {
      journeyStarted = true;
    });
  }

  void _completeJourney() async {
    double distanceKm = widget.route["distance"] / 1000;
    totalFare = double.parse((distanceKm * pricePerKm).toStringAsFixed(2));
    String driverId = "driver_123";

    await FirebaseFirestore.instance.collection('journeys').add({
      'driverId': driverId,
      'distance': distanceKm,
      'fare': totalFare,
      'timestamp': FieldValue.serverTimestamp(),
    });

    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text(
              "Journey Completed! Fare: \$${totalFare.toStringAsFixed(2)}")),
    );

    // ignore: use_build_context_synchronously
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    double distanceKm = widget.route["distance"] / 1000;
    LatLng start =
        LatLng(widget.startLocation.latitude, widget.startLocation.longitude);
    LatLng drop = LatLng(
        widget.dropOffLocation.latitude, widget.dropOffLocation.longitude);

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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              height: 500,
              child: GoogleMap(
                initialCameraPosition: CameraPosition(target: start, zoom: 15),
                markers: {
                  Marker(
                    markerId: const MarkerId('currentLocation'),
                    icon: BitmapDescriptor.defaultMarker,
                    position: start,
                  ),
                  Marker(
                    markerId: const MarkerId('dropLocation'),
                    icon: BitmapDescriptor.defaultMarker,
                    position: drop,
                  )
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Container(
                width: double.infinity,
                height: 50,
                decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(10)),
                child: Center(
                  child: Text(
                      "Route Distance: ${distanceKm.toStringAsFixed(2)} km",
                      style:
                          const TextStyle(fontSize: 18, color: Colors.white)),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: SizedBox(
                child: MyButton(
                  title: journeyStarted ? "Complete Journey" : "Start Journey",
                  icon: journeyStarted
                      ? Icons.navigate_next
                      : Icons.rocket_launch,
                  ontap: journeyStarted ? _completeJourney : _startJourney,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
