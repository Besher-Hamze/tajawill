import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:get/get.dart';

import '../../models/service_model.dart';
import '../../services/service_service.dart';

class NearestPlacesScreen extends StatefulWidget {
  const NearestPlacesScreen({Key? key}) : super(key: key);

  @override
  _NearestPlacesScreenState createState() => _NearestPlacesScreenState();
}

class _NearestPlacesScreenState extends State<NearestPlacesScreen> {
  List<Service> _nearestPlaces = [];
  bool _isLoading = true;
  Position? _currentPosition;
  GoogleMapController? _mapController;
  Set<Marker> _markers = {};
  Set<Circle> _circles = {};

  @override
  void initState() {
    super.initState();
    _fetchNearestPlaces();
  }

  Future<void> _fetchNearestPlaces() async {
    try {
      _currentPosition = await _getCurrentLocation();

      if (_currentPosition != null) {
        final placeService = PlaceService();
        final nearestPlaces = await placeService.getNearestPlaces(
          latitude: _currentPosition!.latitude,
          longitude: _currentPosition!.longitude,
          radiusInKm: 1.0,
        );

        setState(() {
          _nearestPlaces = nearestPlaces;
          _isLoading = false;
          _createMarkersAndCircles();
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching nearest places: $e')),
      );
    }
  }

  void _createMarkersAndCircles() {
    _markers.clear();
    _circles.clear();

    // Add current location marker
    _markers.add(
      Marker(
        markerId: const MarkerId('current_location'),
        position: LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        infoWindow: const InfoWindow(title: 'My Location'),
      ),
    );

    // Add markers for nearest places
    for (var place in _nearestPlaces) {
      _markers.add(
        Marker(
          markerId: MarkerId(place.id),
          position: LatLng(place.latitude, place.longitude),
          infoWindow: InfoWindow(
            title: place.name,
            snippet: 'Tap to view details',
            onTap: () {
              Get.toNamed('/place-details', arguments: place);
            },
          ),
        ),
      );
    }

    // Add circle for 1km radius
    _circles.add(
      Circle(
        circleId: const CircleId('1km_radius'),
        center: LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
        radius: 1000, // 1 kilometer in meters
        fillColor: Colors.blue.withOpacity(0.2),
        strokeColor: Colors.blue,
        strokeWidth: 2,
      ),
    );
  }

  Future<Position?> _getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Location services are disabled')),
      );
      return null;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Location permissions are denied')),
        );
        return null;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Location permissions are permanently denied')),
      );
      return null;
    }

    return await Geolocator.getCurrentPosition();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading || _currentPosition == null
          ? const Center(child: CircularProgressIndicator())
          : GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
          zoom: 14,
        ),
        markers: _markers,
        circles: _circles,
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
        onMapCreated: (controller) {
          _mapController = controller;
        },
      ),
    );
  }
}