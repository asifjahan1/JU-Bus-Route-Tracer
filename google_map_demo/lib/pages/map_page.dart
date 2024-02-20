import 'dart:async';
import 'dart:math' show atan2, cos, pi, sin, sqrt;
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_map_demo/pages/schedule_page.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MapPage extends StatefulWidget {
  final LatLng userStartLocation;

  MapPage({Key? key, required this.userStartLocation}) : super(key: key);

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  int _selectedIndex = 0;
  bool _isLoggedIn = false; // Add this line to track login status

  static const List<Widget> _widgetOptions = <Widget>[
    Text('Map'), // Example widget for the first tab
    Text('Schedule'), // Example widget for the second tab
    // Text('Profile'), // Example widget for the third tab
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      if (_selectedIndex == 1) {
        // Navigate to the SchedulePage when the Schedule icon is tapped
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => SchedulePage()));
      }
    });
  }

  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  // Use a Geolocator instance
  final Geolocator _geolocator = Geolocator();

  List<LatLng> userPolylineCoordinates = [];
  Map<String, List<LatLng>> predefinedPolylines = {};
  final Set<Marker> _markers = {};
  final Set<Polyline> _polylines = {};
  LatLng endLocation =
      const LatLng(23.877613, 90.266383); // JU (CSE building location)

  double calculateDistance(LatLng start, LatLng end) {
    const double radius = 6371.0; // Earth radius
    double lat1 = start.latitude;
    double lon1 = start.longitude;
    double lat2 = end.latitude;
    double lon2 = end.longitude;

    double dLat = _toRadians(lat2 - lat1);
    double dLon = _toRadians(lon2 - lon1);

    double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_toRadians(lat1)) *
            cos(_toRadians(lat2)) *
            sin(dLon / 2) *
            sin(dLon / 2);
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));

    return radius * c;
  }

  double _toRadians(double degrees) {
    return degrees * (pi / 180.0);
  }

  @override
  void initState() {
    super.initState();
    _getPolyline();
  }

  Future<void> _getPolyline() async {
    const apiKey = 'AIzaSyDNToFfTa1a7WqcxS1PlC382Oem1MpHeHA';

    // User's route
    PolylineResult userResult =
        await PolylinePoints().getRouteBetweenCoordinates(
      apiKey,
      PointLatLng(widget.userStartLocation.latitude,
          widget.userStartLocation.longitude),
      PointLatLng(endLocation.latitude, endLocation.longitude),
    );

    if (userResult.points.isNotEmpty) {
      userPolylineCoordinates = userResult.points
          .map((point) => LatLng(point.latitude, point.longitude))
          .toList();
    } else {
      print("Polyline API response error for User's route");
    }

    // Predefined routes
    Map<String, LatLng> predefinedStartLocations = {
      'Motijheel-JU': const LatLng(23.726566, 90.421664),
      'khamarbari-JU': const LatLng(23.758978, 90.383947),
      'Airport-JU': const LatLng(23.851625, 90.408069),
      'Jigatala-JU': const LatLng(23.739274, 90.375380),
      // Add more predefined routes as needed
    };

    List<Future<void>> predefinedRouteFutures = [];

    //New updated code
    // Inside the _getPolyline method
    for (var entry in predefinedStartLocations.entries) {
      await _fetchAndDisplayPredefinedRoute(entry);
    }

    // Display common markers
    _markers.add(Marker(
      markerId: const MarkerId("User Start Location"),
      position: widget.userStartLocation,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      infoWindow: InfoWindow(
        title:
            'User_Route-JU Distance: ${calculateDistance(widget.userStartLocation, endLocation)} km',
        snippet:
            'ETA: ${_formatDuration(await _calculateETA(widget.userStartLocation, endLocation))}',
      ),
    ));

    _markers.add(Marker(
      markerId: const MarkerId("End point location"),
      position: endLocation,
    ));

    // Display polylines and markers on the map once it's created
    final GoogleMapController controller = await _controller.future;
    _displayPolylines(controller);

    // previous updated code
    // for (var entry in predefinedStartLocations.entries) {
    //   Future<void> fetchRoute() async {
    //     PolylineResult predefinedResult =
    //         await PolylinePoints().getRouteBetweenCoordinates(
    //       apiKey,
    //       PointLatLng(entry.value.latitude, entry.value.longitude),
    //       PointLatLng(endLocation.latitude, endLocation.longitude),
    //     );

    //     if (predefinedResult.points.isNotEmpty) {
    //       predefinedPolylines[entry.key] = predefinedResult.points
    //           .map((point) => LatLng(point.latitude, point.longitude))
    //           .toList();
    //     } else {
    //       print("Polyline API response error for ${entry.key}");
    //       // Provide a default value (e.g., a straight line) if points are empty
    //       predefinedPolylines[entry.key] = [
    //         entry.value,
    //         endLocation,
    //       ];
    //     }
    //   }

    //   predefinedRouteFutures.add(fetchRoute());
    // }

    // Wait for all predefined routes to complete
    await Future.wait(predefinedRouteFutures);

    // Display polylines and markers on the map
    //_displayPolylines();
  }

  // New method to handle the fetching and displaying of each predefined route
  Future<void> _fetchAndDisplayPredefinedRoute(
      MapEntry<String, LatLng> entry) async {
    await Future.delayed(
      Duration(
        milliseconds: 100,
      ),
    ); // Add a delay of 100 milisecond

    const apiKey = 'AIzaSyDNToFfTa1a7WqcxS1PlC382Oem1MpHeHA';

    PolylineResult predefinedResult =
        await PolylinePoints().getRouteBetweenCoordinates(
      apiKey,
      PointLatLng(entry.value.latitude, entry.value.longitude),
      PointLatLng(endLocation.latitude, endLocation.longitude),
    );

    if (predefinedResult.points.isNotEmpty) {
      predefinedPolylines[entry.key] = predefinedResult.points
          .map((point) => LatLng(point.latitude, point.longitude))
          .toList();
    } else {
      print("Polyline API response error for ${entry.key}");
      // Provide a default value (e.g., a straight line) if points are empty
      predefinedPolylines[entry.key] = [
        entry.value,
        endLocation,
      ];
    }
  }

  Future<void> _displayPolylines(GoogleMapController controller) async {
    // Display user's route
    _polylines.add(
      Polyline(
        polylineId: PolylineId('user_route'),
        points: userPolylineCoordinates,
        color: Colors.red,
        width: 7,
        onTap: () async {
          int userEstimatedDuration =
              await _calculateETA(widget.userStartLocation, endLocation);
          _showETAMessage(
            calculateDistance(widget.userStartLocation, endLocation),
            userEstimatedDuration,
            'User_Route-JU',
          );
        },
      ),
    );

    // Display predefined routes
    await Future.forEach(predefinedPolylines.entries, (entry) async {
      int predefinedEstimatedDuration =
          await _calculateETA(entry.value.first, endLocation);
      await _displayPredefinedRoute(
          entry.key, entry.value, controller, predefinedEstimatedDuration);
    });

    // Display common markers
    _markers.add(Marker(
      markerId: const MarkerId("User Start Location"),
      position: widget.userStartLocation,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      infoWindow: InfoWindow(
        title:
            'User_Route-JU Distance: ${calculateDistance(widget.userStartLocation, endLocation).toStringAsFixed(2)} km',
        snippet:
            'ETA: ${_formatDuration(await _calculateETA(widget.userStartLocation, endLocation))}',
      ),
    ));

    _markers.add(Marker(
      markerId: const MarkerId("End point location"),
      position: endLocation,
    ));

    // Show the user's infoWindow without clicking the marker
    //controller.showMarkerInfoWindow(MarkerId("User Start Location"));

    // Animate the camera position to the user's location after a delay
    Future.delayed(Duration(milliseconds: 100), () async {
      final GoogleMapController controller = await _controller.future;
      controller.animateCamera(
        CameraUpdate.newLatLng(widget.userStartLocation),
      );
    });

    setState(() {});
  }

  Future<void> _displayPredefinedRoute(String routeKey, List<LatLng> routeValue,
      GoogleMapController controller, int predefinedEstimatedDuration) async {
    _polylines.add(
      Polyline(
        polylineId: PolylineId(routeKey),
        points: routeValue,
        color: _getRouteColor(routeKey),
        width: 4,
        onTap: () async {
          _showETAMessage(
            calculateDistance(routeValue.first, endLocation),
            predefinedEstimatedDuration,
            routeKey,
          );
        },
      ),
    );

    _markers.add(Marker(
      markerId: MarkerId("$routeKey Start Location"),
      position: routeValue.first,
      icon: BitmapDescriptor.defaultMarkerWithHue(_getMarkerColor(routeKey)),
      infoWindow: InfoWindow(
        title:
            '$routeKey Distance: ${calculateDistance(routeValue.first, endLocation).toStringAsFixed(2)} km',
        snippet: 'ETA: ${_formatDuration(predefinedEstimatedDuration)}',
      ),
    ));
  }

  // Update user location instantly when clicking the floating action button
  bool _isUpdatingLocation = false;
  MarkerId userLocationMarkerId = const MarkerId("Updated Location");

  Future<void> _updateUserLocation() async {
    if (_isUpdatingLocation) return;

    _isUpdatingLocation = true;

    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    LatLng newLocation = LatLng(position.latitude, position.longitude);

    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(
      CameraUpdate.newLatLngZoom(newLocation, 16.0),
    );

    // Calculate distance and ETA
    double distance = calculateDistance(newLocation, endLocation);
    int estimatedDuration = await _calculateETA(newLocation, endLocation);

    // Find the user location marker
    Marker userLocationMarker = _markers.firstWhere(
      (marker) => marker.markerId == const MarkerId("Updated Location"),
      orElse: () =>
          const Marker(markerId: MarkerId("Updated Location"), visible: true),
    );

    // Update the position and infoWindow of the user location marker
    userLocationMarker = userLocationMarker.copyWith(
      positionParam: newLocation,
      infoWindowParam: InfoWindow(
        title: 'User_Route-JU Distance: ${distance.toStringAsFixed(2)} km',
        snippet: 'ETA: ${_formatDuration(estimatedDuration)}',
      ),
    );

    // Update the user location marker in the set of markers
    _markers.removeWhere(
        (marker) => marker.markerId == MarkerId("Updated Location"));
    //_markers.add(userLocationMarker); //eita off korar pore amar current location er moddhe arekta marker add hobe na.

    setState(() {});

    // Allow updating location again after a delay (e.g., 2 seconds)
    await Future.delayed(const Duration(milliseconds: 100));
    _isUpdatingLocation = false;
  }

  // void _showETAMessage(double distance, int estimatedDuration) {
  //   final formattedDistance = distance.toStringAsFixed(3);
  //   ScaffoldMessenger.of(context).showSnackBar(
  //     SnackBar(
  //       content: Text(
  //         'Distance: $formattedDistance km\nETA: ${_formatDuration(estimatedDuration)}',
  //         //'Distance: $distance km\nETA: ${_formatDuration(estimatedDuration)}',
  //       ),
  //     ),
  //   );
  // }
  //
  //

  void _showETAMessage(double distance, int estimatedDuration, String s) {
    if (distance.isNaN) {
      // Handle the case where distance is NaN
      distance = 0.0;
    }

    final formattedDistance =
        distance.toStringAsFixed(2); // Displaying with 2 decimal places
    final formattedDuration = _formatDuration(estimatedDuration);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: RichText(
          text: TextSpan(
            style: DefaultTextStyle.of(context).style,
            children: [
              TextSpan(text: 'Distance: $formattedDistance km\n'),
              TextSpan(text: 'ETA: $formattedDuration'),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDuration(int seconds) {
    final Duration duration = Duration(seconds: seconds);

    if (duration.inHours > 0) {
      return '${duration.inHours} hr ${duration.inMinutes.remainder(60)} min ${duration.inSeconds.remainder(60)} sec';
    } else {
      return '${duration.inMinutes} min ${(duration.inSeconds % 60)} sec';
    }
  }

  Future getETA(LatLng startLocation, LatLng endLocation) async {
    const apiKey = 'AIzaSyDNToFfTa1a7WqcxS1PlC382Oem1MpHeHA';
    final apiUrl = Uri.parse(
      'https://maps.googleapis.com/maps/api/directions/json?origin=${startLocation.latitude},${startLocation.longitude}&destination=${endLocation.latitude},${endLocation.longitude}&key=$apiKey',
    );

    final response = await http.get(apiUrl);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final durationInSeconds =
          data['routes'][0]['legs'][0]['duration']['value'];
      return durationInSeconds;
    } else {
      // Use CircularProgressIndicator with valueColor
      return const Center(
        child: CircularProgressIndicator(
          backgroundColor: Colors.transparent,
          valueColor: AlwaysStoppedAnimation<Color>(
              Colors.red), // Change the color to your preference
        ),
      );
    }
  }

  Future<int> _calculateETA(LatLng startLocation, LatLng endLocation) async {
    int durationInSeconds = await getETA(startLocation, endLocation);
    return durationInSeconds;
  }

  //Get the routes colors
  Color _getRouteColor(String routeName) {
    if (routeName == 'Motijheel-JU') {
      return Colors.blue;
    } else if (routeName == 'Khamarbari-JU') {
      return Colors.green;
    } else if (routeName == 'Airport-JU') {
      return Colors.pink;
    } else if (routeName == 'Jigatala-JU') {
      return Colors.deepPurple;
    }

    // Add more route colors as needed
    return Colors.deepOrange;
  }

  // Get the markers colors
  double _getMarkerColor(String routeName) {
    if (routeName == 'Motijheel-JU') {
      return BitmapDescriptor.hueBlue;
    } else if (routeName == 'Khamarbari-JU') {
      return BitmapDescriptor.hueGreen;
    } else if (routeName == 'Airport-JU') {
      return BitmapDescriptor.hueRose;
    } else if (routeName == 'Jigatala-JU') {
      return BitmapDescriptor.hueViolet;
    }
    // Add more marker colors as needed
    return BitmapDescriptor.hueOrange;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        body: Stack(
          children: [
            Column(
              children: [
                Flexible(
                  child: LayoutBuilder(
                    builder:
                        (BuildContext context, BoxConstraints constraints) {
                      double mapHeight = MediaQuery.of(context).size.height;
                      double mapWidth = MediaQuery.of(context).size.width;

                      return SizedBox(
                        height: mapHeight,
                        width: mapWidth,
                        child: Padding(
                          padding: const EdgeInsets.only(
                              bottom: kBottomNavigationBarHeight),
                          child: GoogleMap(
                            mapType: MapType.hybrid,
                            initialCameraPosition: CameraPosition(
                              target: widget.userStartLocation,
                              zoom: 14,
                            ),
                            markers: _markers,
                            onMapCreated: (mapController) {
                              if (!_controller.isCompleted) {
                                _controller.complete(mapController);
                                _displayPolylines(mapController);
                              }
                            },
                            polylines: _polylines,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                // Add other widgets below if needed
              ],
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(15.0),
                  topRight: Radius.circular(15.0),
                ),
                child: BottomNavigationBar(
                  items: const <BottomNavigationBarItem>[
                    BottomNavigationBarItem(
                      icon: Icon(Icons.map),
                      label: 'Map',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.schedule),
                      label: 'Schedule',
                    ),
                  ],
                  currentIndex: _selectedIndex,
                  selectedItemColor: Colors.blue,
                  onTap: _onItemTapped,
                ),
              ),
            ),
            Positioned(
              right: 10.0,
              bottom: 165.0,
              child: FloatingActionButton(
                backgroundColor: Colors.white.withOpacity(0.7),
                onPressed: _updateUserLocation,
                child: const Icon(Icons.my_location, color: Colors.black),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> _onWillPop() async {
    return (await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            //backgroundColor: Colors.white.withOpacity(0.5),
            title: Text(
              'Exit the Map?',
              style: TextStyle(color: Colors.green),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text(
                  'No',
                  style: TextStyle(color: Colors.black, fontSize: 20),
                ),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: Text(
                  'Yes',
                  style: TextStyle(color: Colors.red, fontSize: 20),
                ),
              ),
            ],
          ),
        )) ??
        false;
  }
}
