import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class JourneyHistoryScreen extends StatefulWidget {
  const JourneyHistoryScreen({super.key});

  @override
  State<JourneyHistoryScreen> createState() => _JourneyHistoryScreenState();
}

class _JourneyHistoryScreenState extends State<JourneyHistoryScreen> {
  final CollectionReference fetchData =
      FirebaseFirestore.instance.collection("journeys");
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
      body: StreamBuilder(
          stream: fetchData.snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
            if (streamSnapshot.hasData) {
              return ListView.builder(
                  itemCount: streamSnapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    final DocumentSnapshot documentSnapshot =
                        streamSnapshot.data!.docs[index];
                    return Material(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            ListTile(
                              tileColor: Colors.amber[700],
                              title: Text(
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                  "Distance:${documentSnapshot['distance'].toString()} km"),
                              subtitle: Text(
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                  "Fare:${documentSnapshot['fare'].toString()}"),
                              trailing: Text(
                                  documentSnapshot['timestamp'] != null
                                      ? documentSnapshot['timestamp']
                                          .toDate()
                                          .toString()
                                      : "No Date"),
                            ),
                          ],
                        ),
                      ),
                    );
                  });
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          }),
    );
  }
}
