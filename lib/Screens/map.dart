import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:arogya_direct/Screens/map_style.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:maps_toolkit/maps_toolkit.dart' as map_tool;
import 'package:arogya_direct/Screens/notification_api.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});
  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  String? uid = FirebaseAuth.instance.currentUser?.uid;

  final _usersStream =
      FirebaseFirestore.instance.collection('location').snapshots();

  final Completer<GoogleMapController> _controller = Completer<
      GoogleMapController>(); //Controller controls the map actions like position of it etc

  LatLng currentLocation =
      const LatLng(21.1282267, 81.7653267); //Latitude longitude of the college

  late BitmapDescriptor currentIcon =
      BitmapDescriptor.defaultMarker; //Not working {Custom Marker for the user}

  Set<LatLng> others_pos = Set<LatLng>();

  LatLng initialLocation =
      const LatLng(37.422131, -122.084801); //initial location of the marker

  final Set<Marker> markers = new Set();
  final Map<String, Marker> _markers = {};

  Set<Circle> circles_ = {
//Set of circles which will be shown to the client of different users near that region
  };

  bool isInSelectedArea = false;
  List<LatLng> Polygonpoints = const [
    LatLng(21.128354, 81.7667634),
    LatLng(21.1285167, 81.766664),
    LatLng(21.1286697, 81.766936),
    LatLng(21.1285068, 81.7670403),
  ];

  List<LatLng> Polygonpoints_ = const [
    LatLng(21.129048, 81.764799),
    LatLng(21.129593, 81.765022),
    LatLng(21.129858, 81.766461),
    LatLng(21.128975, 81.767150),
    LatLng(21.128921, 81.766413),
    LatLng(21.129197, 81.766187),
    LatLng(21.128874, 81.765367),
  ];

  List<LatLng> PalmPark = const [
    LatLng(21.127331, 81.764824),
    LatLng(21.127811, 81.765065),
    LatLng(21.128036, 81.765806),
    LatLng(21.127666, 81.766052),
    LatLng(21.127015, 81.765816),
  ];

  void _updateMarkers() async {
    _usersStream.listen(
      (event) {
        var list = event.docChanges; //Listens to all the document that change
        for (var item in list) {
          //Iterate through every changed document

          var itemDoc = item.doc;
          var itemData = itemDoc.data();

          if (uid != itemDoc.id) {
            final LatLng newPosition =
                LatLng(itemData?['latitude'], itemData?['longitude']);
            if (_markers.containsKey(itemDoc.id)) {
              Marker marker = _markers[itemDoc.id]!;
              marker = marker.copyWith(positionParam: newPosition);
              Set<Circle> circles = {
                Circle(
                  circleId: CircleId("${itemDoc.id}_smaller"),
                  center: newPosition,
                  radius: 40,
                  strokeWidth: 0,
                  fillColor: Color.fromARGB(53, 241, 4, 63),
                ),
                Circle(
                  circleId: CircleId("${itemDoc.id}_bigger"),
                  center: newPosition,
                  radius: 70,
                  strokeWidth: 0,
                  fillColor: Color.fromARGB(100, 160, 29, 62),
                ),
              };
              _addCircles(circles);
              _addMarker(marker);
            } else {
              final Marker marker = Marker(
                markerId: MarkerId(itemDoc.id),
                position: newPosition,
              );

              Set<Circle> circles = {
                Circle(
                  zIndex: 2,
                  circleId: CircleId("${itemDoc.id}_smaller"),
                  center: newPosition,
                  radius: 40,
                  strokeWidth: 0,
                  fillColor: Color.fromARGB(53, 241, 4, 63),
                ),
                Circle(
                  circleId: CircleId("${itemDoc.id}_bigger"),
                  center: newPosition,
                  radius: 70,
                  strokeWidth: 0,
                  fillColor: Color.fromARGB(100, 160, 29, 62),
                ),
              };
              _addCircles(circles);
              _addMarker(marker);
            }
            setState(() {}); //render everytime
            //check every other user except the current user

            double distance = Geolocator.distanceBetween(
                newPosition.latitude,
                newPosition.longitude,
                currentLocation.latitude,
                currentLocation.longitude);

            print(distance);

            print(
                "Latitude: ${newPosition.latitude} , Longitude: ${newPosition.longitude}");
          }
        }
      },
    );
  }

  void checkUpdatedLocation(LatLng pointLatLn) {
    List<map_tool.LatLng> convertedPolygonPoints = Polygonpoints.map(
        (point) => map_tool.LatLng(point.latitude, point.longitude)).toList();
    setState(() {});
    isInSelectedArea = map_tool.PolygonUtil.containsLocation(
      map_tool.LatLng(pointLatLn.latitude, pointLatLn.longitude),
      convertedPolygonPoints,
      false,
    );

    List<map_tool.LatLng> convertedPolygonPoints2 = Polygonpoints_.map(
        (point) => map_tool.LatLng(point.latitude, point.longitude)).toList();
    setState(() {});

    bool isInSelectedArea_ = map_tool.PolygonUtil.containsLocation(
      map_tool.LatLng(pointLatLn.latitude, pointLatLn.longitude),
      convertedPolygonPoints2,
      false,
    );

    if (isInSelectedArea_) {
      NotificationApi.showNotification(
          id: 1, title: "Inside ssFG", body: "You are now inside FG");
    }

    if (isInSelectedArea) {
      NotificationApi.showNotification(
          id: 2,
          title: "Qurantine Zone",
          body: "You are now inside a quarantine zone");
    }
  }

  @override
  void initState() {
    setMarker();
    _updateMarkers(); //Listen to location update of other user and update the marker likewise
    _locationListner();
    super.initState();
  }

  Set<Circle> _addCircles(Set<Circle> circles) {
    circles_.addAll(circles);
    return circles_;
  }

  Set<Marker> _addMarker(Marker marker) {
    markers.add(marker);
    return markers;
  }

  //listen for location updates using GeoLocator
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
      distanceFilter: 1,
    );

    Geolocator.getPositionStream(locationSettings: locationSettings)
        .listen((Position? position) async {
      await controller
          .animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target: LatLng(position!.latitude, position.longitude),
        zoom: 17,
      )));
      await FirebaseFirestore.instance.collection('location').doc(uid).set({
        'latitude': position.latitude,
        'longitude': position.longitude,
        'name': 'wick',
      });
      checkUpdatedLocation(LatLng(position.latitude, position.longitude));
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
      appBar: AppBar(),
      body: GoogleMap(
        mapType: MapType.normal,
        compassEnabled: true,
        zoomGesturesEnabled: true,
        myLocationButtonEnabled: true,
        initialCameraPosition: CameraPosition(
          target: currentLocation,
          zoom: 14,
        ),
        markers: _addMarker(Marker(
            markerId: MarkerId("currentPos"),
            position:
                LatLng(currentLocation.latitude, currentLocation.longitude),
            icon: BitmapDescriptor.defaultMarkerWithHue(
                BitmapDescriptor.hueAzure))),
        circles: _addCircles(
          {
            Circle(
              circleId: const CircleId("Larger"),
              center:
                  LatLng(currentLocation.latitude, currentLocation.longitude),
              radius: 100,
              strokeWidth: 0,
              fillColor: const Color.fromARGB(31, 1, 134, 251),
            ),
            Circle(
              circleId: const CircleId("Smaller"),
              center:
                  LatLng(currentLocation.latitude, currentLocation.longitude),
              radius: 40,
              strokeWidth: 0,
              fillColor: const Color.fromARGB(53, 4, 123, 241),
            ),
          },
        ),
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
          controller.setMapStyle(MapStyle().uber_style);
        },
        polygons: {
          Polygon(
              polygonId: const PolygonId("0"),
              fillColor: Color.fromARGB(227, 81, 230, 244).withOpacity(0.4),
              strokeWidth: 1,
              points: Polygonpoints_),
          Polygon(
            polygonId: const PolygonId("1"),
            fillColor: Color.fromARGB(228, 255, 17, 0).withOpacity(0.1),
            strokeWidth: 1,
            points: Polygonpoints,
          ),
          Polygon(
            polygonId: const PolygonId("2"),
            fillColor: Color.fromARGB(227, 73, 186, 20).withOpacity(0.1),
            strokeWidth: 1,
            points: PalmPark,
          ),
        },
      ),
      bottomNavigationBar: BottomAppBar(
        shape: null,
        child: Container(
          height: 75,
          child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                IconButton(onPressed: () {}, icon: Icon(Icons.home)),
                IconButton(onPressed: () {}, icon: Icon(Icons.search)),
                IconButton(onPressed: () {}, icon: Icon(Icons.notifications)),
                IconButton(onPressed: () {}, icon: Icon(Icons.menu)),
              ]),
        ),
      ),
    );
  }

  Future<void> addUsers() async {}
}
