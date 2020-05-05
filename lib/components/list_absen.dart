// To parse this JSON data, do
//
//     final listAbsen = listAbsenFromJson(jsonString);

import 'dart:convert';

ListAbsen listAbsenFromJson(String str) => ListAbsen.fromJson(json.decode(str));

String listAbsenToJson(ListAbsen data) => json.encode(data.toJson());

class ListAbsen {
    Data data;

    ListAbsen({
        this.data,
    });

    factory ListAbsen.fromJson(Map<String, dynamic> json) => ListAbsen(
        data: Data.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "data": data.toJson(),
    };
}

class Data {
    bool status;
    String message;
    int code;
    List<Map<String, String>> hasil;

    Data({
        this.status,
        this.message,
        this.code,
        this.hasil,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        status: json["status"],
        message: json["message"],
        code: json["code"],
        hasil: List<Map<String, String>>.from(json["hasil"].map((x) => Map.from(x).map((k, v) => MapEntry<String, String>(k, v == null ? null : v)))),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "code": code,
        "hasil": List<dynamic>.from(hasil.map((x) => Map.from(x).map((k, v) => MapEntry<String, dynamic>(k, v == null ? null : v)))),
    };
}
