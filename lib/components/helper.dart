import 'dart:async';
import 'dart:io';
import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
//import 'package:http/http.dart' as http;
//import 'dart:convert';

class Helper {
  static Helper _instance;
  factory Helper() => _instance ??= new Helper._();
  Helper._();

  // the unique ID of the application
  String _applicationId = "komodo_app";

  // the storage key for the token
  String _storageKeyMobileAuthKey = "authKey";

  // the storage key for the user id
  String _storageKeyMobileUserId = "userid";

  // the storage key for the username
  String _storageKeyMobileUsername = "username";

  // the storage key for the full name
  String _storageKeyMobileFullName = "fullName";

  // the storage key for the person id
  String _storageKeyMobilePersonId = "personID";

  // the storage key for the person id
  String _storageKeyMobilePhoto = "photo";

  // the mobile device unique identity
  String _deviceIdentity = "";

  static getApplicationVersion() {
    return 'v1.1.0';
  }

  final DeviceInfoPlugin _deviceInfoPlugin = new DeviceInfoPlugin();
  Future<String> _getDeviceIdentity() async {
    if (_deviceIdentity == '') {
      try {
        if (Platform.isAndroid) {
          AndroidDeviceInfo info = await _deviceInfoPlugin.androidInfo;
          _deviceIdentity = "${info.device}-${info.id}";
        } else if (Platform.isIOS) {
          IosDeviceInfo info = await _deviceInfoPlugin.iosInfo;
          _deviceIdentity = "${info.model}-${info.identifierForVendor}";
        }
      } on PlatformException {
        _deviceIdentity = "unknown";
      }
    }

    return _deviceIdentity;
  }

  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  Future<String> _getMobileAuthKey() async {
    final SharedPreferences prefs = await _prefs;

    return prefs.getString(_storageKeyMobileAuthKey) ?? '';
  }

  Future<bool> _setMobileAuthKey(String authKey) async {
    final SharedPreferences prefs = await _prefs;

    return prefs.setString(_storageKeyMobileAuthKey, authKey);
  }

  Future<String> _getMobileUserId() async {
    final SharedPreferences prefs = await _prefs;

    return prefs.getString(_storageKeyMobileUserId) ?? '';
  }

  Future<bool> _setMobileUserId(String userid) async {
    final SharedPreferences prefs = await _prefs;

    return prefs.setString(_storageKeyMobileUserId, userid);
  }

  Future<String> _getMobileUsername() async {
    final SharedPreferences prefs = await _prefs;

    return prefs.getString(_storageKeyMobileUsername) ?? '';
  }

  Future<bool> _setMobileUsername(String username) async {
    final SharedPreferences prefs = await _prefs;

    return prefs.setString(_storageKeyMobileUsername, username);
  }

  Future<String> _getMobileFullName() async {
    final SharedPreferences prefs = await _prefs;

    return prefs.getString(_storageKeyMobileFullName) ?? '';
  }

  Future<bool> _setMobileFullName(String fullName) async {
    final SharedPreferences prefs = await _prefs;

    return prefs.setString(_storageKeyMobileFullName, fullName);
  }

  Future<String> _getMobilePersonId() async {
    final SharedPreferences prefs = await _prefs;

    return prefs.getString(_storageKeyMobilePersonId) ?? '';
  }

  Future<bool> _setMobilePersonId(String personId) async {
    final SharedPreferences prefs = await _prefs;

    return prefs.setString(_storageKeyMobilePersonId, personId);
  }

  Future<String> _getPhotoUser() async {
    final SharedPreferences prefs = await _prefs;

    return prefs.getString(_storageKeyMobilePhoto) ?? '';
  }

  Future<bool> _setPhotoUser(String photo) async {
    final SharedPreferences prefs = await _prefs;

    return prefs.setString(_storageKeyMobilePhoto, photo);
  }

  Future<String> getDeviceId() async {
    var deviceId = await _getDeviceIdentity();
    return deviceId;
  }

  Future<String> getApplicationId() async {
    var applicationId = _applicationId;
    return applicationId;
  }

  Future<Map<String, dynamic>> checkSession() async {
    var authKey = await _getMobileAuthKey();
    var status = false;
    if (authKey != '') {
      status = true;
    } else {
      status = false;
    }

    var session = {
      'status': status,
      'auth_key': authKey,
    };
    return session;
  }

  Future<bool> setSession(
      String authKey, userid, username, fullName, personId) async {
    await _setMobileAuthKey(authKey);
    await _setMobileUserId(userid);
    await _setMobileUsername(username);
    await _setMobileFullName(fullName);
    await _setMobilePersonId(personId);
    return null;
  }

  Future<Map<String, dynamic>> getSession() async {
    var sessionUserAuthKey = await _getMobileAuthKey();
    var sessionUserId = await _getMobileUserId();
    var sessionUsername = await _getMobileUsername();
    var sessionFullName = await _getMobileFullName();
    var sessionPersonId = await _getMobilePersonId();
    var deviceId = await _getDeviceIdentity();
    var session = {
      'application_id': _applicationId,
      'device_id': deviceId,
      'auth_key': sessionUserAuthKey,
      'userid': sessionUserId,
      'username': sessionUsername,
      'full_name': sessionFullName,
      'person_id': sessionPersonId,
    };
    return session;
  }

  Future<bool> setPhotoUser(String photo) async {
    await _setPhotoUser(photo);
    return null;
  }

  Future<String> getPhotoUser() async {
    var userPhotoUser = await _getPhotoUser();
    return userPhotoUser;
  }

  Future<bool> login(
      String authKey, userid, username, fullName, personId) async {
    await setSession(authKey, userid, username, fullName, personId);
    return null;
  }

  Future<bool> logout() async {
    await _setMobileAuthKey('');
    await _setMobileUserId('');
    await _setMobileUsername('');
    await _setMobilePersonId('');
    await _setMobileFullName('');
    return null;
  }



  static messageComingSoon() {
    Fluttertoast.showToast(
        msg: "Coming soon",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIos: 1,
        backgroundColor: Colors.deepOrange,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  static getGreeting() {

    DateTime dateTimeNowData = DateTime.now();
    String hourNowDataString = DateFormat('kk.mm').format(dateTimeNowData);
    double hourNowDataDouble = double.parse(hourNowDataString);
    var hourNow = hourNowDataDouble;
    var greeting = '';

    if (hourNow >= 04.30 && hourNow <= 09.59) {
      greeting = 'Good Moring';
    } else if (hourNow >= 10.00 && hourNow <= 14.59) {
      greeting = 'Good Day';
    } else if (hourNow >= 15.00 && hourNow <= 18.59) {
      greeting = 'Good Afternoon';
    } else if (hourNow >= 19.00) {
      greeting = 'Good Night';
    } else if (hourNow >= 00.00 && hourNow < 4.30){
      greeting = 'Good Night';
    }
    return greeting;
  }
}
