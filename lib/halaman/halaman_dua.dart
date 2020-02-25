import 'package:flutter/material.dart';
import 'package:komodo_ui/home/drawer.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Halamandua extends StatefulWidget {
  @override
  _MyappState createState() => _MyappState();
}

class _MyappState extends State {
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
                  backgroundColor: Colors.green,  
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text("Good Day", style: TextStyle(color: Colors.white),),
                    Text('Nama User', style: TextStyle(color: Colors.white),),
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
              color: Colors.blueAccent,
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            child: Center(
              child: Text(
                "Log Absen",
                style: TextStyle(color : Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}