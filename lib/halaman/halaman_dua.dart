import 'package:flutter/material.dart';
import 'package:komodo_ui/home/drawer.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Halamandua extends StatefulWidget {
  @override
  _MyappState createState() => _MyappState();
}

class _MyappState extends State {
  var foto;
  var name;
  
  Future <String> getData() async{
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      foto = pref.getString('photo');
      name = pref.getString('full_name');
      print('hiii');
    });
  }

  @override
  void initState(){
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context){
    Color color = Theme.of(context).primaryColor;
    return Scaffold(
      appBar: AppBar(
        title: new Text(
          "Absensi", 
          style: TextStyle(
          ),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom:Radius.circular(30),
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(88.0),
          // Di isi child, untuk widget yang akan ditampilkan
          child: Row(
            children:<Widget>[
              Padding(
                padding: const EdgeInsets.only(bottom:10, left: 25),
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
                  // backgroundColor: Colors.green,  
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text("Good Day", style: TextStyle(color: Colors.white),),
                    Text('$name', style: TextStyle(color: Colors.white),),
                  ],
                ),
              )
            ],
          ),
        )
      ),
      drawer: DrawerApp(),
      body: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Padding(
            padding: const EdgeInsets.only(left: 40, top: 15, bottom: 15),
            child: FloatingActionButton(
              child: new IconButton(
                icon : new Icon(
                  Icons.fingerprint,
                ),
                iconSize: 40,
                onPressed: null,
              )
            ),
          ),
          Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Icon(
                          Icons.calendar_today,
                          size: 15,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child:Text("Date", style: TextStyle(color: Colors.black),),
                        ),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Icon(
                          Icons.timer,
                          size: 15,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child:Text("Time", style: TextStyle(color: Colors.black),),
                        ),
                      ],
                    ),
                    Text('Press the button to checkpoint', style: TextStyle(color: Colors.black),),
                  ],
                ),
              )
            ],
          ),
          Container(
            height: 175,
            margin: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              color: Colors.blueAccent,
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            child: Center(
              child: Text(
                "Maps",
                style: TextStyle(color : Colors.white),
              ),
            ),
          ),
          Container(
            height: 150,
            margin: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            // child: ListView(
            //   children: <Widget>[
            //     Container(
            //       margin: const EdgeInsets.only(top:1),
            //       height: 25,
            //       width: 85,
            //       decoration: BoxDecoration(
            //         color: Colors.white60,
            //       ),
            //       child: Row(
            //       children: <Widget>[
            //         Container(
            //           margin: const EdgeInsets.all(5),
            //           alignment: Alignment.center,
            //           height: 20,
            //           width: 80,
            //           decoration: BoxDecoration(
            //             color: Colors.green,
            //             borderRadius: BorderRadius.all(Radius.circular(5))
            //           ),
            //           child: Text(
            //             "Excellent"
            //           ),
            //         ),
            //         Text(
            //           "Nama User checked in at Time",
            //         ),
            //       ],
            //     ),
            //     ),
            //     Container(
            //       margin: const EdgeInsets.only(top:1),
            //       height: 25,
            //       width: 85,
            //       decoration: BoxDecoration(
            //         color: Colors.white60,
            //       ),
            //       child: Row(
            //         children: <Widget>[
            //           Container(
            //             margin: const EdgeInsets.all(5),
            //             alignment: Alignment.center,
            //             height: 20,
            //             width: 80,
            //             decoration: BoxDecoration(
            //               color: Colors.blue,
            //               borderRadius: BorderRadius.all(Radius.circular(5))
            //             ),
            //             child: Text(
            //               "Normal"
            //             ),
            //           ),
            //           Text(
            //             "Nama User checked in at Time",
            //           ),
            //         ],
            //       ),
            //     ),
            //     Container(
            //       margin: const EdgeInsets.only(top:1),
            //       height: 25,
            //       width: 85,
            //       decoration: BoxDecoration(
            //         color: Colors.white60,
            //       ),
            //       child: Row(
            //         children: <Widget>[
            //           Container(
            //             margin: const EdgeInsets.all(5),
            //             alignment: Alignment.center,
            //             height: 20,
            //             width: 80,
            //             decoration: BoxDecoration(
            //               color: Colors.yellow,
            //               borderRadius: BorderRadius.all(Radius.circular(5))
            //             ),
            //             child: Text(
            //               "Late"
            //             ),
            //           ),
            //           Text(
            //             "Nama User checked in at Time",
            //           ),
            //         ],
            //       ),
            //     ),
            //     Container(
            //       margin: const EdgeInsets.only(top:1),
            //       height: 25,
            //       width: 85,
            //       decoration: BoxDecoration(
            //         color: Colors.white60,
            //       ),
            //       child: Row(
            //         children: <Widget>[
            //           Container(
            //             margin: const EdgeInsets.all(5),
            //             width: 80,  
            //             alignment: Alignment.center,
            //             height: 20,
            //             decoration: BoxDecoration(
            //               color: Colors.red,
            //               borderRadius: BorderRadius.all(Radius.circular(5))
            //             ),
            //               child: Text(
            //                 "Danger",
            //               ),
            //           ),
            //           Text(
            //             "Nama User checked in at Time",
            //           ),
            //         ],
            //       ),
            //     ),
            //   ],
            // ),
            child: ListView.builder(
              itemCount: 100,
              itemBuilder: (BuildContext context, int index){
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: 3),
                  child:  Container(
                  margin: const EdgeInsets.only(top:1),
                  height: 25,
                  width: 85,
                  decoration: BoxDecoration(
                    color: Colors.white60,
                  ),
                  child: Row(
                    children: <Widget>[
                      Container(
                        margin: const EdgeInsets.all(5),
                        width: 80,  
                        alignment: Alignment.center,
                        height: 20,
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.all(Radius.circular(5))
                        ),
                          child: Text(
                            "Danger",
                          ),
                      ),
                      Text(
                        "Nama User checked in at Time",
                      ),
                    ],
                  ),
                ));
            }),
          ),
        ],
      ),
    );
  }
}