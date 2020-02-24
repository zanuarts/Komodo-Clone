
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:komodo_ui/authentication/authentication.dart';
import 'package:komodo_ui/halaman/halaman_dua.dart';
import 'package:komodo_ui/halaman/halaman_satu.dart';
import 'package:shared_preferences/shared_preferences.dart';


class DrawerApp extends StatelessWidget {
  const DrawerApp({Key key, this.user, this.foto, this.name, this.role}) : super(key: key);
  final user;
  final foto;
  final name;
  final role;


  @override
  Widget build(BuildContext context) {
    return new SizedBox(
        width: MediaQuery.of(context).size.width * 0.70,//20.0, 
        child:Container(
    child: Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          new Container(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: new Column(
                    // alignment: Alignment.center,
                    children: <Widget>[
                      CircleAvatar(
                        backgroundColor: Colors.lightBlue,
                        radius: 60,
                        child: CircleAvatar(
                          backgroundColor: Colors.lightBlueAccent,
                          radius: 50,
                          child: 
                          foto != 'null' ?
                          CircleAvatar(
                            radius: 40,
                            child: ClipOval(
                              child: Image.network(
                                "https://cbnusantara.id/komodo_hrm/web/uploads/066536100_1540717167-gundala.jpg",
                                width: 200,
                                height: 200,
                                fit: BoxFit.cover,
                                alignment: Alignment.topLeft,
                              ),
                            )
                          ):
                          CircleAvatar(
                            radius: 40,
                            child: Text('name'[0],style: TextStyle(fontSize: 40),)
                          ),
                        ),
                      ),
                      Container(padding: EdgeInsets.all(5),child:Text('name',style:TextStyle(color: Colors.white,fontSize: 15))),
                      Container(padding: EdgeInsets.all(5),child:Text('role',style:TextStyle(color: Colors.white,fontSize: 15))),  
                    ]
                  ),
                  decoration: new BoxDecoration(color: Color.fromRGBO( 	0, 70, 137,27)),
                ),
          // Container(
          //   //padding: EdgeInsets.symmetric(vertical: 20),
          //   child: UserAccountsDrawerHeader(
          //     decoration: new BoxDecoration(color: Colors.deepOrangeAccent),
          //     accountName: new Text('name'),
          //     accountEmail: new Text('role'),
          //     currentAccountPicture: new CircleAvatar(
          //       radius: 40,
          //       backgroundImage: NetworkImage("https://cbnusantara.id/komodo_hrm/web/uploads/066536100_1540717167-gundala.jpg"),
          //       backgroundColor: Colors.red,
          //     ),
          //   ),
          //   decoration: new BoxDecoration(color: Color.fromRGBO( 	0, 70, 137,27)),
          // ),
          Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(10),
                alignment: Alignment.centerLeft,
                child:Text('Menu',style: TextStyle(color: Colors.black45),)
              ),
              Container(
                padding: EdgeInsets.all(10),
                child: Row(
                      mainAxisSize: MainAxisSize.max,
                      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Icon(Icons.fingerprint,color: Colors.black45,),
                        Expanded(
                          child: InkWell(
                            highlightColor: Colors.transparent,
                            splashColor: Colors.transparent,
                            onTap:() async {
                              Halamandua();
                            },  
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(color: Colors.black12,width: 1)
                                )
                              ),
                              padding: EdgeInsets.only(left: 10, bottom: 10),
                              margin: EdgeInsets.only(top: 10),
                              child: Text('Absen', style: TextStyle(color: Colors.black45),),
                            )
                          )
                        ),
                      ]
                    )
                  ),
                  Container(
                  padding: EdgeInsets.all(10),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                      Icon(Icons.rotate_90_degrees_ccw,color: Colors.black45,),
                      Expanded(
                        child: InkWell(
                          highlightColor: Colors.transparent,
                          splashColor: Colors.transparent,
                          onTap: ()async{
                            SharedPreferences prefs = await SharedPreferences.getInstance();
                            prefs.remove('userid');
                            prefs.remove('username');
                            prefs.remove('admin');
                            BlocProvider.of<AuthenticationBloc>(context).add(LoggedOut());
                          },
                          child:Container(
                            decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.black12,width: 1))),
                            padding: EdgeInsets.only(left: 10, bottom: 10),
                            margin: EdgeInsets.only(top: 10),
                            child: Text('Logout', style: TextStyle(color: Colors.black45),),
                          )
                        )
                      ),
                    ]
                  )
                ),
            ],
          ),
          
          // ListTile(
          //   leading: Icon(Icons.account_circle),
          //   title: Text('Menu'),
          //   onTap: () {
          //     Halamansatu();
          //   },
          //   //trailing: Icon(Icons.chevron_right),
          // ),
          // ListTile(
          //   leading: Icon(Icons.settings),
          //   title: Text('Absen'),
          //   onTap:() async {
          //     Halamandua();
          //   },
          //   //trailing: Icon(Icons.chevron_right),
          // ),
          // ListTile(
          //   leading: Icon(Icons.credit_card),
          //   title: Text('About'),
          //   onTap: () {

          //   },
          //   //trailing: Icon(Icons.chevron_right),
          // ),
          // ListTile(
          //   leading: Icon(Icons.all_out),
          //   title: Text('Log out'),

          //   onTap: () {
          //     BlocProvider.of<AuthenticationBloc>(context).add(LoggedOut());

          //   },

        //   ),
        ],
      ),
    ))
    );
  }
}