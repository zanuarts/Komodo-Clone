import 'package:flutter/material.dart';
import '../home/drawer.dart';
//import 'package:flutter_ui1/components/drawer.dart';


class Halamanempat extends StatelessWidget {
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: new Text("Profile", style: TextStyle(color: Colors.black),),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      drawer: DrawerApp(),
      body: Center(
            child: Text("Coming soon! But not soon enough."),
      ),
    );
  }
}