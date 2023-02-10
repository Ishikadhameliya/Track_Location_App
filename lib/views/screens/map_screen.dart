import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../res/globals.dart';

class map extends StatefulWidget {
  const map({Key? key}) : super(key: key);

  @override
  State<map> createState() => _mapState();
}

class _mapState extends State<map> {
  GoogleMapController? controller;
  final CameraPosition initialPosition =
      CameraPosition(target: LatLng(Globals.lat, Globals.long));
  var typemap = MapType.normal;
  var cordinate1 = 'cordinate';
  var lat = Globals.lat;
  var long = Globals.long;
  var address = '';
  var options = [
    MapType.normal,
    MapType.hybrid,
    MapType.terrain,
    MapType.satellite
  ];
  var _currentItemSelected = MapType.normal;

  static final CameraPosition cameraPosition =
      CameraPosition(target: LatLng(Globals.lat, Globals.long), zoom: 30);
  List<Marker> marker = [];
  List<Marker> list = [
    Marker(
        markerId: const MarkerId("1"),
        position: LatLng(Globals.lat, Globals.long),
        infoWindow: const InfoWindow(title: "My Position"))
  ];

  Future<void> getAddress(latt, longg) async {
    List<Placemark> placemark = await placemarkFromCoordinates(latt, longg);
    Placemark place = placemark[0];
    setState(() {
      address =
          '${place.street}, ${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}';
    });
  }

  @override
  void initState() {
    super.initState();
    marker.addAll(list);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[900],
        title: const Text('Map App'),
        actions: [
          DropdownButton<MapType>(
            dropdownColor: Colors.blue[900],
            isDense: true,
            isExpanded: false,
            iconEnabledColor: Colors.white,
            focusColor: Colors.white,
            items: options.map((MapType dropDownStringItem) {
              return DropdownMenuItem<MapType>(
                value: dropDownStringItem,
                child: Text(
                  dropDownStringItem.toString(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              );
            }).toList(),
            onChanged: (newValueSelected) {
              setState(() {
                _currentItemSelected = newValueSelected!;
                typemap = newValueSelected;
              });
            },
            value: _currentItemSelected,
          ),
        ],
      ),
      body: Stack(
        children: [
          GoogleMap(
            markers: Set.of(marker),
            myLocationEnabled: true,
            initialCameraPosition: initialPosition,
            mapType: typemap,
            onMapCreated: (controller) {
              setState(() {
                controller = controller;
              });
            },
            onTap: (cordinate) {
              setState(() {
                lat = cordinate.latitude;
                long = cordinate.longitude;
                getAddress(lat, long);

                cordinate1 = cordinate.toString();
              });
            },
          ),
          Positioned(
            left: 5,
            bottom: 150,
            child: Text(
              cordinate1,
              softWrap: false,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
          ),
          Positioned(
            left: 15,
            bottom: 100,
            child: Container(
              width: 200,
              child: Text(
                address,
                softWrap: true,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
