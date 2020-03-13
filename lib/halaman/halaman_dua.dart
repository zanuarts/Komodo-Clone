import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/io_client.dart';
import 'package:komodo_ui/components/helper.dart';
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

  final Helper helper = new Helper();
  Future<Map> get sessionDataSource => helper.getSession();
  var session = {};
  var personid;
  // var name = ' ';
  var userid;
  var username = '';
  getSharedPreferences() async {
    session = await sessionDataSource;
    name = session['full_name'];
    userid = session['userid'];
    personid = session['person_id'];
    setState(() {
      session = session;
      userid = userid;
      personid = personid;
      name = name;
    });
  }

  //checkinn checkout
  var cekin = '';
  var cekout = '';
  var reason;
  bool absen = false;
  Future<Map<String, dynamic>> getAbsence() async {
    print("masuk api gais");
    HttpClient httpClient = new HttpClient()
      ..badCertificateCallback =
      ((X509Certificate cert, String host, int port) => true);
    IOClient ioClient = new IOClient(httpClient);

    return await ioClient.post('$apiwebsite/status_checkin', body: {
      "person_id": "$personid",
    }).then((response) async {
      if (response.statusCode == 201) {
        print("masuk api gais 2");
        var jsonResponse = convert.jsonDecode(response.body);
        var status = jsonResponse['message'];
        var data = jsonResponse['data'];
        // print(data['CHECKIN_TIME'])
        if (status == 'data found') {
          var formatter = new DateFormat('HH:mm');
          var checkInFormatData;
          if (data['checkin_time'] != null) {
            DateTime checkinHour =
            DateTime.parse("0000-00-00 ${data['checkin_time']}");
            checkInFormatData = formatter.format(checkinHour);
          } else {
            checkInFormatData = data['checkin_time'];
          }

          var checkOutFormatData;
          if (data['checkout_time'] != null) {
            DateTime checkoutHour =
            DateTime.parse("0000-00-00 ${data['checkout_time']}");
            checkOutFormatData = formatter.format(checkoutHour);
          } else {
            checkOutFormatData = data['checkout_time'];
          }
          cekin = checkInFormatData;
          cekout = checkOutFormatData;
          //cekin = data['checkin_time'];
          //cekout = data['checkout_time'];

        } else {
          cekin = null;
          cekout = null;
        }

        DateTime dateTimeNowData = DateTime.now();
        String hourNowDataString = DateFormat('kk.mm').format(dateTimeNowData);
        double hourNowDataDouble = double.parse(hourNowDataString);
        //String hourNowFormat = DateFormat('HH:mm').format(dateTimeNowData);
        DateTime dateTimeTommorow = DateTime(dateTimeNowData.year, dateTimeNowData.month, dateTimeNowData.day + 1);
        String tommorowFormat = DateFormat('EEEE, MMMM d y').format(dateTimeTommorow);
        String dateNowFormat = DateFormat('EEEE, MMMM d y').format(dateTimeNowData);

        var dataAbsence = {
          'cekin': cekin,
          'cekout': cekout,
          'jam':hourNowDataString,
          'hourNow' : hourNowDataDouble,
          'tommorow' : tommorowFormat,
          'formattedDate' : dateNowFormat,
        };
        return dataAbsence;
      }
      return null;
    });
  }

  Color _iconColor = Colors.white;
  Color _iconBackgroundColor = Colors.deepOrange;
  bool isLoading = false;

  _alreadyCheckout(context, pr){
    Fluttertoast.showToast(
        msg:
        "Anda Sudah absen Hari ini",
        toastLength:
        Toast.LENGTH_SHORT,
        gravity:
        ToastGravity.BOTTOM,
        timeInSecForIos: 1,
        backgroundColor:
        Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  _checkOut(context, pr) async {
    getTime();
    if (hourNow < 17.00) {
      _openAlertBoxpc(context, pr);
    } else {
      setState(() {
        isLoading = true;
        _iconColor = Colors.grey;
      });

      HttpClient httpClient = new HttpClient()
        ..badCertificateCallback =
        ((X509Certificate cert, String host, int port) => true);
      IOClient ioClient = new IOClient(httpClient);
      var url = "$apiwebsite/checkout";
      await ioClient.post(url, body: {
        "person_id": "$personid",
        "latitude": "$lat",
        "longitude": "$long"
      }).then((response) async {
        if (response.statusCode == 201) {
          var jsonResponse = convert.jsonDecode(response.body);
          var status = jsonResponse['status'];
          if (status == 'success') {
            Fluttertoast.showToast(
                msg: "Anda Sukses Checkout",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIos: 1,
                backgroundColor: Colors.green,
                textColor: Colors.white,
                fontSize: 16.0);
            //Navigator.pushNamed(context, '/absensi');
          } else {
            Fluttertoast.showToast(
                msg: "error system (API)",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIos: 1,
                backgroundColor: Colors.red,
                textColor: Colors.white,
                fontSize: 16.0);
          }
        }
        pr.hide();
      });

      setState(() {
        isLoading = false;
        _iconColor = Colors.white;
      });
    }
  }

  _openAlertBoxpc(context, pr) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(32.0))),
            contentPadding: EdgeInsets.only(top: 10.0),
            content: Container(
              width: 300.0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Text(
                            'Anda pulang cepat',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.red,
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  Divider(
                    color: Colors.grey,
                    height: 4.0,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 30.0, right: 30.0),
                    child: TextField(
                      cursorColor: Colors.deepOrangeAccent,
                      onChanged: (value) {
                        setState(() {
                          reason = value;
                        });
                      },
                      decoration: InputDecoration(
                        hintText: "Reason",
                        border: InputBorder.none,
                      ),
                      maxLines: 8,
                    ),
                  ),
                  InkWell(
                    child: Container(
                      padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(32.0),
                            bottomRight: Radius.circular(32.0)),
                      ),
                      child: FlatButton(
                        child: Text("Submit",
                            style: TextStyle(color: Colors.white)),
                        onPressed: () async {
                          _checkOutEarly(context, pr);
                        },
                        // style: TextStyle(color: Colors.white),
                        // textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }).then((val) {
      // ketika di dismiss dialog nya, reason nya di set null
      //print(val);
      setState(() {
        reason = null;
      });
    });
  }

  _checkOutEarly(context, pr) async {
    getTime();
    if (reason == null) {
      Fluttertoast.showToast(
          msg: "cannot blank",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIos: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
      return;
    }

    setState(() {
      isLoading = true;
      _iconColor = Colors.grey;
    });

    HttpClient httpClient = new HttpClient()
      ..badCertificateCallback =
      ((X509Certificate cert, String host, int port) => true);
    IOClient ioClient = new IOClient(httpClient);
    var url = "$apiwebsite/checkout";
    await ioClient.post(url, body: {
      "person_id": "$personid",
      "latitude": "$lat",
      "longitude": "$long",
      "checkout_reason": "$reason"
    }).then((response) async {
      if (response.statusCode == 201) {
        var jsonResponse = convert.jsonDecode(response.body);
        var status = jsonResponse['status'];
        if (status == 'success') {
          Fluttertoast.showToast(
              msg: "Anda sukses checkout",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIos: 1,
              backgroundColor: Colors.green,
              textColor: Colors.white,
              fontSize: 16.0);
          //Navigator.pushNamed(context, '/absensi');
        } else {
          Fluttertoast.showToast(
              msg: "system error (APIsd)",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIos: 1,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0);
        }
        pr.hide();
        Navigator.of(context, rootNavigator: true).pop();
      }
    });

    setState(() {
      isLoading = false;
      _iconColor = Colors.white;
    });
  }

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
                          Text(
                            greeting(),
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              ),
                            ),
                          Text(
                            '$name', 
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 24,
                            ),
                          ),
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
                  backgroundColor: Colors.blueAccent,
                  elevation: 0.0,
                  child: Icon(
                    Icons.fingerprint,
                    size: 40,
                    
                  ),
                  onPressed:(){
                    if (absen == true){
                      _checkOut(context,pr);
                    }
                    else{
                      _absen(context, pr);
                      getAbsence();
                    }
                    // if (dataCheckin['cekout'] != null){
                    //   _alreadyCheckout(context, pr);
                    // }
                    // else{
                    //   if (dataCheckin['cekin'] == null){
                    //     _checkIn(context, pr);
                    //   }
                    //   else{
                    //     _checkOut(context,pr);
                    //   }
                    // }
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
                          child:Text(
                            formattedDate, 
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
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