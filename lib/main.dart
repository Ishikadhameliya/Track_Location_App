import 'package:flutter/material.dart';
import 'package:track_location_app/views/screens/homepage.dart';
import 'package:track_location_app/views/screens/map_screen.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: 'weather',
      routes: {
        '/': (context) => const Homepage(),
        'map_screen': (context) => const map(),
      },
    ),
  );
}
