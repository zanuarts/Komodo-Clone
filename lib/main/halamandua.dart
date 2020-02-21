import 'package:flutter/material.dart';
import 'package:komodo_ui/home/drawer.dart';

void main(){
  runApp(
      new MaterialApp(
        title:"Halaman dua",
        home: new Halamandua(),
      )
  );
}

class Halamandua extends StatefulWidget {
  @override
  _MyappState createState() => _MyappState();
}

class _MyappState extends State {

  void _tampilkanalert(){
    AlertDialog alertDialog = new AlertDialog(
      content: new Container(
        height: 80.0,
        child : Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildButtonColumn(Icons.fingerprint, 'PUT YOUR FINGERPRINT'),
          ],
        ),
      ),
      actions: [
        FlatButton(
          child: Text('Cancel'),
          onPressed: (){
            Navigator.of(context).pop();
            /*Navigator.push(context,
              MaterialPageRoute(builder: (context) => home()),
            );*/
          },
        ),
      ],
    );
    showDialog(context: context, child: alertDialog, barrierDismissible: false,);
  }



  @override
  Widget build(BuildContext context){

    //Color color = Theme.of(context).primaryColor;
    Colors.deepOrangeAccent;

    Widget submitSection = Container(
      
      child: RaisedButton(
        shape: RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(10.0),

        ),
        child: Text(
          "Submit Absen",
          style:TextStyle(color: Colors.white,
              fontFamily: 'Helvetica'
          ),


        ),
        color: Colors.deepOrangeAccent,
        onPressed: (){
          _tampilkanalert();
        },
      ),
    );

    Widget textSection = Container(
      padding: const EdgeInsets.all(32),
      child: Text(
        'Lake Oeschinen lies at the foot of the Blüemlisalp in the Bernese '
            'Alps. Situated 1,578 meters above sea level, it is one of the '
            'larger Alpine Lakes. A gondola ride from Kandersteg, followed by a '
            'half-hour walk through pastures and pine forest, leads you to the '
            'lake, which warms to 20 degrees Celsius in the summer. Activities '
            'enjoyed here include rowing, and riding the summer toboggan run.',
        softWrap: true,
        style: TextStyle(
            fontFamily: 'Helvetica'
        ),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: new Text("Absensi"),
        centerTitle: true,
        backgroundColor: Colors.deepOrangeAccent,
      ),
      drawer: DrawerApp(),
      body: ListView(
        children: [

          textSection,
          submitSection,
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