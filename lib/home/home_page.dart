import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:komodo_ui/main/halamansatu.dart';
import 'package:komodo_ui/main/halamandua.dart';
import 'package:komodo_ui/main/halamantiga.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

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

  DateTime currentBackPressTime = DateTime.now();
  Future<bool> onWillPop() {
    DateTime now = DateTime.now();
    if (now.difference(currentBackPressTime) > Duration(seconds: 1)) {
      currentBackPressTime = now;
      Fluttertoast.showToast(msg: 'Press again to exit');
      return Future.value(false);
    }
    //return Future.value(true);
    SystemChannels.platform.invokeMethod<void>('SystemNavigator.pop');
    return Future.value(false);
  }

  @override
  Widget build (BuildContext context){
    return WillPopScope(
      onWillPop: onWillPop,
      child: SafeArea(
        child: Scaffold(
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
          )
        )
      )
    );
  }
  void onItemTapped(int index){
    setState((){
      _selectedIndex = index;
    });
  }
}