// To parse this JSON data, do
//
//     final estado = estadoFromMap(jsonString);

import 'dart:convert';
import 'dart:ffi';

class Estado {
  Estado({
    this.estado,
  });

  List<List<EstadoElement>> estado;

  factory Estado.fromJson(String str) => Estado.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Estado.fromMap(Map<String, dynamic> json) => Estado(
    estado: List<List<EstadoElement>>.from(json["estado"].map((x) => List<EstadoElement>.from(x.map((x) => EstadoElement.fromMap(x))))),
  );

  Map<String, dynamic> toMap() => {
    "estado": List<dynamic>.from(estado.map((x) => List<dynamic>.from(x.map((x) => x.toMap())))),
  };
}

class EstadoElement {
  EstadoElement({
    this.id,
    this.tokenNotifi,
    this.name,
    this.lastname,
    this.email,
    this.img,
    this.imgcc,
    this.tel,
    this.calificacion,
    this.coordenadas,
    this.viaje,
    this.horaPeticion,
    this.distanciaCliente,
  });

  int id;
  String tokenNotifi;
  String name;
  String lastname;
  String email;
  String img;
  String imgcc;
  int tel;
  var calificacion;
  Coordenadas coordenadas;
  Viaje viaje;
  DateTime horaPeticion;
  double distanciaCliente;

  factory EstadoElement.fromJson(String str) => EstadoElement.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory EstadoElement.fromMap(Map<String, dynamic> json) => EstadoElement(
    id: json["id"],
    tokenNotifi: json["tokenNotifi"],
    name: json["name"],
    lastname: json["lastname"],
    email: json["email"],
    img: json["img"],
    imgcc: json["imgcc"],
    tel: json["tel"],
    calificacion: json["calificacion"],
    coordenadas: Coordenadas.fromMap(json["coordenadas"]),
    viaje: Viaje.fromMap(json["viaje"]),
    horaPeticion: DateTime.parse(json["hora_peticion"]),
    distanciaCliente: json["distancia_cliente"].toDouble(),
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "tokenNotifi":tokenNotifi,
    "name": name,
    "lastname": lastname,
    "email": email,
    "img": img,
    "imgcc": imgcc,
    "tel": tel,
    "calificacion": calificacion,
    "coordenadas": coordenadas.toMap(),
    "viaje": viaje.toMap(),
    "hora_peticion": horaPeticion.toIso8601String(),
    "distancia_cliente": distanciaCliente,
  };
}

class Coordenadas {
  Coordenadas({
    this.recogida,
    this.destino,
  });

  Destino recogida;
  Destino destino;

  factory Coordenadas.fromJson(String str) => Coordenadas.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Coordenadas.fromMap(Map<String, dynamic> json) => Coordenadas(
    recogida: Destino.fromMap(json["recogida"]),
    destino: Destino.fromMap(json["destino"]),
  );

  Map<String, dynamic> toMap() => {
    "recogida": recogida.toMap(),
    "destino": destino.toMap(),
  };
}

class Destino {
  Destino({
    this.lat,
    this.lng,
    this.direccion,
  });

  double lat;
  double lng;
  String direccion;

  factory Destino.fromJson(String str) => Destino.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Destino.fromMap(Map<String, dynamic> json) => Destino(
    lat: json["lat"].toDouble(),
    lng: json["lng"].toDouble(),
    direccion: json["direccion"],
  );

  Map<String, dynamic> toMap() => {
    "lat": lat,
    "lng": lng,
    "direccion": direccion,
  };
}

class Viaje {
  Viaje({
    this.distancia,
    this.precio,
    this.testimado,
  });

  String distancia;
  int precio;
  String testimado;

  factory Viaje.fromJson(String str) => Viaje.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Viaje.fromMap(Map<String, dynamic> json) => Viaje(
    distancia: json["distancia"],
    precio: json["precio"],
    testimado: json["testimado"],
  );

  Map<String, dynamic> toMap() => {
    "distancia": distancia,
    "precio": precio,
    "testimado": testimado,
  };
}

