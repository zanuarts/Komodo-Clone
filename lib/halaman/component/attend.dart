import 'dart:async';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/io_client.dart';
import 'package:intl/intl.dart';
import 'package:komodo_ui/components/globalkey.dart';
import 'package:komodo_ui/components/helper.dart';
import 'package:location/location.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

ProgressDialog pr;

class Attend extends StatefulWidget{
  _Attend createState() => _Attend();
}

class _Attend extends State{

  bool absen = false;

  var formattedDate = '';
  var formattedTime = '';
  String _timeString;
  double hourNow = 0.0;
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

  final Helper helper = new Helper();
  Future<Map> get sessionDataSource => helper.getSession();
  var session = {};
  var personid;
  var name = ' ';
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

  var cekin = '';
  var cekout = '';
  var reason;
  Future<Map<String, dynamic>> getAbsence() async {
    HttpClient httpClient = new HttpClient()
      ..badCertificateCallback =
      ((X509Certificate cert, String host, int port) => true);
    IOClient ioClient = new IOClient(httpClient);
    return await ioClient.post('$apiwebsite/status_checkin', body: {
      "person_id": "$personid",
    // final http.Response response = await http.post(
    //   '$apiwebsite/status_checkin', 
    //   body: {
    //     "person_id": "$personid",
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

  Future <String> _absen(context, pr) async {
    // var url = "$apiwebsite/checkin";
    final http.Response response = await http.post(
      '$apiwebsite/checkin',
      body: {
        "person_id": "$personid",
      }
    );
    if(response==201){
      print("masuk fungsi absen");
    getTime();
    pr.show();
    Future.delayed(Duration(seconds: 1)).then((onValue) async{
      
      if(hourNow < 08.00){
        if (response.statusCode == 201){
          print('excellent');
          Fluttertoast.showToast(
            msg: "Anda Sukses Checkin",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIos: 1,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 16.0
          );
        if(pr.isShowing())
          pr.hide();
        }
      
      }
      else if (hourNow <= 08.30){
        if (response.statusCode == 201){
        Fluttertoast.showToast(
          msg: "Anda Sukses Checkin",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIos: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0
        );
        if(pr.isShowing())
          pr.hide();
        }
      }
      else if (hourNow <= 09.00){
        if (response.statusCode == 201){
        Fluttertoast.showToast(
          msg: "Anda Sukses Checkin",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIos: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0
        );
        if(pr.isShowing())
          pr.hide();
        }
      }
      else{
        if (response.statusCode == 201){
        print('bad');
        Fluttertoast.showToast(
          msg: "Anda Sukses Checkin",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIos: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0
          );
        }
        if(pr.isShowing())
          pr.hide();
      }
      }
      );
    }
    else{
      print("failed absen");
    }
  }

  Color _iconColor = Colors.white;
  Color _iconBackgroundColor = Colors.deepOrange;
  bool isLoading = false;
  ProgressDialog pr;

  void initState() {
    super.initState();
    getSharedPreferences();
    getTime();
    getLocation();
  }


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

  _openAlertBoxtelat(context, pr) {
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
                            'Anda Telat',
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
                        onPressed: () {
                          _checkInTelat(context, pr);
                        },
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

  _checkInTelat(context, pr) async {
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
    pr.show();
    HttpClient httpClient = new HttpClient()
      ..badCertificateCallback =
      ((X509Certificate cert, String host, int port) => true);
    IOClient ioClient = new IOClient(httpClient);

    var url = "$apiwebsite/checkin";
    await ioClient.post(url, body: {
      "person_id": "$personid",
      "latitude": "$lat",
      "longitude": "$long",
      "late_reason": "$reason"
    }).then((response) async {
      if (response.statusCode == 201) {
        var jsonResponse = convert.jsonDecode(response.body);
        var status = jsonResponse['status'];
        if (status == 'success') {
          Fluttertoast.showToast(
              msg: "Anda Sukses Checkin",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIos: 1,
              backgroundColor: Colors.green,
              textColor: Colors.white,
              fontSize: 16.0);
          //Navigator.pushNamed(context, '/absensi');
        } else {
          Fluttertoast.showToast(
              msg: "system error (API)",
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



  @override
  Widget build(BuildContext context) {
    pr = new ProgressDialog(context, type: ProgressDialogType.Normal);
    return Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 10, top: 25, bottom: 15),
                  child: FloatingActionButton(
                    backgroundColor: Colors.blueAccent,
                    elevation: 0.0,
                    child: Icon(
                      Icons.fingerprint,
                      size: 40,
                    ),
                    onPressed: (){
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
                          child:Text(
                            formattedDate,
                            // 'test',
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
                          child:Text(
                            _timeString,
                            // 'test',
                            style: TextStyle(color: Colors.black),),
                        ),
                      ],
                    ),
                    Text('Press the button to checkpoint', style: TextStyle(color: Colors.black),),
                  ],
                ),
              )
            ],
          );
  }
  
  
}