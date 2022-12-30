// To parse this JSON data, do
//
//     final mysrvice = mysrviceFromMap(jsonString);

import 'dart:convert';

class Mysrvice {
  Mysrvice({
    this.mywego,
    this.llave,
    this.tiempopedido,
  });

  List<Mywego> mywego;
  String llave;
  DateTime tiempopedido;

  factory Mysrvice.fromJson(String str) => Mysrvice.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Mysrvice.fromMap(Map<String, dynamic> json) => Mysrvice(
    mywego: List<Mywego>.from(json["mywego"].map((x) => Mywego.fromMap(x))),
    llave: json["llave"],
    tiempopedido: DateTime.parse(json["tiempopedido"]),
  );

  Map<String, dynamic> toMap() => {
    "mywego": List<dynamic>.from(mywego.map((x) => x.toMap())),
    "llave": llave,
    "tiempopedido": tiempopedido.toIso8601String(),
  };
}

class Mywego {
  Mywego({
    this.id,
    this.token,
    this.identification,
    this.name,
    this.lastname,
    this.genero,
    this.email,
    this.img,
    this.imgcc,
    this.tel,
    this.isActive,
    this.calificacion,
  });

  int id;
  String token;
  int identification;
  String name;
  String lastname;
  String genero;
  String email;
  String img;
  String imgcc;
  int tel;
  bool isActive;
  var calificacion;

  factory Mywego.fromJson(String str) => Mywego.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Mywego.fromMap(Map<String, dynamic> json) => Mywego(
    id: json["id"],
    token: json["token"],
    identification: json["identification"],
    name: json["name"],
    lastname: json["lastname"],
    genero: json["genero"],
    email: json["email"],
    img: json["img"],
    imgcc: json["imgcc"],
    tel: json["tel"],
    isActive: json["is_active"],
    calificacion: json["calificacion"],
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "token": token,
    "identification": identification,
    "name": name,
    "lastname": lastname,
    "genero": genero,
    "email": email,
    "img": img,
    "imgcc": imgcc,
    "tel": tel,
    "is_active": isActive,
    "calificacion": calificacion,
  };
}
