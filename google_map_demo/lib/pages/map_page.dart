import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class MapPage extends StatefulWidget {
  const MapPage({Key? key}) : super(key: key);

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  List<LatLng> polylineCoordinates = [];
  PolylinePoints polylinePoints = PolylinePoints();

  Location currentLocation = Location();
  LocationData? currentLocationData; // Declare as nullable

  Set<Marker> _markers = {};

  LatLng startLocation = LatLng(23.7154657,
      90.4178501); //My coordinates // Replace with your start location
  LatLng endLocation = LatLng(
      23.8799, 90.2727); //JU coordinates // Replace with your end location

  @override
  void initState() {
    super.initState();
    _getLocation(); // Call the function to get the location
    _getPolyline();
  }

  Future<void> _getLocation() async {
    currentLocationData = await currentLocation.getLocation();
    // Handle the case where currentLocationData is still null
    if (currentLocationData != null) {
      _updateMarkers();
    }

    currentLocation.onLocationChanged.listen((LocationData loc) {
      _controller.future.then((controller) {
        controller.animateCamera(CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(loc.latitude ?? 0.0, loc.longitude ?? 0.0),
            zoom: 14,
          ),
        ));
      });

      print(loc.latitude);
      print(loc.longitude);
      setState(() {
        _updateMarkers();
      });
    });
  }

  void _updateMarkers() {
    _markers.clear();
    _markers.add(Marker(
      markerId: const MarkerId('CurrentLocation'),
      position: LatLng(
          currentLocationData!.latitude!, currentLocationData!.longitude!),
    ));
    _markers.add(Marker(
      markerId: const MarkerId("Staring point location "),
      position: startLocation,
    ));
    _markers.add(Marker(
      markerId: const MarkerId("End point location "),
      position: endLocation,
    ));
  }

  Future<void> _getPolyline() async {
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      "AIzaSyDNToFfTa1a7WqcxS1PlC382Oem1MpHeHA", // Replace with your Google Map Key
      PointLatLng(startLocation.latitude, startLocation.longitude),
      PointLatLng(endLocation.latitude, endLocation.longitude),
    );

    if (result.points.isNotEmpty) {
      for (var point in result.points) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      }
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(currentLocationData?.latitude ?? 0.0,
              currentLocationData?.longitude ?? 0.0),
          zoom: 13.5,
        ),
        markers: _markers,
        onMapCreated: (mapController) {
          _controller.complete(mapController);
        },
        polylines: {
          Polyline(
            polylineId: const PolylineId("track"),
            points: polylineCoordinates,
            color: const Color(0xFFFF0000),
            width: 4,
          ),
        },
      ),
    );
  }
}
