// To parse this JSON data, do
//
//     final karyawan = karyawanFromJson(jsonString);

import 'dart:convert';

Karyawan karyawanFromJson(String str) => Karyawan.fromJson(json.decode(str));

String karyawanToJson(Karyawan data) => json.encode(data.toJson());

class Karyawan {
  Data data;

  Karyawan({
    this.data,
  });

  factory Karyawan.fromJson(Map<String, dynamic> json) => Karyawan(
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
  List<Hasil> hasil;

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
    hasil: List<Hasil>.from(json["hasil"].map((x) => Hasil.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "code": code,
    "hasil": List<dynamic>.from(hasil.map((x) => x.toJson())),
  };
}

class Hasil {
  String idKaryawan;
  dynamic namaLengkap;
  dynamic namaPanggilan;
  dynamic alamatDomisili;
  dynamic negaraDomisili;
  dynamic provinsiDomisili;
  dynamic kotaDomisili;
  dynamic tempatLahir;
  dynamic tanggalLahir;
  dynamic agama;
  dynamic golDarah;
  dynamic alamatAsal;
  dynamic negaraAsal;
  dynamic provinsiAsal;
  dynamic kotaAsal;
  dynamic nik;
  dynamic kewarganegaraan;
  dynamic noPassport;
  dynamic statusPerkawinan;
  dynamic gender;
  dynamic sukuBangsa;
  dynamic idPosisi;
  String idUser;
  DateTime createdAt;
  DateTime updatedAt;

  Hasil({
    this.idKaryawan,
    this.namaLengkap,
    this.namaPanggilan,
    this.alamatDomisili,
    this.negaraDomisili,
    this.provinsiDomisili,
    this.kotaDomisili,
    this.tempatLahir,
    this.tanggalLahir,
    this.agama,
    this.golDarah,
    this.alamatAsal,
    this.negaraAsal,
    this.provinsiAsal,
    this.kotaAsal,
    this.nik,
    this.kewarganegaraan,
    this.noPassport,
    this.statusPerkawinan,
    this.gender,
    this.sukuBangsa,
    this.idPosisi,
    this.idUser,
    this.createdAt,
    this.updatedAt,
  });

  factory Hasil.fromJson(Map<String, dynamic> json) => Hasil(
    idKaryawan: json["id_karyawan"],
    namaLengkap: json["nama_lengkap"],
    namaPanggilan: json["nama_panggilan"],
    alamatDomisili: json["alamat_domisili"],
    negaraDomisili: json["negara_domisili"],
    provinsiDomisili: json["provinsi_domisili"],
    kotaDomisili: json["kota_domisili"],
    tempatLahir: json["tempat_lahir"],
    tanggalLahir: json["tanggal_lahir"],
    agama: json["agama"],
    golDarah: json["gol_darah"],
    alamatAsal: json["alamat_asal"],
    negaraAsal: json["negara_asal"],
    provinsiAsal: json["provinsi_asal"],
    kotaAsal: json["kota_asal"],
    nik: json["nik"],
    kewarganegaraan: json["kewarganegaraan"],
    noPassport: json["no_passport"],
    statusPerkawinan: json["status_perkawinan"],
    gender: json["gender"],
    sukuBangsa: json["suku_bangsa"],
    idPosisi: json["id_posisi"],
    idUser: json["id_user"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id_karyawan": idKaryawan,
    "nama_lengkap": namaLengkap,
    "nama_panggilan": namaPanggilan,
    "alamat_domisili": alamatDomisili,
    "negara_domisili": negaraDomisili,
    "provinsi_domisili": provinsiDomisili,
    "kota_domisili": kotaDomisili,
    "tempat_lahir": tempatLahir,
    "tanggal_lahir": tanggalLahir,
    "agama": agama,
    "gol_darah": golDarah,
    "alamat_asal": alamatAsal,
    "negara_asal": negaraAsal,
    "provinsi_asal": provinsiAsal,
    "kota_asal": kotaAsal,
    "nik": nik,
    "kewarganegaraan": kewarganegaraan,
    "no_passport": noPassport,
    "status_perkawinan": statusPerkawinan,
    "gender": gender,
    "suku_bangsa": sukuBangsa,
    "id_posisi": idPosisi,
    "id_user": idUser,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
  };
}
