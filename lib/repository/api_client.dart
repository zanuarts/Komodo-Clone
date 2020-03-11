import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:komodo_ui/model/model.dart';
class ApiFactory {
  static const baseUrl = 'https://cbnusantara.id/api_komodo_dev/login';
  // static const baseUrl = 'https://ojanhtp.000webhostapp.com/auth/login';
  final http.Client httpClient;
  ApiFactory({
    @required this.httpClient,
  }) : assert(httpClient != null);

  Future<PersonalUpd> getPersonal(String id) async {
    final locationUrl = '$baseUrl/$id';
    final response = await this.httpClient.get(locationUrl,headers: {'x-authorization': "Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyIjoidXNlcnRlc3QxIiwiZXhwIjoxNTgyMDk5NzI1LCJqdGkiOiJvRldRaCIsInN1YiI6ImNibnVzYW50YXJhLmlkIn0.SsGwxxA6UrcaAvJuOGapvaktTKR_0psS_EACDPikWF0"});
    // final response = await this.httpClient.get(locationUrl,headers: 
    // {'x-authorization': "Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwczovL29qYW5odHAuMDAwd2ViaG9zdGFwcC5jb20vYXV0aC9sb2dpbiIsImlhdCI6MTU4Mzk0MzE3MiwiZXhwIjoxNTgzOTQ2NzcyLCJuYmYiOjE1ODM5NDMxNzIsImp0aSI6ImN6SExRQ0tOM3lhb3Nnd24iLCJzdWIiOiI5MzY3Y2Y5NC1kY2VjLTQ5Y2EtYmQ1Yi05NjQzZmI4MDc2MmUiLCJwcnYiOiIyM2JkNWM4OTQ5ZjYwMGFkYjM5ZTcwMWM0MDA4NzJkYjdhNTk3NmY3In0.R0Pni28bzMTw6HUrYpRj0Vp6iUUYXKDF_9UcyDjBxsY"});
    if (response.statusCode != 200 || response.statusCode != 201){
      // throw Exception('error getting profile for id :$id');
    }
    final weatherJson = jsonDecode(response.body);
    return PersonalUpd.fromJson(weatherJson);
  }
}