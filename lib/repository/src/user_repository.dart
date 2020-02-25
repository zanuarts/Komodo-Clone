import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'dart:convert' as convert;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

      } else {
//        rt = "bearer ${mess['auth']['jwt']['token']}";
//        await storage.write(key: 'bearer', value: mess['auth']['jwt']['token']);
      var id = mess['auth']['id'];
      var username = mess['auth']['username'];
      var token = mess['auth']['token'];
      var full_name = mess['auth']['full_name'];
      var role_name = mess['auth']['role_name'];
      var photo = mess['auth']['photo'];

      SharedPreferences pref = await SharedPreferences.getInstance();
      pref.setString('username', username);
      pref.setString('token', token);
      pref.setString('full_name', full_name);
      pref.setString('role_name', role_name);
      pref.setString('photo', photo);
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
