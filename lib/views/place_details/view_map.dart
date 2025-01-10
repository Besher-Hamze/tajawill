import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

class MapboxPathExample extends StatefulWidget {
  final LatLng destination; // Destination location passed to the widget
  final String destinationTitle; // Title for the destination marker

  const MapboxPathExample({
    Key? key,
    required this.destination,
    required this.destinationTitle,
  }) : super(key: key);

  @override
  _MapboxPathExampleState createState() => _MapboxPathExampleState();
}

class _MapboxPathExampleState extends State<MapboxPathExample> {
  static const String mapboxAccessToken =
      "pk.eyJ1IjoibW9ra3MiLCJhIjoiY20zdno3MXl1MHozNzJxcXp5bmdvbTllYyJ9.Ed_O6F-c2IZJE9DoCyPZ2Q";
  LatLng? _currentLocation;
  Set<Marker> _markers = {};
  Set<Polyline> _polylines = {};
  String? _routeDistance;
  String? _routeDuration;

  final Completer<GoogleMapController> _mapController = Completer();

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    try {
      if (!await Geolocator.isLocationServiceEnabled()) {
        await Geolocator.openLocationSettings();
        throw Exception('Location services are disabled.');
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw Exception('Location permissions are denied.');
        }
      }

      if (permission == LocationPermission.deniedForever) {
        throw Exception('Location permissions are permanently denied.');
      }

      Position position = await Geolocator.getCurrentPosition();
      setState(() {
        _currentLocation = LatLng(position.latitude, position.longitude);
        _markers.add(
          Marker(
            markerId: const MarkerId("current_location"),
            position: _currentLocation!,
            infoWindow: const InfoWindow(title: "My Location"),
            icon:
                BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
          ),
        );
      });

      _animateToLocation(_currentLocation!);
      _getRoute(widget
          .destination); // Fetch the route once the current location is available
    } catch (e) {
      debugPrint('Error fetching location: $e');
    }
  }

  Future<void> _animateToLocation(LatLng location) async {
    final GoogleMapController controller = await _mapController.future;
    controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: location, zoom: 14.0),
      ),
    );
  }

  Future<void> _getRoute(LatLng destination) async {
    if (_currentLocation == null) return;

    final String url = "https://api.mapbox.com/directions/v5/mapbox/driving/"
        "${_currentLocation!.longitude},${_currentLocation!.latitude};"
        "${destination.longitude},${destination.latitude}"
        "?alternatives=true&geometries=geojson&steps=true&access_token=$mapboxAccessToken";

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final route = data['routes'][0];
        final geometry = route['geometry']['coordinates'] as List;
        final distance = route['distance'] as double; // in meters
        final duration = route['duration'] as double; // in seconds

        setState(() {
          _routeDistance =
              (distance / 1000).toStringAsFixed(2); // Convert to kilometers
          _routeDuration = _formatDuration(duration.toInt());

          _polylines.clear();
          _polylines.add(
            Polyline(
              polylineId: const PolylineId("route"),
              points: geometry
                  .map(
                      (coord) => LatLng(coord[1] as double, coord[0] as double))
                  .toList(),
              color: Colors.blue,
              width: 4,
            ),
          );

          _markers.add(
            Marker(
              markerId: const MarkerId("destination"),
              position: destination,
              infoWindow: InfoWindow(title: widget.destinationTitle),
            ),
          );
        });

        // Animate camera to show route
        _fitBoundsToRoute(
          [_currentLocation!, destination],
        );
      } else {
        throw Exception('Failed to fetch directions');
      }
    } catch (e) {
      debugPrint('Error fetching route: $e');
    }
  }

  Future<void> _fitBoundsToRoute(List<LatLng> points) async {
    double minLat = points.first.latitude;
    double maxLat = points.first.latitude;
    double minLng = points.first.longitude;
    double maxLng = points.first.longitude;

    for (var point in points) {
      if (point.latitude < minLat) minLat = point.latitude;
      if (point.latitude > maxLat) maxLat = point.latitude;
      if (point.longitude < minLng) minLng = point.longitude;
      if (point.longitude > maxLng) maxLng = point.longitude;
    }

    final bounds = LatLngBounds(
      southwest: LatLng(minLat, minLng),
      northeast: LatLng(maxLat, maxLng),
    );

    final GoogleMapController controller = await _mapController.future;
    controller.animateCamera(CameraUpdate.newLatLngBounds(bounds, 50));
  }

  String _formatDuration(int seconds) {
    final hours = seconds ~/ 3600;
    final minutes = (seconds % 3600) ~/ 60;

    if (hours > 0) {
      return '$hours h ${minutes.toString().padLeft(2, '0')} min';
    } else {
      return '$minutes min';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _currentLocation == null
          ? const Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: _currentLocation!,
                    zoom: 14.0,
                  ),
                  markers: _markers,
                  polylines: _polylines,
                  onMapCreated: (controller) {
                    _mapController.complete(controller);
                  },
                  myLocationEnabled: true,
                  myLocationButtonEnabled: true,
                ),
                if (_routeDistance != null && _routeDuration != null)
                  Positioned(
                    bottom: 16,
                    left: 16,
                    right: 80,
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Distance: $_routeDistance km"),
                            Text("Duration: $_routeDuration"),
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            ),
    );
  }
}
