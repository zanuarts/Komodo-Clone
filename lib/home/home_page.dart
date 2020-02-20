import 'package:flutter/material.dart';
import 'package:flutter_ui1/main/halamansatu.dart';
import 'package:flutter_ui1/main/halamandua.dart';
import 'package:flutter_ui1/main/halamantiga.dart';

void main(){
  runApp(
      new MaterialApp(
        title:"Home",
        home: new Home(),
      )
  );
}

class Home extends StatefulWidget {
  @override
  _HalamannavState createState() => _HalamannavState();
}

class _HalamannavState extends State {
  int _selectedIndex = 1;

  final _widgetOptions = [
    Halamansatu(),
    Halamandua(),
    Halamantiga(),

  ];

  @override
  Widget build (BuildContext context){
    return Scaffold(
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar : BottomNavigationBar(


        items: [
          BottomNavigationBarItem(
            icon : Icon(Icons.home),
            title : Text('Home'),
          ),
          BottomNavigationBarItem(
            icon : Icon(Icons.fingerprint),
            title : Text('Absensi'),
          ),
          BottomNavigationBarItem(
            icon : Icon(Icons.work),
            title : Text('Project'),
          ),
        ],
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        fixedColor: Colors.deepOrangeAccent,


        onTap: onItemTapped,
      ),
    );
  }
  void onItemTapped(int index){
    setState((){
      _selectedIndex = index;
    });
  }
}