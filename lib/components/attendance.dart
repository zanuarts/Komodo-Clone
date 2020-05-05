import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:komodo_ui/components/list_absen.dart';
import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class Attendance extends StatefulWidget {
  @override
  _ListAtt createState() => new _ListAtt();
}

class _ListAtt extends State{
  List data;
  var token;
  Future<Data> futureListAbsen;

  Future<String> getData() async{
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      token = pref.getString('token');
    });
  }

  Future<Data> getList() async {
    final response = await http.get('https://ojanhtp.000webhostapp.com/viewsDataAbsensi',
      headers: {
          'authorization':'bearer $token',
      }
    );
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return Data.fromJson(json.decode(response.body));
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  }


  // Future<ListAbsen> getList() async{
  //   http.Response response = await http.get(
  //     Uri.encodeFull("https://ojanhtp.000webhostapp.com/viewsDataAbsensi"),
  //     headers: {
  //         'authorization':'bearer $token',
  //     }
  //   );
  //   if (response.statusCode == 200){
  //     setState((){
  //       print(token);
  //       data = json.decode(response.body);
  //     });
  //   }
  // }

  @override
  void initState(){
    getData();
    super.initState();
    futureListAbsen = getList();
  }

  // @override
  // Widget build(BuildContext context) {
  //   return new Scaffold(
  //     body: new ListView.builder(
  //       itemCount: data == null ? 0 : data.length,
  //       itemBuilder: (BuildContext context, int index){
  //         return new Card(
  //           child: new Text(data[index]["hasil"]),
  //         );
  //       },
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
          body: Container(
          child:FutureBuilder<Data>(
            future: futureListAbsen,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Text(snapshot.data.message);
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }
              // By default, show a loading spinner.
              return CircularProgressIndicator();
            },
          ),
          ) 
    );
  }
}