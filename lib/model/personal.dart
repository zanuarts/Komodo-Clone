import 'package:equatable/equatable.dart';

class PersonalNew extends Equatable{
  // final String id;
  // final String username;
  // final String person_id;
  // final String full_name;
  // final String role;
  // final String role_name;

  String idUser;
  String username;
  String email;
  String role;
  String createdBy;
  DateTime createdDate;
  int status;
  
  PersonalNew({
    // this.id,
    // this.username,
    // this.person_id,
    // this.full_name,
    // this.role,
    // this.role_name,

    this.idUser,
        this.username,
        this.email,
        this.role,
        this.createdBy,
        this.createdDate,
        this.status,
  });

  @override
  List<Object> get props => [
    // id,username,person_id,full_name,role,role_name,
    idUser,username,email,role,createdBy,createdDate,status
  ];

  static PersonalNew fromJson(dynamic json){
    final data = json['result']['data'];
    // final dataPosisi = json['data']['dataPosisi'];
    return PersonalNew(
      // id:dataPersonal['ID'],
      // username:dataPosisi['USERNAME'],
      // person_id:dataPosisi['PERSON ID'],
      // full_name:dataPosisi['FULL NAME'],
      // role:dataPosisi['ROLE'],
      // role_name:dataPosisi['ROLE NAME'],

      idUser: data['id_user'],
      username: data['username'],
      email: data['email'],
      role: data['role'],
      createdBy: data['created_by'],
      createdDate: data['created_date'],
      status: data['status']
    );
  }
}