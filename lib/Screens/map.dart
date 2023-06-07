import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});
  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  Set<Circle> circles_ = Set.from([
    Circle(
      circleId: CircleId("test"),
      center: LatLng(37.422131, -122.084801),
      radius: 4000,
      strokeWidth: 2,
      fillColor: Color.fromARGB(50, 229, 154, 3),
    )
  ]);

  @override
  void initState() {
    _locationListner();
    super.initState();
  }

  LatLng initialLocation = const LatLng(37.422131, -122.084801);

  Future<void> _locationListner() async {
    final GoogleMapController controller = await _controller.future;

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error("Galat");
      }
    }

    LocationSettings locationSettings = const LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 10,
    );

    Geolocator.getPositionStream(locationSettings: locationSettings)
        .listen((Position? position) async {
      print('${position!.latitude}   ${position!.longitude}');
      await controller
          .animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target: LatLng(position.latitude, position.longitude),
        zoom: 14,
      )));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        mapType: MapType.normal,
        compassEnabled: true,
        initialCameraPosition: CameraPosition(
          target: initialLocation,
          zoom: 14,
        ),
        circles: circles_,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
      ),
    );
  }
}
