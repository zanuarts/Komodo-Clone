import 'package:flutter/material.dart';
import 'package:komodo_ui/halaman/component/attend.dart';
import 'package:komodo_ui/halaman/component/header.dart';
import 'package:komodo_ui/home/drawer.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:komodo_ui/components/attendance.dart';

import 'component/your_location.dart';

class Halamandua extends StatefulWidget {
  @override
  _MyappState createState() => _MyappState();
}

class _MyappState extends State<Halamandua>{
  ProgressDialog pr;

  //get location
  Location location = Location();
  double long;
  double lat;
  LatLng _userPostion = LatLng(0, 0);

  getLocation() async {
    var location = new Location();
    location.onLocationChanged().listen((LocationData currentLocation) {
      setState(() {
        lat = currentLocation.latitude;
        long = currentLocation.longitude;
        _userPostion = LatLng(lat, long);
        print("Lokasi di : ");
        print(_userPostion);
      });
    });
  }

  // GOOGLE MAPS
  final Set<Marker> _markers = {};
  // final Set<Marker> user_markers = {};
  GoogleMapController mapController;
  // final LatLng _center = const LatLng(45.521563, -122.677433);
  LatLng _center = LatLng(-6.897980, 107.619328); // bandung
  
  BitmapDescriptor myIcon;
  @override
  void initState() {
//    getData();
    _markers.add(
      Marker(
        markerId: MarkerId("-6.897980, 107.619328"),
        position: _center,
        icon: BitmapDescriptor.defaultMarker,
      ),
    );
    super.initState();
    getLocation();
    super.initState();
}
  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }
  
  // Time
  bool isLoading = false;

  //WIDGET BUILDER
  @override
  Widget build(BuildContext context){
    pr = new ProgressDialog(context, type: ProgressDialogType.Normal);
    return LayoutBuilder(
      builder: (context, constraints){
        return Scaffold(
          // resizeToAvoidBottomInset: false,
      drawer: DrawerApp(),
      body: Column(
        children: <Widget>[
          Header(),
          Attend(),
          Container(
            padding: const EdgeInsets.only(top: 5, left: 10),
            alignment: Alignment.centerLeft,
            child: Text(
              "Check in Location",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Container(
            height: 125,
            margin: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
            child: GoogleMap(
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(
              target: _center,
              zoom: 14.0,
              ),
              markers: _markers,
            ),
          ),
          Container(
            padding: const EdgeInsets.only(left:10),
            alignment: Alignment.centerLeft,
            child: Text(
              "Your Location",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Container(
            height: 140,
            margin: const EdgeInsets.all(10),
            // decoration: BoxDecoration(
            //   color: Colors.white,
            //   borderRadius: BorderRadius.all(Radius.circular(10)),
            // ),
            child: Column(
              children: <Widget>[
                Container(
                  child: YourLocation()
                  
                )
              ],
            ),
          )
        ]
        )
        );
      },
    );
  }
}