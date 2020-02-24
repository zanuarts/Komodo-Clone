import 'package:flutter/material.dart';
import '../home/drawer.dart';
//import 'package:flutter_ui1/components/drawer.dart';


void main(){
  runApp(
      new MaterialApp(
        title:"Halaman tiga",
        home: new Halamantiga(),
      )
  );
}

class Halamantiga extends StatelessWidget {

  List lokasi = [
    'Jakarta',
    'Bandung',
    'Bogor',
    'Bekasi',
    'Malang',
    'Surabaya',
    'Jogjakarta',
    'Solo',
  ];



  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: new Text("Project"),
        centerTitle: true,
        backgroundColor: Colors.deepOrangeAccent,
      ),
      drawer: DrawerApp(),
      body: new Container(
        child : ListView(
          children: lokasi.map((nama){
            return ListTile(
              leading: Icon(Icons.map),
              title: Text(nama,
                style: TextStyle(
                    fontFamily: 'Helvetica'
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}