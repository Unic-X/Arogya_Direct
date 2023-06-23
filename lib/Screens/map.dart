import 'dart:async';
import 'dart:html';
import 'package:firebase_database/firebase_database.dart';
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
      
  final usernameController = TextEditingController();
  final userEmailController = TextEditingController();    

  LatLng currentLocation = const LatLng(21.1283, 81.7663);
  late BitmapDescriptor currentIcon = BitmapDescriptor.defaultMarker;

  Set<Circle> circles_ = Set.from([
    Circle(
      circleId: CircleId("test"),
      center: LatLng(21.1283, 81.7663),
      radius: 4000,
      strokeWidth: 2,
      fillColor: Color.fromARGB(50, 229, 154, 3),
    ),
  ]);
  late DatabaseReference dbRef;


  @override
  void initState() {
    _locationListner();
    super.initState();
    //dbRef = FirebaseDatabase.instance.ref().child('location');
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
        //Future<DoccumentReference> _addPoint() async {
          //var pos = await location.getlocation();
          //GeoFirePoint point = geo.point(latitude:)
        //}
      setState(() {
        currentLocation = LatLng(position.latitude, position.longitude);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("alala"),),
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
        circles: currentLocation == null
            ? circles_
            : {
                Circle(
                  circleId: CircleId("test3"),
                  center: LatLng(
                      currentLocation!.latitude!, currentLocation!.longitude!),
                  radius: 100,
                  strokeWidth: 0,
                  fillColor: Color.fromARGB(31, 1, 134, 251),
                ),
                
                
                Circle(
                  circleId: CircleId("test2"),
                  center: LatLng(
                      currentLocation!.latitude!, currentLocation!.longitude!),
                  radius: 40,
                  strokeWidth: 0,
                  fillColor: Color.fromARGB(53, 4, 123, 241),
                ),
              
               
              },
              
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
          MaterialButton(
                  onPressed: (){
                    Map<String, String> location = {
                      'username': usernameController.text,
                      'useremail': userEmailController.text,
                    };
                    dbRef.push().set(location);
                  },
                );
           
        },
      ),
    );
  }
}
