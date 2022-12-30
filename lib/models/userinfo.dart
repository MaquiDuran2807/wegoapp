// To parse this JSON data, do
//
//     final clientinfo = clientinfoFromMap(jsonString);

import 'dart:convert';

class Clientinfo {
  Clientinfo({
    this.clients,
    this.conductor,
  });

  List<Client> clients;
  bool conductor;

  factory Clientinfo.fromJson(String str) => Clientinfo.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Clientinfo.fromMap(Map<String, dynamic> json) => Clientinfo(
    clients: List<Client>.from(json["clients"].map((x) => Client.fromMap(x))),
    conductor: json["conductor"],
  );

  Map<String, dynamic> toMap() => {
    "clients": List<dynamic>.from(clients.map((x) => x.toMap())),
    "conductor": conductor,
  };
}

class Client {
  Client({
    this.id,
    this.tokenN,
    this.name,
    this.lastname,
    this.img,
    this.isActive,
    this.calificacion,
    this.viajes,
    this.saldo,
  });

  int id;
  String tokenN;
  String name;
  String lastname;
  String img;
  bool isActive;
  double calificacion;
  int viajes;
  int saldo;

  factory Client.fromJson(String str) => Client.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Client.fromMap(Map<String, dynamic> json) => Client(
    id: json["id"],
    tokenN: json["tokenN"],
    name: json["name"],
    lastname: json["lastname"],
    img: json["img"],
    isActive: json["is_active"],
    calificacion: json["calificacion"],
    viajes: json["viajes"],
    saldo: json["saldo"],
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "tonN":tokenN,
    "name": name,
    "lastname": lastname,
    "img": img,
    "is_active": isActive,
    "calificacion": calificacion,
    "viajes": viajes,
    "saldo": saldo,
  };
}
