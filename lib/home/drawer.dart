
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:komodo_ui/authentication/authentication.dart';
import 'package:komodo_ui/extensions/image/images.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';

class DrawerApp extends StatefulWidget {
  @override
  _DrawerAppState createState() => _DrawerAppState();
}

class _DrawerAppState extends State<DrawerApp> {
  var name;
  var foto;
  var role;

  Future<String> getData() async{
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      foto = pref.getString("photo");
      name = pref.getString("full_name");
      role = pref.getString("role_name");
    });
  }

  @override
  void initState() {
    getData();
    super.initState();
  }


    
        
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.70,//20.0,,
      child:Container(
        child: Drawer(
          child: ListView(
            children: <Widget>[
              UserAccountsDrawerHeader(
                  margin: EdgeInsets.only(top: 50),
                  accountName: Text(
                    '$name',
                    style: TextStyle(
                      color: Colors.black
                    ),
                  ),
                  currentAccountPicture: GestureDetector (
                    child: Container(
                      padding: const EdgeInsets.all(3.0),
                      decoration: new BoxDecoration(
                        color: Colors.white, // border color
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(color: Colors.black26, blurRadius: 10.0)
                        ]
                      ),
                      child:  CircleAvatar(
                        radius: 40,
                        child: ClipOval(
                        child: Image.network(
                          '$foto',
                          width: 200,
                          height: 200,
                          fit: BoxFit.cover,
                        ),
                        )
                      ),
                    ),
                  ),
                  decoration: BoxDecoration(
                    color: Colors.transparent
                  ), accountEmail: null,
                ),
                ListTile(
                  title: Text("Logout"),
                  // trailing: Icon(IcoFontIcons.logout),
                  onTap: () async{
                    Fluttertoast.showToast(
                          msg: "Sukses Logout",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIos: 1,
                          backgroundColor: Colors.green,
                          textColor: Colors.white,
                          fontSize: 16.0
                        );
                        SharedPreferences prefs = await SharedPreferences.getInstance();
                        prefs.remove('userid');
                        prefs.remove('username');
                        prefs.remove('admin');
                    BlocProvider.of<AuthenticationBloc>(context).add(LoggedOut());
                  },
                ),
              ]
          )
        )
      )
    );
        // DrawerHeader(
        //   decoration: BoxDecoration(
        //     color: Colors.blue,
        //   ),
        //   child: Text(
        //     'Drawer Header',
        //     style: TextStyle(
        //       color: Colors.white,
        //       fontSize: 24,
        //     ),
        //   ),
        // ),
        // ListTile(
        //   leading: Icon(Icons.message),
        //   title: Text('Messages'),
        // ),
        // ListTile(
        //   leading: Icon(Icons.account_circle),
        //   title: Text('Profile'),
        // ),
        // ListTile(
        //   leading: Icon(Icons.settings),
        //   title: Text('Settings'),
        // ),
  }
}