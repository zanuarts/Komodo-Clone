import 'dart:convert';

Absen absenFromJson(String str) => Absen.fromJson(json.decode(str));

String absenToJson(Absen data) => json.encode(data.toJson());

class Absen {
  Data data;

  Absen({
    this.data,
  });

  factory Absen.fromJson(Map<String, dynamic> json) => Absen(
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
  Hasil hasil;

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
    hasil: Hasil.fromJson(json["hasil"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "code": code,
    "hasil": hasil.toJson(),
  };
}

class Hasil {
  String idAbsensi;
  dynamic idKaryawan;
  String idUser;
  DateTime checkinDate;
  String checkinTime;
  dynamic checkOutDate;
  dynamic checkOutTime;
  String lattitude;
  String longitude;
  String idLevel;
  String lateReason;
  dynamic leaveReason;

  Hasil({
    this.idAbsensi,
    this.idKaryawan,
    this.idUser,
    this.checkinDate,
    this.checkinTime,
    this.checkOutDate,
    this.checkOutTime,
    this.lattitude,
    this.longitude,
    this.idLevel,
    this.lateReason,
    this.leaveReason,
  });

  factory Hasil.fromJson(Map<String, dynamic> json) => Hasil(
    idAbsensi: json["id_absensi"],
    idKaryawan: json["id_karyawan"],
    idUser: json["id_user"],
    checkinDate: DateTime.parse(json["checkin_date"]),
    checkinTime: json["checkin_time"],
    checkOutDate: json["check_out_date"],
    checkOutTime: json["check_out_time"],
    lattitude: json["lattitude"],
    longitude: json["longitude"],
    idLevel: json["id_level"],
    lateReason: json["late_reason"],
    leaveReason: json["leave_reason"],
  );

  Map<String, dynamic> toJson() => {
    "id_absensi": idAbsensi,
    "id_karyawan": idKaryawan,
    "id_user": idUser,
    "checkin_date": "${checkinDate.year.toString().padLeft(4, '0')}-${checkinDate.month.toString().padLeft(2, '0')}-${checkinDate.day.toString().padLeft(2, '0')}",
    "checkin_time": checkinTime,
    "check_out_date": checkOutDate,
    "check_out_time": checkOutTime,
    "lattitude": lattitude,
    "longitude": longitude,
    "id_level": idLevel,
    "late_reason": lateReason,
    "leave_reason": leaveReason,
  };
}
