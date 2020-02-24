import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:komodo_ui/halaman/halaman_satu.dart';
import 'package:komodo_ui/halaman/halaman_dua.dart';
import 'package:komodo_ui/halaman/halaman_tiga.dart';
import 'package:komodo_ui/halaman/halaman_empat.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:komodo_ui/extensions/fancy_bottom_navigation-0.3.2/lib/fancy_bottom_navigation.dart';


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
  int currentPage = 1;
  int _selectedIndex = 1;
    

  final _widgetOptions = [
    Halamansatu(),
    Halamandua(),
    Halamantiga(),
    Halamanempat(),

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
          bottomNavigationBar : FancyBottomNavigation(
            barBackgroundColor: Color(0xFF404040),
            textColor: Colors.white,
            inactiveIconColor: Colors.white,
            tabs: [
              TabData(
                iconData: Icons.home,
                title: "Home",
              ),
              TabData(
                iconData: Icons.fingerprint,
                title: "Absence",
              ),
              TabData(
                iconData: Icons.work,
                title: "Projects",
              ),
              TabData(
                iconData: Icons.account_circle,
                title: "Profile",
              ),
            ],
            //type: BottomNavigationBarType.fixed,
            currentPage: _selectedIndex,
            //fixedColor: Colors.deepOrangeAccent,
            onTabChangedListener: onItemTapped,
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