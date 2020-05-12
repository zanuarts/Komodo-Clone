import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:komodo_ui/halaman/component/absen.dart';
import 'package:location/location.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:geolocator/geolocator.dart';


class Attend extends StatefulWidget{
  _Attend createState() => _Attend();
}

class _Attend extends State{
  ProgressDialog pr;
  String idKaryawan = '';
  String idAbsensi = '';
  String checkinTime = '';
  String idUser = '';
  String lateReason = 'Datang tepat waktu';
  String leaveReason = 'Pulang tepat waktu';
  String msg = 'Press the button to attend';
  double jarakM = 0.0;
  var token;
  final bool keepPage = true;

  checkJarak()async{
    jarakM = await Geolocator().distanceBetween(lat, long, -6.897980, 107.619328);
    print(jarakM);
    if (jarakM <= 100.0){
      checkTimeIn(); 
    }
    else{
      Fluttertoast.showToast(
        msg: "Anda Diluar Jangkauan",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIos: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0
      );
      if(pr.isShowing())
        pr.hide();
    }
  }

  resetAbsen(){
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
      token = pref.getString('token');
      idUser = pref.getString('id_user');
    });
    return String.fromEnvironment(token);
  }

  @override
  void initState(){
    getData();
    getTime();
    resetAbsen();
    getLocation();
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
    final String formattedDateTime = _formatDateTime(now);
    setState(() {
      _timeString = formattedDateTime;
      hourNow = timeNowDouble;
      formattedDate = dateNow;
      formattedTime = timeNow;
    });
  }

  Location location = Location();
  double long;
  double lat;
  LatLng _userPostion = LatLng(0, 0);
  Future<Map<String, double>> getLocation() async {
    var location = new Location();
    location.onLocationChanged().listen((LocationData currentLocation) {
      setState(() {
        lat = currentLocation.latitude;
        long = currentLocation.longitude;
        _userPostion = LatLng(lat, long);
        print("Lokasi di : ");
        print(_userPostion);
        print(idUser);
        print(jarakM);
      });
    });
  }

  final myController = TextEditingController();

  _alasanTelat(BuildContext context) async {
    return showDialog(
      context: context,
       builder: (context) {
        return AlertDialog(
          title: Text('Kenapa anda telat?'),
          content: TextField(
            controller: myController,
            decoration: InputDecoration(hintText: "Masukan Alasan"),
            onChanged: (text){
              lateReason = text;
            },
          ),
          actions: <Widget>[
            new FlatButton(
              child: new Text('SUBMIT'),
              onPressed: () {
                pr.show();
                Future.delayed(Duration(seconds: 1)).then((onValue) async{
                  _verCheckIn();
                  Navigator.of(context).pop();
                });
              },
            )
          ],
        );
      }
    );
  }

  _alasanPulang(BuildContext context) async {
    return showDialog(
      context: context,
       builder: (context) {
        return AlertDialog(
          title: Text('Kenapa anda pergi?'),
          content: TextField(
            controller: myController,
            decoration: InputDecoration(hintText: "Masukan Alasan"),
            onChanged: (text){
              leaveReason = text;
            },
          ),
          actions: <Widget>[
            new FlatButton(
              child: new Text('SUBMIT'),
              onPressed: () {
                _verCheckOut();
                Navigator.of(context).pop();
              },
            )
          ],
        );
      }
    );
  }

  suksesCheckIn(){
    Fluttertoast.showToast(
      msg: "Anda Sukses Check In",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIos: 1,
      backgroundColor: Colors.green,
      textColor: Colors.white,
      fontSize: 16.0
    );
  }

  gagalCheckIn(){
    Fluttertoast.showToast(
      msg: "Anda Gagal Check In",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIos: 1,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0
    );
  }

  suksesCheckOut(){
    Fluttertoast.showToast(
      msg: "Anda Sukses CheckOut",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIos: 1,
      backgroundColor: Colors.green,
      textColor: Colors.white,
      fontSize: 16.0
    );
  }

  gagalCheckOut(){
    Fluttertoast.showToast(
      msg: "Gagal Checkout",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIos: 1,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0
    );
  }

  Future <Absen> _verCheckIn() async{
    getLocation();
    final http.Response response = await http.post('https://ojanhtp.000webhostapp.com/tambahDataAbsensi',
      headers: {
        'authorization':'bearer $token',
      },
      body: {
        'id_user': '$idUser',
        'lattitude': '$lat',
        'longitude': '$long',
        'late_reason': '$lateReason',
      }
    );
    if (response.statusCode == 200){
      var data = jsonDecode(response.body)
      ['data']['hasil'];
      var idabsen = data['id_absensi'];
      var cekinTime = data['checkin_time'];
      idAbsensi = idabsen;
      checkinTime = cekinTime;
      setState(() {
        if (msg.startsWith('P')) {
          msg = 'You have attended at $checkinTime';
        }
      });
      print(response.body);
      print(jarakM);
      suksesCheckIn();
    }
    else{
      gagalCheckIn();
    }
    return Absen.fromJson(json.decode(response.body));
  }

  Future<Hasil> _verCheckOut()async{
    final http.Response response = await http.post('https://ojanhtp.000webhostapp.com/checkOut/$idAbsensi',
      headers: {
        'authorization':'bearer $token',
      },
      body: {
        'leave_reason': '$leaveReason',
      }
    );
    if (response.statusCode == 200) {
      setState(() {
        if (msg.startsWith('Y')) {
          msg = 'Checked out success! Thank you!';
        }
      });
      suksesCheckOut();
    }
    else{
      gagalCheckOut();
    }
    return Hasil.fromJson(json.decode(response.body));
  }

  checkTimeOut(){
    if(hourNow < 17.00){
      if(pr.isShowing())
        pr.hide();
      _alasanPulang(context);
      }
      else {
        if (pr.isShowing())
          pr.hide();
        _verCheckOut();
      }
  }

  checkTimeIn(){
    if(hourNow < 08.00){
      if(pr.isShowing())
        pr.hide();
      _verCheckIn();
      }
      else if (hourNow <= 08.30){
        if(pr.isShowing())
          pr.hide();
        _verCheckIn();
      }
      else if (hourNow <= 09.00){
        if(pr.isShowing())
          pr.hide();
        _alasanTelat(context);
      }
      else {
        if (pr.isShowing())
          pr.hide();
        _alasanTelat(context);
      }
  }

  checkIn(){
    pr.show();
    getTime();
    Future.delayed(Duration(seconds: 1)).then((onValue) async{
      checkJarak();
    });
  }

  checkOut(){
    pr.show();
    getTime();
    Future.delayed(Duration(seconds: 1)).then((onValue) async{
      checkTimeOut();
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
            onPressed:(){
              checkJarak();
              if (msg.startsWith('P')) {
                checkIn();
              }
              else if (msg.startsWith('Y')){
                checkOut();
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