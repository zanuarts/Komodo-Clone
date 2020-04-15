import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Attend extends StatefulWidget{
  _Attend createState() => _Attend();
}

class _Attend extends State{
  ProgressDialog pr;
  String idKaryawan = '';
  String idUser = '';
  String lateReason = 'test';
  String msg = 'Press the button to attend';

   String resetAbsen(){
    var hour = DateTime.now().hour;
    if(hour > 0 ){
      setState(() {
        if (msg.startsWith('C')) {
          return msg = 'Press the button to attend';
        } else {
          return msg = 'Press the button to attend';
        }
      });
    }
  }

  Future<String> getData() async{
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      idUser = pref.getString('id_user');
    });
  }

  @override
  void initState(){
    getData();
    getTime();
    resetAbsen();
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
        print(idKaryawan);
        print(idUser);
        latitude = lat.toString();
        longitude = long.toString();
      });
    });
  }

  Future <Absen> _absen(idUser, latitude, longitude, lateReason, pr) async{
    getLocation();
      print("success");
      final http.Response response = await http.post(
        'https://ojanhtp.000webhostapp.com/tambahDataAbsensi',
        body: {
          'id_user': idUser,
          'lattitude': latitude,
          'longitude': longitude,
          'late_reason': lateReason,
        });
//      ).then((response)async{
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
              setState(() {
                if (msg.startsWith('P')) {
                  msg = 'You have attended';
                } else {
                  msg = 'Press the button to attend';
                }
              });
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
              setState(() {
                if (msg.startsWith('P')) {
                  msg = 'You have attended';
                } else {
                  msg = 'Press the button to attend';
                }
              });
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
              setState(() {
                if (msg.startsWith('P')) {
                  msg = 'You have attended';
                } else {
                  msg = 'Press the button to attend';
                }
              });
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
              setState(() {
                if (msg.startsWith('P')) {
                  msg = 'You have attended';
                } else {
                  msg = 'Press the button to attend';
                }
              });
            }
          });
          return Absen.fromJson(json.decode(response.body));
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
            setState(() {
              if (msg.startsWith('P')) {
                msg = 'You have attended';
              } else {
                msg = 'Press the button to attend';
              }
            });
          });
          throw Exception('Failed to absen.');
        }
//      });
  }

  String leave_reason = 'test in app';

  _checkout()async{
    final http.Response response = await http.post(
      'https://ojanhtp.000webhostapp.com/checkOut/$idUser',
      body: {
        'leave_reason': leave_reason,
      });
//    ).then((response)async{
      if (response.statusCode==200) {
        print("masuk check out");
        pr.show();
        Future.delayed(Duration(seconds: 1)).then((onValue) async {
          Fluttertoast.showToast(
              msg: "Anda Sukses CheckOut",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIos: 1,
              backgroundColor: Colors.green,
              textColor: Colors.white,
              fontSize: 16.0
          );
          if (pr.isShowing())
            pr.hide();
          setState(() {
            if (msg.startsWith('Y')) {
              msg = 'Checked out success! Thank you!';
            }
          });
        });
      return CheckOut.fromJson(json.decode(response.body));
      }
      else{
        throw Exception('Failed to checkout.');
      }
//    });
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
                  onPressed:(){
                    if (msg.startsWith('P')) {
                      _absen(idUser, latitude, longitude, lateReason, pr);
                    }
                    else if (msg.startsWith('Y')){
                      _checkout();
                    }
                    else{
                      Fluttertoast.showToast(
                          msg: "Udah gausah absen lagi",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIos: 1,
                          backgroundColor: Colors.green,
                          textColor: Colors.white,
                          fontSize: 16.0
                      );
                    }
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
                    Text(msg, style: TextStyle(color: Colors.black),),
                  ],
                ),
              )
            ],
          );
  }
}


class Absen {

  final String id_user;
  final String lattitude;
  final String longitude;
  final String late_reason;

  Absen({this.id_user, this.lattitude, this.longitude, this.late_reason});

  factory Absen.fromJson(Map<String, dynamic> json) {
    return Absen(
        id_user: json['id_user'],
        lattitude: json['lat'],
        longitude: json['long'],
        late_reason: json['late_reason'],
    );
  }
}

class CheckOut{
  final String leave_reason;

  CheckOut({this.leave_reason});

  factory CheckOut.fromJson(Map<String, dynamic> json){
    return CheckOut(
      leave_reason: json['leave_reason'],
    );
  }
}