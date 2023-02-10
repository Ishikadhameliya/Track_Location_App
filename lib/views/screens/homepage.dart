import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../res/globals.dart';

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  State<Homepage> createState() => _HomepageState();
}

Placemark? current;

class _HomepageState extends State<Homepage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Permission.location.request();
  }

  @override
  Widget build(BuildContext context) {
    double _height = MediaQuery.of(context).size.height;
    double _widht = MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text("API"),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                openAppSettings();
              },
              icon: const Icon(Icons.settings))
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("${Globals.lat}\n${Globals.long}\n$current"),
            ElevatedButton(
                onPressed: () async {
                  Geolocator.getPositionStream()
                      .listen((Position position) async {
                    setState(() {
                      Globals.lat = position.latitude;
                      Globals.long = position.longitude;
                    });
                    List<Placemark> placemark = await placemarkFromCoordinates(
                        Globals.lat, Globals.long);
                    setState(() {
                      current = placemark[0];
                    });
                  });
                  setState(() {
                    Navigator.of(context).pushNamed('map_screen');
                  });
                },
                child: const Text("get location"))
          ],
        ),
      ),
    );
  }
}
