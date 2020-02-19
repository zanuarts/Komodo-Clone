import 'package:flutter/material.dart';
import '../home/drawer.dart';

void main(){
  runApp(
      new MaterialApp(
        title:"Halaman satu",
        home: new Halamansatu(),
      )
  );
}

class Halamansatu extends StatelessWidget {

  @override
  Widget build(BuildContext context){
    return MaterialApp(
      home : Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: new Text("Home", style: TextStyle(
              fontFamily: 'Helvetica'
          ),),

          centerTitle: true,
          backgroundColor: Colors.blueAccent,
        ),
        drawer: DrawerApp(),
        body: Container(
          padding: EdgeInsets.all(10.0),
          child: Column(
            children: <Widget>[
              Text(
                'Hei There',
              ),
            ],
          ),
        ),
      ),
    );
  }
}