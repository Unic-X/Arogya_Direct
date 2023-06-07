import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:arogya_direct/Screens/map_style.dart';
import 'package:toggle_switch/toggle_switch.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});
  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  LatLng currentLocation = const LatLng(21.1283, 81.7663);

  late BitmapDescriptor currentIcon = BitmapDescriptor.defaultMarker;

  LatLng initialLocation = const LatLng(37.422131, -122.084801);

  Set<Circle> circles_ = {
    const Circle(
      circleId: CircleId("test"),
      center: LatLng(21.1283, 81.7663),
      radius: 4000,
      strokeWidth: 2,
      fillColor: Color.fromARGB(50, 229, 154, 3),
    ),
  };

  @override
  void initState() {
    setMarker();
    _locationListner();
    super.initState();
  }

  Future<void> _locationListner() async {
    final GoogleMapController controller = await _controller.future;

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error("Permission denied ");
      }
    }

    LocationSettings locationSettings = const LocationSettings(
      accuracy: LocationAccuracy.best,
      distanceFilter: 5,
    );

    Geolocator.getPositionStream(locationSettings: locationSettings)
        .listen((Position? position) async {
      await controller
          .animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target: LatLng(position!.latitude, position.longitude),
        zoom: 17,
      )));
      setState(() {
        currentLocation = LatLng(position.latitude, position.longitude);
      });
    });
  }

  void setMarker() async {
    await BitmapDescriptor.fromAssetImage(
            ImageConfiguration.empty, 'assets/marker.png')
        .then((icon) {
      currentIcon = icon;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Arogya Direct"),
      ),
      body: GoogleMap(
        mapType: MapType.normal,
        compassEnabled: true,
        myLocationButtonEnabled: true,
        initialCameraPosition: CameraPosition(
          target: initialLocation,
          zoom: 14,
        ),
        markers: {
          Marker(
              markerId: MarkerId("currentPos"),
              position:
                  LatLng(currentLocation.latitude, currentLocation.longitude),
              icon: BitmapDescriptor.defaultMarkerWithHue(
                  BitmapDescriptor.hueAzure))
        },
        circles: {
          Circle(
            circleId: const CircleId("Larger"),
            center: LatLng(currentLocation.latitude, currentLocation.longitude),
            radius: 100,
            strokeWidth: 0,
            fillColor: const Color.fromARGB(31, 1, 134, 251),
          ),
          Circle(
            circleId: const CircleId("Smaller"),
            center: LatLng(currentLocation.latitude, currentLocation.longitude),
            radius: 40,
            strokeWidth: 0,
            fillColor: const Color.fromARGB(53, 4, 123, 241),
          ),
        },
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
          controller.setMapStyle(MapStyle().dark);
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: ToggleSwitch(
        activeBgColor: List.from({Color.fromARGB(77, 4, 241, 174)}),
        inactiveFgColor: Color.fromARGB(193, 255, 255, 255),
        initialLabelIndex: 0,
        totalSwitches: 2,
        labels: ['Night', 'Light'],
        onToggle: (index) async {
          final GoogleMapController controller = await _controller.future;
          index == 0
              ? controller.setMapStyle(MapStyle().night)
              : controller.setMapStyle(MapStyle().retro);
        },
      ),
    );
  }
}
