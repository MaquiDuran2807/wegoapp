// To parse this JSON data, do
//
//     final prices = pricesFromMap(jsonString);

import 'dart:convert';

class Prices {
  Prices({
    this.precios,
  });

  List<Precio> precios;

  factory Prices.fromJson(String str) => Prices.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Prices.fromMap(Map<String, dynamic> json) => Prices(
    precios: List<Precio>.from(json["precios"].map((x) => Precio.fromMap(x))),
  );

  Map<String, dynamic> toMap() => {
    "precios": List<dynamic>.from(precios.map((x) => x.toMap())),
  };
}

class Precio {
  Precio({
    this.id,
    this.ppkm,
    this.ppm,
    this.pm,
    this.fechainit,
  });

  int id;
  double ppkm;
  double ppm;
  double pm;
  String fechainit;

  factory Precio.fromJson(String str) => Precio.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Precio.fromMap(Map<String, dynamic> json) => Precio(
    id: json["id"],
    ppkm: json["ppkm"],
    ppm: json["ppm"],
    pm: json["pm"],
    fechainit: json["fechainit"],
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "ppkm": ppkm,
    "ppm": ppm,
    "pm": pm,
    "fechainit": fechainit,
  };
}
