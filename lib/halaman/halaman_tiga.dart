import 'package:flutter/material.dart';
import '../home/drawer.dart';
//import 'package:flutter_ui1/components/drawer.dart';


class Halamantiga extends StatelessWidget {
@override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: new Text("Project"),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(15),
          ),

        ),
        // elevation: 0.0,
      ),
      drawer: DrawerApp(),
      body: Center(
            child: Text("Coming soon! But not soon enough."),
      ),
    );
  }
}