// To parse this JSON data, do
//
//     final pcarreras = pcarrerasFromMap(jsonString);

import 'dart:convert';

class Pcarreras {
  Pcarreras({
    this.message,
    this.servicios,
    this.consultar,
    this.horaPeticion,
  });

  String message;
  String servicios;
  DateTime consultar;
  DateTime horaPeticion;

  factory Pcarreras.fromJson(String str) => Pcarreras.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Pcarreras.fromMap(Map<String, dynamic> json) => Pcarreras(
    message: json["message"],
    servicios: json["servicios"],
    consultar: DateTime.parse(json["consultar"]),
    horaPeticion: DateTime.parse(json["horaPeticion"]),
  );

  Map<String, dynamic> toMap() => {
    "message": message,
    "servicios": servicios,
    "consultar": consultar.toIso8601String(),
    "horaPeticion": horaPeticion.toIso8601String(),
  };
}
