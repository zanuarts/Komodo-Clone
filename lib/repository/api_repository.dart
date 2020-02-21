import 'dart:async';

import 'package:meta/meta.dart';

import 'package:komodo_ui/repository/api_client.dart';
import 'package:komodo_ui/model/model.dart';

class ApiRepository {
  final ApiFactory apiFactory;
  ApiRepository({@required this.apiFactory}):assert(apiFactory != null);
  Future<Personal> getProfile(String id) async {
    return apiFactory.getPersonal(id);
  }
}