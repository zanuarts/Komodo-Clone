import 'package:flutter/material.dart';
import 'package:komodo_ui/home/drawer.dart';

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
        
        title: new Text("Absensi"),
        // backgroundColor: Colors.deepOrangeAccent,
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
                Padding(padding: const EdgeInsets.only(bottom:10, left: 25),
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
      body: ListView(
        padding: EdgeInsets.all(20.0),
      ),
    );
  }
}