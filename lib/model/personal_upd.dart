// To parse this JSON data, do
//
//     final personalUpd = personalUpdFromJson(jsonString);

import 'dart:convert';

PersonalUpd personalUpdFromJson(String str) => PersonalUpd.fromJson(json.decode(str));

String personalUpdToJson(PersonalUpd data) => json.encode(data.toJson());

class PersonalUpd {
  int code;
  String status;
  String message;
  Auth auth;
  List<Branch> branch;

  PersonalUpd({
    this.code,
    this.status,
    this.message,
    this.auth,
    this.branch,
  });

  factory PersonalUpd.fromJson(Map<String, dynamic> json) => PersonalUpd(
    code: json["code"],
    status: json["status"],
    message: json["message"],
    auth: Auth.fromJson(json["auth"]),
    branch: List<Branch>.from(json["branch"].map((x) => Branch.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "code": code,
    "status": status,
    "message": message,
    "auth": auth.toJson(),
    "branch": List<dynamic>.from(branch.map((x) => x.toJson())),
  };
}

class Auth {
  int id;
  String username;
  String personId;
  String fullName;
  int role;
  String roleName;
  String photo;
  Jwt jwt;

  Auth({
    this.id,
    this.username,
    this.personId,
    this.fullName,
    this.role,
    this.roleName,
    this.photo,
    this.jwt,
  });

  factory Auth.fromJson(Map<String, dynamic> json) => Auth(
    id: json["id"],
    username: json["username"],
    personId: json["person_id"],
    fullName: json["full_name"],
    role: json["role"],
    roleName: json["role_name"],
    photo: json["photo"],
    jwt: Jwt.fromJson(json["jwt"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "username": username,
    "person_id": personId,
    "full_name": fullName,
    "role": role,
    "role_name": roleName,
    "photo": photo,
    "jwt": jwt.toJson(),
  };
}

class Jwt {
  String token;
  int expires;

  Jwt({
    this.token,
    this.expires,
  });

  factory Jwt.fromJson(Map<String, dynamic> json) => Jwt(
    token: json["token"],
    expires: json["expires"],
  );

  Map<String, dynamic> toJson() => {
    "token": token,
    "expires": expires,
  };
}

class Branch {
  int branchId;
  String latitude;
  String longitude;

  Branch({
    this.branchId,
    this.latitude,
    this.longitude,
  });

  factory Branch.fromJson(Map<String, dynamic> json) => Branch(
    branchId: json["branch_id"],
    latitude: json["latitude"],
    longitude: json["longitude"],
  );

  Map<String, dynamic> toJson() => {
    "branch_id": branchId,
    "latitude": latitude,
    "longitude": longitude,
  };
}
