import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/io_client.dart';
import 'package:intl/intl.dart';
import 'package:komodo_ui/components/globalkey.dart';
import 'package:location/location.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Attend extends StatefulWidget{
  _Attend createState() => _Attend();
}

class _Attend extends State{
  ProgressDialog pr;
  var personid;
  String id_karyawan = '';
  String id_user = '';
  String late_reason = 'test';
  // bool absen = false;

  Future<String> getData() async{
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      id_user = pref.getString('id_user');
    });
  }

  @override
  void initState(){
    getData();
    getTime();
    getKaryawan();
    _timeString = _formatDateTime(DateTime.now());
    Timer.periodic(Duration(seconds: 1), (Timer t) => getTime());
  }

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
  String latitude;
  String longitude;
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
        print(id_karyawan);
        print(id_user);
        latitude = lat.toString();
        longitude = long.toString();
      });
    });
  }

  Future <Karyawan> getKaryawan() async{
    final response = await http.get('https://ojanhtp.000webhostapp.com/viewsDataKaryawan');
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return Karyawan.fromJson(json.decode(response.body));
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  }

  Future <Absen> _absen(id_user, latitude, longitude, late_reason, pr) async{
    getLocation();
      print("success");
      final http.Response response = await http.post(
        'https://ojanhtp.000webhostapp.com/tambahDataAbsensi',
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
        body: jsonEncode(<String, String>{
          'id_user': id_user,
          'lat': latitude,
          'long': longitude,
          'late_reason': late_reason,
        })
      ).then((response)async{
        if (response.statusCode == 200){
          print("masuk fungsi absen");
          getTime();
          getLocation();
          pr.show();
          Future.delayed(Duration(seconds: 1)).then((onValue) async{
            print("success");
            if(hourNow < 08.00){
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
            else if (hourNow <= 08.30){
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
            else if (hourNow <= 09.00){
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
            else {
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
              if (pr.isShowing())
                pr.hide();
            }
          });
        }
        else{
          pr.show();
          Future.delayed(Duration(seconds: 1)).then((onValue) async {
            print('bad');
            Fluttertoast.showToast(
                msg: "Anda Gagal Checkin",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIos: 1,
                backgroundColor: Colors.red,
                textColor: Colors.white,
                fontSize: 16.0
            );
            if (pr.isShowing())
              pr.hide();
          });
        }
      });
  }


  _checkout(){
    print("masuk check out");
    pr.show();
    
    Future.delayed(Duration(seconds: 1)).then((onValue) async{
      Fluttertoast.showToast(
        msg: "Anda Sukses CheckOut",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIos: 1,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0
      );
      if(pr.isShowing())
        pr.hide();
    });
//    return absen = false;
  }

  @override
  Widget build(BuildContext context) {
    pr = new ProgressDialog(context, type: ProgressDialogType.Normal);
    bool absen = false;
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
                  onPressed:(){
                    if (absen == false){
                      _absen(id_user, latitude, longitude, late_reason, pr);
                      // absen = true;
                    }
                    else if (absen == true){
                      _checkout();
                      // absen = false;
                    }
                    // _absen();
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

class Absen {

  final String id_user;
  final String lat;
  final String long;
  final String late_reason;

  Absen({this.id_user, this.lat, this.long, this.late_reason});

  factory Absen.fromJson(Map<String, dynamic> json) {
    return Absen(
        id_user: json['id_user'],
        lat: json['lat'],
        long: json['long'],
        late_reason: json['late_reason'],
    );
  }
}

class Karyawan {
  final int id_user;
  final int id_karyawan;

  Karyawan({this.id_user, this.id_karyawan});

  factory Karyawan.fromJson(Map<String, dynamic> json) {
    return Karyawan(
      id_user: json['id_user'],
      id_karyawan: json['id_karyawan'],
    );
  }
}