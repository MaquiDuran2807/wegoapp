// To parse this JSON data, do
//
//     final exist = existFromMap(jsonString);

import 'dart:convert';

class Exist {
  Exist({
    this.cliente,
    this.typeUser,
  });

  bool cliente;
  bool typeUser;

  factory Exist.fromJson(String str) => Exist.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Exist.fromMap(Map<String, dynamic> json) => Exist(
    cliente: json["cliente"],
    typeUser: json["TypeUser"],
  );

  Map<String, dynamic> toMap() => {
    "cliente": cliente,
    "TypeUser": typeUser,
  };
}
