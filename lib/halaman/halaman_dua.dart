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
    // BitmapDescriptor.fromAssetImage(
    //       ImageConfiguration(size: Size(48, 48)), 'assets/user_icon.png')
    //       .then((onValue) {
    //     myIcon = onValue;
    //   });
    // user_markers.add(
    //   Marker(
    //     markerId: MarkerId(_userPostion.toString()),
    //     position: _userPostion,
    //     icon: myIcon,
    //   ),
    // );
      
    // getSharedPreferences();
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }
  
  // FOTO AND NAME
  Future <String> getData() async{
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      foto = pref.getString('photo');
      name = pref.getString('full_name');
    });
  }

  // Time
  var formattedDate = '';
  var formattedTime = '';
  double hourNow = 0.0;
  getTime(){
    DateTime now = DateTime.now();
    String dateNow = DateFormat.yMMMMEEEEd().format(now);
    String timeNow = DateFormat('kk.mm').format(now);
    double timeNowDouble = double.parse(timeNow);
    setState(() {
      hourNow = timeNowDouble;
      formattedDate = dateNow;
      formattedTime = timeNow;
    });
  }

  // @override
  // void initState(){
  //   getData();
  //   super.initState();
  // }
  void _absen(context, pr) async{
    getTime();
    pr.show();
    if (hourNow <= 08.00){
      print("Excellent");
    }
    else if (hourNow <= 08.30){
      print("Normal");
    }
    else if (hourNow <= 09.00){
      print("Late");
    }
    else if (hourNow > 09.00){
      print("Danger");
      // print(pr);
      // pr.hide(true);
      
    }
    
      Future.delayed(Duration(seconds: 1)).then((onValue){
        print("PR status  ${pr.isShowing()}" );
          if(pr.isShowing())
            pr.hide();
          print("PR status  ${pr.isShowing()}" );
      });

  }

  @override
  Widget build(BuildContext context){
    pr = new ProgressDialog(context, type: ProgressDialogType.Normal);
    // date
    
    // DateFormat('kk:mm:ss \n EEE d MMM').format(now);
    
    return Scaffold(
      appBar: AppBar(
        title: new Text(
          "Absensi", 
          style: TextStyle(
          ),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom:Radius.circular(30),
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(88.0),
          // Di isi child, untuk widget yang akan ditampilkan
          child: Row(
            children:<Widget>[
              Padding(
                padding: const EdgeInsets.only(bottom:10, left: 25),
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
                  // backgroundColor: Colors.green,  
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text("Good Day", style: TextStyle(color: Colors.white),),
                    Text('$name', style: TextStyle(color: Colors.white),),
                  ],
                ),
              )
            ],
          ),
        )
      ),
      drawer: DrawerApp(),
      body: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Padding(
            padding: const EdgeInsets.only(left: 40, top: 15, bottom: 15),
            child: FloatingActionButton(
              elevation: 0.0,
              child: new IconButton(
                icon : new Icon(
                  Icons.fingerprint,
                  
                ),
                iconSize: 40,
                onPressed:(){
                  _absen(context, pr);
                  // Alert(context: context, title: "RFLUTTER", desc: "Flutter is awesome.").show();
                },
                
                
              )
            ),
          ),
          Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
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
                          child:Text(formattedTime, style: TextStyle(color: Colors.black),),
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
            height: 135,
            margin: const EdgeInsets.symmetric(horizontal: 10),
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
            padding: const EdgeInsets.only(top: 5),
            child: Text(
              "Check in Activity",
            ),
          ),
          
          Container(
            height: 150,
            margin: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.grey,
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
              itemCount: 100,
              itemBuilder: (BuildContext context, int index){
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: 3),
                  child:  Container(
                  height: 25,
                  width: 85,
                  decoration: BoxDecoration(
                    color: Colors.white60,
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
                        "Nama User checked in at Time",
                      ),
                    ],
                  ),
                ));
            }),
          ),
        ],
      ),
    );
  }
}