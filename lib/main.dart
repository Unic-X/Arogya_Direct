import 'package:arogya_direct/Screens/polygon.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:arogya_direct/screens/map.dart';
 

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp();
  runApp(const Arogya());
}

class Arogya extends StatelessWidget {
  const Arogya({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "ArogyaDirect",
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          iconTheme: IconThemeData(),
          shadowColor: Color.fromARGB(190, 11, 66, 216),
        ),
        primarySwatch: Colors.deepPurple,
      ),
      home: const Polygon_Map(),
    );
  }
}


// class FireMap extends StatefulWidget {
//   @override
//   State createState() => FireMapState();
// }


// class FireMapState extends State<FireMap> {
//   GoogleMapController mapController;
//    Location location = new Location();
//   @override
//   build(context) {
//     return Stack(children:[
//       GoogleMap(
//         initialCameraPosition:  CameraPosition(
//           target: LatLng(),
//           zoom: 15
//       ),
//       onMapCreated: _onMapCreated,
//       myLocationEnabled: true,
//       )
//     ]);
//     // widgets go here
//   }
//   _onMapCreated(GoogleMapController controller){
//     setState(() {
//       mapController = controller;
      
//     });
//   }
// }

