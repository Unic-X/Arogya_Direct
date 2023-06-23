import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:maps_toolkit/maps_toolkit.dart' as map_tool;

class Polygon_Map extends StatefulWidget {
  const Polygon_Map({Key? key}) : super(key: key);

  @override
  State<Polygon_Map> createState() => _Polygon_MapState();
}
//samos SWASTI//Kanika egg
class _Polygon_MapState extends State<Polygon_Map> {
  final Completer<GoogleMapController> _controller = Completer();
  BitmapDescriptor markerbitmap = BitmapDescriptor.defaultMarker;

  LatLng intialLocation = const LatLng(23.762912, 90.427816);
  bool isInSelectedArea = true;
  List<LatLng> Polygonpoints = const [
    LatLng(23.766315, 90.425778),
    LatLng(23.76, 90.424767),
    LatLng(23.76, 90.42),
    LatLng(23.76, 90.42),
    LatLng(23.76, 90.42),
    LatLng(23.72, 90.43),
  ];

  @override
  void initState() {
    super.initState();
  }

  void checkUpdatedLocation(LatLng pointLatLn) {
    List<map_tool.LatLng> convertedPolygonPoints = Polygonpoints.map((point) => map_tool.LatLng(point.latitude, point.longitude)).toList();
    setState(() {
      isInSelectedArea = map_tool.PolygonUtil.containsLocation(
        map_tool.LatLng(pointLatLn.latitude, pointLatLn.longitude),
        convertedPolygonPoints,
        false,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: GoogleMap(
              initialCameraPosition: CameraPosition(
                target: intialLocation,
                zoom: 15.6746,
              ),
              onMapCreated: (controller) {
                _controller.complete(controller);
              },
              markers: {
                Marker(
                  markerId: MarkerId("marker"),
                  position: intialLocation,
                  icon: markerbitmap,
                  draggable: true,
                  onDragEnd: (updatedLatLng) {
                    checkUpdatedLocation(updatedLatLng);
                  },
                ),
              },
              polygons: {
                Polygon(
                  polygonId: const PolygonId("1"),
                  fillColor: Color.fromARGB(255, 4, 83, 67).withOpacity(0.1),
                  strokeWidth: 2,
                  points: Polygonpoints,
                ),
              },
            ),
          ),
        ],
      ),
    );
  }
}
