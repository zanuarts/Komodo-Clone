import 'dart:async';
import 'package:komodo_ui/halaman/component/absen.dart';
import 'package:meta/meta.dart';
import 'package:komodo_ui/repository/api_client.dart';
import 'package:komodo_ui/model/model.dart';

class ApiRepository {
  final ApiFactory apiFactory;
  ApiRepository({@required this.apiFactory}):assert(apiFactory != null);
  Future<PersonalNew> getProfile(String id) async {
    return apiFactory.getPersonal(id);
  }
}