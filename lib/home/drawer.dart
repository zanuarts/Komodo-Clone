import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ui1/authentication/authentication.dart';


class DrawerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: new Text("Admin"),
            accountEmail: new Text("admin@gmail.com"),
            currentAccountPicture: new CircleAvatar(
              backgroundImage: NetworkImage("https://code.byriza.com/lib/img/logo.png"),
            ),
          ),
          ListTile(
            leading: Icon(Icons.account_circle),
            title: Text('Profile'),
            onTap: () {

            },
            trailing: Icon(Icons.chevron_right),
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Setting'),
            onTap: () {

            },
            trailing: Icon(Icons.chevron_right),
          ),
          ListTile(
            leading: Icon(Icons.credit_card),
            title: Text('About'),
            onTap: () {

            },
            trailing: Icon(Icons.chevron_right),
          ),
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