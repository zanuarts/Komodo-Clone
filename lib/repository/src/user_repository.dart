import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'dart:convert' as convert;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class UserRepository {
  final storage = new FlutterSecureStorage();
  Future<String> authenticate({
    @required String username,
    @required String password,
})async {
    var rt = '';
    var url = "https://cbnusantara.id/api_komodo/login";
    await http.post(url, body: {
      "username": username,
      "password": password
    }).then((s) async{
      var mess = convert.jsonDecode(s.body);
      if (mess['status'] == 'failed'){
        rt = mess['status'];
        print(mess);
      } else {
        print(mess);
        print(rt);
        rt = "bearer ${mess['auth']['jwt']['token']}";
        await storage.write(key: 'bearer', value: mess['auth']['jwt']['token']);
      }

    });
    return rt;
    // await Future.delayed(Duration(seconds: 1));
    // return 'token';
  }
  // async {
  //   await Future.delayed(Duration(seconds: 1));
  //   return 'token';
  // }

  Future<void> deleteToken()async {
    //await storage.deleteAll();
    await Future.delayed(Duration(seconds: 1));
    return;
  }

  Future<void> persistToken (String token) async {
    
    await Future.delayed(Duration(seconds: 1));
    return;
  }

  Future<bool> hasToken() async{
    // String value = await storage.read(key: 'bearer');
    // if (value != ''){
    //   return true;
    // } else {
    //   return false;
    // }
    await Future.delayed(Duration(seconds:1));
    return false;
  }
}
