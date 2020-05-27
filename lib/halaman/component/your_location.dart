import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class YourLocation extends StatefulWidget {
  @override
  _YourLocationState createState() => _YourLocationState();
}

class _YourLocationState extends State<YourLocation> {
  double jarakQ = 0.0;
  
  checkJarak()async{
    jarakQ = await Geolocator().distanceBetween(lat, long, -6.897980, 107.619328);
  }
  

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
      });
    });
  }

  @override
  void initState(){
    super.initState();
    getLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Text(
            "Distance : " + jarakQ.toString() + " m",
          ),
          RaisedButton(
            color: Colors.blueAccent,
            child: Text(
              "Check Distance",
              style: TextStyle(color: Colors.white),
            ), 
            onPressed: () {
              checkJarak();
            },
          )
        ],),
    );
  }
}