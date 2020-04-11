import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

class Attendance extends StatefulWidget {
  @override
  ListAtt createState() => new ListAtt();
}

class ListAtt extends State{
  List data;

  Future<String> getData() async{
    http.Response response = await http.get(
      Uri.encodeFull("https://ojanhtp.000webhostapp.com/viewsDataAbsensi"),
      headers: {
        "Accept":"application/json"
      }
    );
    setState((){
      data = json.decode(response.body);
    });
    return "Success!";
  }

  @override
  void initState(){
    this.getData();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new ListView.builder(
        itemCount: data == null ? 0 : data.length,
        itemBuilder: (BuildContext context, int index){
          return new Card(
            child: new Text(data[index]["hasil"]["checkin_time"]),
          );
        },
      ),
    );
  }
}