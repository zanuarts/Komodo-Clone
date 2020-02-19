import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_ui1/model/model.dart';
class ApiFactory {
  static const baseUrl = 'https://cbnusantara.id/api_komodo/login';
  final http.Client httpClient;
  ApiFactory({
    @required this.httpClient,
  }) : assert(httpClient != null);

  Future<Personal> getPersonal(String id) async {
    final locationUrl = '$baseUrl/$id';
    final response = await this.httpClient.get(locationUrl,headers: {'x-authorization': "Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyIjoidXNlcnRlc3QxIiwiZXhwIjoxNTgyMDk5NzI1LCJqdGkiOiJvRldRaCIsInN1YiI6ImNibnVzYW50YXJhLmlkIn0.SsGwxxA6UrcaAvJuOGapvaktTKR_0psS_EACDPikWF0"});
    if (response.statusCode != 200 || response.statusCode != 201){
      // throw Exception('error getting profile for id :$id');
    }
    final weatherJson = jsonDecode(response.body);
    return Personal.fromJson(weatherJson);
  }
}