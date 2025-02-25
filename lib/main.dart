import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:pickup/firebase_options.dart';
import 'package:pickup/home/presentation/pages/map_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: MapPage(),
      ),
    );
  }
}
