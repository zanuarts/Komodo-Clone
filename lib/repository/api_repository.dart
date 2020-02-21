import 'dart:async';

import 'package:meta/meta.dart';

import 'package:flutter_ui1/repository/api_client.dart';
import 'package:flutter_ui1/model/model.dart';

class ApiRepository {
  final ApiFactory apiFactory;
  ApiRepository({@required this.apiFactory}):assert(apiFactory != null);
  Future<Personal> getProfile(String id) async {
    return apiFactory.getPersonal(id);
  }
}