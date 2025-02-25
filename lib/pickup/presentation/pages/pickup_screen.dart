import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:http/http.dart' as http;
import 'package:pickup/home/presentation/components/my_button.dart';
import 'dart:convert';

import 'package:pickup/journey/presentation/pages/journey_screen.dart';

const String apiKey = "AIzaSyAELuIG9YIzwrujBcwyx29Y9zJSCf7iG8w";

class PickupScreen extends StatefulWidget {
  final LatLng startLocation;
  const PickupScreen({super.key, required this.startLocation});

  @override
  State<PickupScreen> createState() => _PickupScreenState();
}

class _PickupScreenState extends State<PickupScreen> {
  final TextEditingController _dropOffController = TextEditingController();
  List<Map<String, dynamic>> routes = [];

  void _searchRoutes() async {
    List<Location> locations =
        await locationFromAddress(_dropOffController.text);
    if (locations.isEmpty) return print('no error');

    LatLng dropOff = LatLng(locations[0].latitude, locations[0].longitude);
    List<Map<String, dynamic>> routeOptions =
        await getRoutes(widget.startLocation, dropOff);

    setState(() {
      routes = routeOptions;
    });
  }

  Future<List<Map<String, dynamic>>> getRoutes(LatLng start, LatLng end) async {
    String url =
        "https://maps.googleapis.com/maps/api/directions/json?origin=${start.latitude},${start.longitude}&destination=${end.latitude},${end.longitude}&alternatives=true&key=$apiKey";

    var response = await http.get(Uri.parse(url));
    var data = json.decode(response.body);

    List<Map<String, dynamic>> routeList = [];
    for (var route in data["routes"]) {
      routeList.add({
        "distance": route["legs"][0]["distance"]["value"],
        "polyline": route["overview_polyline"]["points"],
        "end_lat": end.latitude, // Store drop-off latitude
        "end_lng": end.longitude, // Store drop-off longitude
      });
    }

    routeList.sort((a, b) => a["distance"].compareTo(b["distance"]));

    return routeList;
  }

  void _selectRoute(Map<String, dynamic> route) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => JourneyScreen(
          route: route,
          startLocation: widget.startLocation,
          dropOffLocation: LatLng(route["end_lat"], route["end_lng"]),
        ),
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
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(5),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                height: 10,
              ),
              const Image(
                image: AssetImage('assets/images/find.jpg'),
              ),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(10)),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: TextField(
                    style: const TextStyle(color: Colors.white),
                    controller: _dropOffController,
                    decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: "Drop-Off Location",
                        hintStyle: TextStyle(color: Colors.white70)),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              MyButton(
                  title: "Find Routes",
                  icon: Icons.location_on,
                  ontap: _searchRoutes),
              Expanded(
                child: ListView.builder(
                  itemCount: routes.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text("Route ${index + 1}"),
                      subtitle: Text(
                          "Distance: ${(routes[index]["distance"] / 1000).toStringAsFixed(2)} km"),
                      onTap: () => _selectRoute(routes[index]),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
