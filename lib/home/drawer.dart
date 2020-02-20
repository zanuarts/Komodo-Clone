
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ui1/authentication/authentication.dart';
import 'package:flutter_ui1/main/halamandua.dart';
import 'package:flutter_ui1/main/halamansatu.dart';
import 'package:shared_preferences/shared_preferences.dart';


class DrawerApp extends StatelessWidget {
  const DrawerApp({Key key, this.user, this.foto, this.name, this.role}) : super(key: key);
  final user;
  final foto;
  final name;
  final role;


  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          Container(
            //padding: EdgeInsets.symmetric(vertical: 20),
            child: UserAccountsDrawerHeader(
              decoration: new BoxDecoration(color: Colors.deepOrangeAccent),
              accountName: new Text('nama'),
              accountEmail: new Text('jabatan'),
              currentAccountPicture: new CircleAvatar(
                radius: 40,
                backgroundImage: NetworkImage("https://cbnusantara.id/komodo_hrm/web/uploads/066536100_1540717167-gundala.jpg"),
                backgroundColor: Colors.red,
              ),
            ),
          ),
          Container(
                padding: EdgeInsets.all(10),
                alignment: Alignment.centerLeft,
                child:Text('Menu',style: TextStyle(color: Colors.black45),)
                ),
          // ListTile(
          //   leading: Icon(Icons.account_circle),
          //   title: Text('Menu'),
          //   onTap: () {
          //     Halamansatu();
          //   },
          //   //trailing: Icon(Icons.chevron_right),
          // ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Absen'),
            onTap:() async {
              Halamandua();
            },
            //trailing: Icon(Icons.chevron_right),
          ),
          // ListTile(
          //   leading: Icon(Icons.credit_card),
          //   title: Text('About'),
          //   onTap: () {

          //   },
          //   //trailing: Icon(Icons.chevron_right),
          // ),
          ListTile(
            leading: Icon(Icons.all_out),
            title: Text('Log out'),

            onTap: () {
              BlocProvider.of<AuthenticationBloc>(context).add(LoggedOut());

            },

          ),
        ],
      ),
    );
  }
}