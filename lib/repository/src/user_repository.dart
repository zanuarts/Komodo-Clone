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
    var url = "https://ojanhtp.000webhostapp.com/auth/login";
    await http.post(url, body: {
      "username": username,
      "password": password
    }).then((s) async{
      var mess = convert.jsonDecode(s.body);
      if (mess['status'] == 'failed'){
        rt = mess['status'];

      } else {

      var idUser = mess['result']['data']['id_user'];
      var username = mess['result']['data']['username'];
      var token = mess['auth']['token'];
      var email = mess['result']['data']['email'];
      var role = mess['result']['data']['role'];
      var createdBy = mess['result']['data']['created_by'];
      var createdDate = mess['result']['data']['created_date'];
      // var status = mess['result']['data']['status'];

      SharedPreferences pref = await SharedPreferences.getInstance();
      pref.setString('id_user', idUser);
      pref.setString('username', username);
      pref.setString('token', token);
      pref.setString('email', email);
      pref.setString('role', role);
      pref.setString('created_by', createdBy);
      pref.setString('created_date', createdDate);
      // pref.setString('status', status);
      }
    });
    return rt;
  }

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
    await Future.delayed(Duration(seconds:1));
    return false;
  }
}
