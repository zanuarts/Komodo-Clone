// To parse this JSON data, do
//
//     final personalNew = personalNewFromJson(jsonString);

import 'dart:convert';

PersonalNew personalNewFromJson(String str) => PersonalNew.fromJson(json.decode(str));

String personalNewToJson(PersonalNew data) => json.encode(data.toJson());

class PersonalNew {
    String status;
    int code;
    Auth auth;
    Result result;

    PersonalNew({
        this.status,
        this.code,
        this.auth,
        this.result,
    });

    factory PersonalNew.fromJson(Map<String, dynamic> json) => PersonalNew(
        status: json["status"],
        code: json["code"],
        auth: Auth.fromJson(json["auth"]),
        result: Result.fromJson(json["result"]),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "code": code,
        "auth": auth.toJson(),
        "result": result.toJson(),
    };
}

class Auth {
    String token;

    Auth({
        this.token,
    });

    factory Auth.fromJson(Map<String, dynamic> json) => Auth(
        token: json["token"],
    );

    Map<String, dynamic> toJson() => {
        "token": token,
    };
}

class Result {
    Data data;

    Result({
        this.data,
    });

    factory Result.fromJson(Map<String, dynamic> json) => Result(
        data: Data.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "data": data.toJson(),
    };
}

class Data {
    String idUser;
    String username;
    String email;
    String role;
    String createdBy;
    DateTime createdDate;
    int status;

    Data({
        this.idUser,
        this.username,
        this.email,
        this.role,
        this.createdBy,
        this.createdDate,
        this.status,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        idUser: json["id_user"],
        username: json["username"],
        email: json["email"],
        role: json["role"],
        createdBy: json["created_by"],
        createdDate: DateTime.parse(json["created_date"]),
        status: json["status"],
    );

    Map<String, dynamic> toJson() => {
        "id_user": idUser,
        "username": username,
        "email": email,
        "role": role,
        "created_by": createdBy,
        "created_date": "${createdDate.year.toString().padLeft(4, '0')}-${createdDate.month.toString().padLeft(2, '0')}-${createdDate.day.toString().padLeft(2, '0')}",
        "status": status,
    };
}
