import 'package:flutter/material.dart';
import 'package:komodo_ui/home/drawer.dart';


class Halamansatu extends StatefulWidget {
  @override
  _MyappState createState() => _MyappState();
}

class _MyappState extends State {


  @override
  Widget build(BuildContext context){

    //Color color = Theme.of(context).primaryColor;
    Colors.deepOrangeAccent;
  return Scaffold(
      appBar: AppBar(
        title: new Text("Home"),
        centerTitle: true,
        backgroundColor: Colors.deepOrangeAccent,
      ),
      drawer: DrawerApp(),
      body: ListView(
        children: [
        ],
        padding: EdgeInsets.all(20.0),
      ),
    );
  }

  Column _buildButtonColumn(IconData icon, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon),
        Container(
          margin: const EdgeInsets.only(top: 8),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w400,

            ),
          ),
        ),
      ],
    );
  }
}