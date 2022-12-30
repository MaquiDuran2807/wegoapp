import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wegocol/models/driverRealtime.dart';
import 'package:wegocol/models/myservice.dart';
import 'package:wegocol/providers/auth_providers.dart';
import 'package:wegocol/utils/snackbar.dart' as utils ;

class ClientTravelRequestController {

  BuildContext context;
  Function refresh;
  GlobalKey<ScaffoldState> key = GlobalKey<ScaffoldState>();
  TextEditingController comentController = new TextEditingController();

  String from;
  String to;
  String imagen;
  String name;
  String lastname;
  var calificacion;
  int telefono;
  LatLng fromLatLng;
  LatLng toLatLng;
  double fromLat;
  double fromlng;
  double tolat;
  double tolng;
  String llave;
  int precio;
  DateTime hora;
  int respuesta;
  int id;
  int idConduc;
  List<EstadoElement>option;
  String coment="";

  AuthProvider _authProvider;
  String requestDriver='Buscando un conductor';


  List<String> nearbyDrivers = new List();

  StreamSubscription<List<DocumentSnapshot>> _streamSubscription;

  Future init(BuildContext context, Function refresh) {
    this.context = context;
    this.refresh = refresh;
    Timer.periodic(Duration(seconds: 20), (timer) {
      myServices();
      if(imagen!=null && name!=null && calificacion!=null){
        timer.cancel();
      }
    });


    _authProvider = new AuthProvider();

    Map<String, dynamic> arguments = ModalRoute
        .of(context)
        .settings
        .arguments as Map<String, dynamic>;
    llave = arguments["llave"];
    hora= arguments['horap'];
    precio = arguments['precio'];
    id = arguments['id'];

    print('este es el from $from to $to imagen $imagen');
    refresh;
  }
  void lanzarTel(){
    var url=Uri.parse('https://api.whatsapp.com/send?phone=$telefono');
    launchUrl(url,mode:LaunchMode.externalApplication);

  }
  void cancelServices()async{
    print('canclo');
    var data={"llave":"carrerastake${hora}$id","rol":2,"hora_pedido":hora.toString()};
    var response = await Dio().post('https://wegoapli.azurewebsites.net/carreras/cancels',data: data);
    print('este es el dio :${response.statusCode}');
    print(response.data);
  }
  myServices()async{
    var data={"id":id,"hora_peticion":hora.toString()};
    var response = await Dio().post('http://wegoapli.azurewebsites.net/carreras/myservice',data: data);
    print('este es el dio :${response.statusCode}');
    print(response.data);

    var myser=response.data;
    imagen=myser["mywego"][0]["img"];
    name=myser["mywego"][0]["name"];
    lastname=myser["mywego"][0]["lastname"];
    telefono=myser["mywego"][0]["tel"];
    calificacion=myser["mywego"][0]["calificacion"];
    idConduc=myser["mywego"][0]["id"];
    refresh;
    if(imagen!=null && name!=null && calificacion!=null){
      utils.Snackbar.showSnackbar(
          context, key, 'ya tienes conductor');
    }


  }
  void calificationAndFinich(cal)async{
     coment=comentController.text;
    final data={"id":idConduc,"calificacion":cal,"comentario":coment, "hora":hora,"mi_id":id,"rol":"cliente","precio":-precio};
    var response = await Dio().post('https://wegoapli.azurewebsites.net/clients/clientcalification',data: data);
    print('este es el dio :${response.statusCode}');
    print(response.data);
    Navigator.pushNamedAndRemoveUntil(
        context, 'driver/map', (route) => false);
  }

  void dispose () {
    _streamSubscription?.cancel();
  }
}