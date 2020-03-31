import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/io_client.dart';
import 'package:komodo_ui/halaman/component/attend.dart';
import 'package:komodo_ui/halaman/component/header.dart';
// import 'package:komodo_ui/components/helper.dart';
import 'package:komodo_ui/home/drawer.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:location/location.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:komodo_ui/components/globalkey.dart';
import 'dart:convert' as convert;
import 'package:komodo_ui/components/attendance.dart';

class Halamandua extends StatefulWidget {
  @override
  _MyappState createState() => _MyappState();
}

class _MyappState extends State {
  ProgressDialog pr;
  var foto;
  var name;
  var personid;
  var waktu = '';

    // FOTO AND NAME
  Future <String> getData() async{
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      foto = pref.getString('photo');
      name = pref.getString('full_name');
      personid = pref.getString('person_id');

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

  //checkinn checkout
  var cekin = '';
  var cekout = '';
  var reason;
  bool absen = false;

  Color _iconColor = Colors.white;
  Color _iconBackgroundColor = Colors.deepOrange;
  bool isLoading = false;

  _absen(context, pr) async{
    getTime();
    pr.show();
    var url = "$apiwebsite/checkin";
    HttpClient httpClient = new HttpClient()
      ..badCertificateCallback =
      ((X509Certificate cert, String host, int port) => true);
    IOClient ioClient = new IOClient(httpClient);
    
    Future.delayed(Duration(seconds: 1)).then((onValue) async {
        print("PR status  ${pr.isShowing()}" );
        
        if (hourNow <= 08.00){
          print("Excellent");
          await ioClient.post(url, body: {
            "person_id": "$personid",
            "latitude": "$lat",
            "longitude": "$long"
          }).then((response) async {
            if (response.statusCode == 201) {
              //Navigator.pushNamed(context, '/absensi');
              Fluttertoast.showToast(
                msg: "Anda Sukses Checkin",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIos: 1,
                backgroundColor: Colors.green,
                textColor: Colors.white,
                fontSize: 16.0
              );
              var jsonResponse = convert.jsonDecode(response.body);
              var status = jsonResponse['message'];
              if (status == 'success') {
                absen = true;
              }
            }
          if(pr.isShowing())
            pr.hide();
          }); 
        }
        else if (hourNow <= 08.30){
          print("Normal");
          await ioClient.post(url, body: {
            "person_id": "$personid",
            "latitude": "$lat",
            "longitude": "$long"
          }).then((response) async {
            if (response.statusCode == 201) {
              //Navigator.pushNamed(context, '/absensi');
              Fluttertoast.showToast(
                msg: "Anda Sukses Checkin",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIos: 1,
                backgroundColor: Colors.green,
                textColor: Colors.white,
                fontSize: 16.0
              );
              var jsonResponse = convert.jsonDecode(response.body);
              var status = jsonResponse['message'];
              if (status == 'success') {
                absen = true;
              }
            }
          if(pr.isShowing())
            pr.hide();
          }); 
        }
        else if (hourNow <= 09.00){
          print("Late");
          await ioClient.post(url, body: {
            "person_id": "$personid",
            "latitude": "$lat",
            "longitude": "$long"
          }).then((response) async {
            if (response.statusCode == 201) {
              //Navigator.pushNamed(context, '/absensi');
              Fluttertoast.showToast(
                msg: "Anda Sukses Checkin",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIos: 1,
                backgroundColor: Colors.green,
                textColor: Colors.white,
                fontSize: 16.0
              );
              var jsonResponse = convert.jsonDecode(response.body);
              var status = jsonResponse['message'];
              if (status == 'success') {
                absen = true;
              }
            }
          if(pr.isShowing())
            pr.hide();
          }); 
            Alert(context: context, title: "WARNING", desc: "Anda telat").show();
        }
        else if (hourNow > 09.00){
          print("Danger");
          await ioClient.post(url, body: {
            "person_id": "$personid",
            "latitude": "$lat",
            "longitude": "$long"
          }).then((response) async {
            if (response.statusCode == 201) {
              //Navigator.pushNamed(context, '/absensi');
              Fluttertoast.showToast(
                msg: "Anda Sukses Checkin",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIos: 1,
                backgroundColor: Colors.green,
                textColor: Colors.white,
                fontSize: 16.0
              );
              var jsonResponse = convert.jsonDecode(response.body);
              var status = jsonResponse['message'];
              if (status == 'success') {
                absen = true;
              }
            }
          if(pr.isShowing())
            pr.hide();
          }); 
          Alert(context: context, title: "WARNING", desc: "Anda telat").show();
        }
          print("PR status  ${pr.isShowing()}" );
          
      });
    
  }


//WIDGET BUILDER
  @override
  Widget build(BuildContext context){
    pr = new ProgressDialog(context, type: ProgressDialogType.Normal);
    return LayoutBuilder(
      builder: (context, constraints){
        return Scaffold(
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
            child: ListView(
              children: <Widget>[
                Container(
                  child: ConstrainedBox(
                    constraints: new BoxConstraints(minHeight: 0, maxHeight: 1900),
                    child: Attendance(),
                  ),
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