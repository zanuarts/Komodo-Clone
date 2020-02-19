import 'package:equatable/equatable.dart';

class Personal extends Equatable{
  final String id;
  final String username;
  final String person_id;
  final String full_name;
  final String role;
  final String role_name;
  
  Personal({
    this.id,
    this.username,
    this.person_id,
    this.full_name,
    this.role,
    this.role_name,
  });

  @override
  List<Object> get props => [
    id,username,person_id,full_name,role,role_name,
  ];

  static Personal fromJson(dynamic json){
    final dataPersonal = json['data']['dataPersonal'];
    final dataPosisi = json['data']['dataPosisi'];
    return Personal(
      id:dataPersonal['ID'],
      username:dataPosisi['USERNAME'],
      person_id:dataPosisi['PERSON ID'],
      full_name:dataPosisi['FULL NAME'],
      role:dataPosisi['ROLE'],
      role_name:dataPosisi['ROLE NAME'],
    );
  }
}