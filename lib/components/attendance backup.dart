import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/io_client.dart';
import 'package:komodo_ui/components/globalkey.dart';
import 'dart:async';
import 'dart:convert';
import 'package:pk_skeleton/pk_skeleton.dart';
import 'package:pigment/pigment.dart';

class Attendance extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Quote>(
      future: getQuote(), //sets the getQuote method as the expected Future
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<Data> data = snapshot.data.data;
          return ListView.builder(
              shrinkWrap: true,
              physics: ClampingScrollPhysics(),
              itemCount: data.length,
              itemBuilder: (BuildContext context, int index) {
                // int rifdis = int.tryparse(rifdi);
                return Container(
                    margin: EdgeInsets.only(left: 14, right: 14, bottom: 10),
                    padding:
                    EdgeInsets.only(top: 8, bottom: 8, left: 5, right: 5),
                    decoration: BoxDecoration(
                      color: Colors.white10,
                      borderRadius: new BorderRadius.all(Radius.circular(5.0)),
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                          color: Colors.black12,
                          offset: Offset(1.0, 1.0),
//                          blurRadius: 1.0,
                        ),
                      ],
                    ),
                    child: Column(children: <Widget>[
                      Row(
                        // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.center,

                        children: <Widget>[
                          Expanded(
                              flex: 1,
                              child: Container(
                                padding: EdgeInsets.only(
                                    top: 3, bottom: 3, left: 8, right: 8),
                                margin: EdgeInsets.only(right: 7),
                                decoration: BoxDecoration(
                                    color:
                                    Pigment.fromString(data[index].color),
                                    borderRadius: new BorderRadius.all(
                                        Radius.circular(5.0))),
                                child: Text(
                                  data[index].label,
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.white,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              )),
                          Flexible(
                              flex: 3,
                              child: RichText(
                                  text: TextSpan(
                                      text: '${data[index].nama} ',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 12,
                                        // fontWeight: FontWeight.bold,
                                      ),
                                      children: <TextSpan>[
                                        TextSpan(
                                            text: 'checked in ats',
                                            style: TextStyle(
                                              color: Colors.black38,
                                              fontSize: 10,
                                            )
                                          // text: '${data[index].tglmulai} s/d ${data[index].tglselesai}',style: TextStyle(
                                          // fontSize: 13,
                                          // color: Colors.black54,)
                                        ),
                                        TextSpan(
                                          text: '  ${data[index].checkin}',
                                          // style: TextStyle()
                                        )
                                      ]))),
                        ],
                      ),
                    ]));
              });
        }

        return PKCardListSkeleton(
          isCircularImage: true,
          isBottomLinesActive: true,
          length: 1,
        );
      },
    );
  }
}

Future<Quote> getQuote() async {
  HttpClient httpClient = new HttpClient()
    ..badCertificateCallback =
    ((X509Certificate cert, String host, int port) => true);
  IOClient ioClient = new IOClient(httpClient);

  String url = '$apiwebsite/getListAttendance';
  final response =
  await ioClient.post(url, headers: {"Accept": "application/json"});

  if (response.statusCode == 201) {
    return Quote.fromJson(json.decode(response.body));
  }else{
    return null;
  }
}

class Quote {
  final String author;
  final String quote;
  final List<Data> data;

  Quote({this.author, this.quote, this.data});

  factory Quote.fromJson(Map<String, dynamic> json) {
    var list = json['data'] as List;
    List<Data> data = list.map((i) => Data.fromJson(i)).toList();

    return Quote(author: json['message'], quote: json['status'], data: data);
  }
}

class Data {
  final String nama;
  final String label;
  final String checkin;
  final String color;

  Data({this.nama, this.label, this.color, this.checkin});

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
        nama: json['nama'],
        label: (json['label'] != null) ? json['label'] : '',
        color: (json['color'] != null) ? json['color'] : '#fff',
        checkin: json['checkin_time']);
  }
}
