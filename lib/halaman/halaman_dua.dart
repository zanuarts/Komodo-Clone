import 'dart:async';

import 'package:flutter/material.dart';
import 'package:komodo_ui/home/drawer.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:location/location.dart';
import 'package:progress_dialog/progress_dialog.dart';


class Halamandua extends StatefulWidget {
  @override
  _MyappState createState() => _MyappState();
}

class _MyappState extends State {
  ProgressDialog pr;
  var foto;
  var name;
  var waktu = '';

    // FOTO AND NAME
  Future <String> getData() async{
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      foto = pref.getString('photo');
      name = pref.getString('full_name');
    });
  }

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
    getData();
    // getSelamat();
    _markers.add(
      Marker(
        markerId: MarkerId("-6.897980, 107.619328"),
        position: _center,
        icon: BitmapDescriptor.defaultMarker,
      ),
    );
    super.initState();
    getLocation();
    getTime();
    _timeString = _formatDateTime(DateTime.now());
    Timer.periodic(Duration(seconds: 1), (Timer t) => getTime());
    super.initState();
}
  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }
  
  // Time
  var formattedDate = '';
  var formattedTime = '';
  String _timeString;
  double hourNow = 0.0;
  // double sekarang = 0.0;
  String _formatDateTime(DateTime dateTime) {
    return DateFormat('kk.mm').format(dateTime);
  }
  getTime(){
    DateTime now = DateTime.now();
    String dateNow = DateFormat.yMMMMEEEEd().format(now);
    String timeNow = DateFormat('kk.mm').format(now);
    double timeNowDouble = double.parse(timeNow);
    // double tnow = double parse(_timeString);
    final String formattedDateTime = _formatDateTime(now);
    setState(() {
      _timeString = formattedDateTime;
      // sekarang = tnow;
      hourNow = timeNowDouble;
      formattedDate = dateNow;
      formattedTime = timeNow;
    });
  }

  String greeting() {
    var hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good Morning';
    }
    if (hour < 17) {
      return 'Good Afternoon';
    }
    return 'Good Evening';
  }

  void _absen(context, pr) async{
    getTime();
    pr.show();
    Future.delayed(Duration(seconds: 1)).then((onValue){
        print("PR status  ${pr.isShowing()}" );
        if (hourNow <= 08.00){
          print("Excellent");
          if(pr.isShowing())
            pr.hide();
        }
        else if (hourNow <= 08.30){
          print("Normal");
          if(pr.isShowing())
            pr.hide();
        }
        else if (hourNow <= 09.00){
          print("Late");
          if(pr.isShowing())
            pr.hide();
            Alert(context: context, title: "WARNING", desc: "Anda telat").show();
        }
        else if (hourNow > 09.00){
          print("Danger");
          if(pr.isShowing())
            pr.hide();
            Alert(context: context, title: "WARNING", desc: "Anda telat").show();
        }
          print("PR status  ${pr.isShowing()}" );
          
      });
  }

  @override
  Widget build(BuildContext context){
    pr = new ProgressDialog(context, type: ProgressDialogType.Normal);
    return LayoutBuilder(
      builder: (context, constraints){
        return Scaffold(
      drawer: DrawerApp(),
      body: Column(
        children: <Widget>[
          Container(
            height:160,
            decoration: BoxDecoration(
              color: Colors.deepOrange,
              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(30), bottomRight:Radius.circular(30)),
              boxShadow: [
                BoxShadow(
                  color: Colors.deepOrangeAccent,
                  blurRadius: 10.0, // has the effect of softening the shadow
                  spreadRadius: 0.25, // has the effect of extending the shadow
                  offset: Offset(
                    5.0, // horizontal, move right 10
                    5.0, // vertical, move down 10
                  ),
                )
              ],
            ),
            child: Column(
              children: <Widget>[
                // ABSENCE
                Container(
                  padding: EdgeInsets.all(10),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Absence",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                      color: Colors.white,
                    ),
                  ),
                ),
                // ROW UNTUK FOTO DAN NAMA
                Row(
                  children: <Widget>[
                    //FOTO
                    Container(
                      padding: const EdgeInsets.only(left:35, bottom: 10, right: 10, top: 10),
                      
                      child:  CircleAvatar(
                        radius: 40,
                        child: ClipOval(
                        child: Image.network(
                          '$foto',
                          width: 200,
                          height: 200,
                          fit: BoxFit.cover,
                        ),
                        )
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          // _selamat(),
                          Text(greeting(), style: TextStyle(color: Colors.white),),
                          Text('$name', style: TextStyle(color: Colors.white),),
                        ]
                      )
                    )
                  ],
                )
              ],
            ),
            
          ),
          Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 10, top: 25, bottom: 15),
                // child: Container(
                child: FloatingActionButton(
                  backgroundColor: Colors.blueGrey,
                  elevation: 0.0,
                  child: Icon(
                    Icons.fingerprint,
                    size: 40,
                    
                  ),
                  onPressed:(){
                    _absen(context, pr);
                    
                  },
                ),
              ),
          Padding(
                padding: const EdgeInsets.only(left: 10, top: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Icon(
                          Icons.calendar_today,
                          size: 15,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child:Text(formattedDate, style: TextStyle(color: Colors.black),),
                        ),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Icon(
                          Icons.timer,
                          size: 15,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child:Text(_timeString, style: TextStyle(color: Colors.black),),
                        ),
                      ],
                    ),
                    Text('Press the button to checkpoint', style: TextStyle(color: Colors.black),),
                  ],
                ),
              )
            ],
          ),
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
              color: Colors.blueAccent,
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
            child: GoogleMap(
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(
              target: _center,
              zoom: 14.0,
              ),
              markers: _markers,
              // markers: user_markers,
            ),
            // child: Center(
            //   child: Text(
            //     "Maps",
            //     style: TextStyle(color : Colors.white),
            //   ),
            // ),
          ),
          Container(
            padding: const EdgeInsets.only(left:10),
            alignment: Alignment.centerLeft,
            child: Text(
              "Check in Activity",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                
              ),
            ),
          ),
          
          Container(
            height: 140,
            margin: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            // child: ListView(
            //   children: <Widget>[
            //     Container(
            //       margin: const EdgeInsets.only(top:1),
            //       height: 25,
            //       width: 85,
            //       decoration: BoxDecoration(
            //         color: Colors.white60,
            //       ),
            //       child: Row(
            //       children: <Widget>[
            //         Container(
            //           margin: const EdgeInsets.all(5),
            //           alignment: Alignment.center,
            //           height: 20,
            //           width: 80,
            //           decoration: BoxDecoration(
            //             color: Colors.green,
            //             borderRadius: BorderRadius.all(Radius.circular(5))
            //           ),
            //           child: Text(
            //             "Excellent"
            //           ),
            //         ),
            //         Text(
            //           "Nama User checked in at Time",
            //         ),
            //       ],
            //     ),
            //     ),
            //     Container(
            //       margin: const EdgeInsets.only(top:1),
            //       height: 25,
            //       width: 85,
            //       decoration: BoxDecoration(
            //         color: Colors.white60,
            //       ),
            //       child: Row(
            //         children: <Widget>[
            //           Container(
            //             margin: const EdgeInsets.all(5),
            //             alignment: Alignment.center,
            //             height: 20,
            //             width: 80,
            //             decoration: BoxDecoration(
            //               color: Colors.blue,
            //               borderRadius: BorderRadius.all(Radius.circular(5))
            //             ),
            //             child: Text(
            //               "Normal"
            //             ),
            //           ),
            //           Text(
            //             "Nama User checked in at Time",
            //           ),
            //         ],
            //       ),
            //     ),
            //     Container(
            //       margin: const EdgeInsets.only(top:1),
            //       height: 25,
            //       width: 85,
            //       decoration: BoxDecoration(
            //         color: Colors.white60,
            //       ),
            //       child: Row(
            //         children: <Widget>[
            //           Container(
            //             margin: const EdgeInsets.all(5),
            //             alignment: Alignment.center,
            //             height: 20,
            //             width: 80,
            //             decoration: BoxDecoration(
            //               color: Colors.yellow,
            //               borderRadius: BorderRadius.all(Radius.circular(5))
            //             ),
            //             child: Text(
            //               "Late"
            //             ),
            //           ),
            //           Text(
            //             "Nama User checked in at Time",
            //           ),
            //         ],
            //       ),
            //     ),
            //     Container(
            //       margin: const EdgeInsets.only(top:1),
            //       height: 25,
            //       width: 85,
            //       decoration: BoxDecoration(
            //         color: Colors.white60,
            //       ),
            //       child: Row(
            //         children: <Widget>[
            //           Container(
            //             margin: const EdgeInsets.all(5),
            //             width: 80,  
            //             alignment: Alignment.center,
            //             height: 20,
            //             decoration: BoxDecoration(
            //               color: Colors.red,
            //               borderRadius: BorderRadius.all(Radius.circular(5))
            //             ),
            //               child: Text(
            //                 "Danger",
            //               ),
            //           ),
            //           Text(
            //             "Nama User checked in at Time",
            //           ),
            //         ],
            //       ),
            //     ),
            //   ],
            // ),
            child: ListView.builder(
              itemCount: 1,
              itemBuilder: (BuildContext context, int index){
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: 3),
                  child:  Container(
                  height: 35,
                  width: 85,
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.all(Radius.circular(5))
                  ),
                  child: Row(
                    children: <Widget>[
                      Container(
                        margin: const EdgeInsets.all(5),
                        width: 80,  
                        alignment: Alignment.center,
                        height: 20,
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.all(Radius.circular(5))
                        ),
                          child: Text(
                            "Danger",
                          ),
                      ),
                      Text(
                        '$name checked in at $hourNow',
                      ),
                    ],
                  ),
                ));
            }),
          ),
        ],
      ),
        );
      },
    );
  }
}