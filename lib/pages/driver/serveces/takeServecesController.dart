import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wegocol/models/driverRealtime.dart';
import 'package:wegocol/providers/auth_providers.dart';


class DriverTravelRequestController {

  BuildContext context;
  Function refresh;
  GlobalKey<ScaffoldState> key = GlobalKey<ScaffoldState>();
  TextEditingController comentController = new TextEditingController();
  String from;
  String to;
  String imagen;
  LatLng fromLatLng;
  LatLng toLatLng;
  double fromLat;
  double fromlng;
  double tolat;
  double tolng;
  DateTime hora;
  int idCliente;
  int precio;
  String distancia;
  String name;
  String lastname;
  String testimado;
  int tel;
  int myId;
  String tokenN;
  String coment ="";
  var dio=Dio();




  List<EstadoElement>option;

  AuthProvider _authProvider;


  List<String> nearbyDrivers = new List();

  StreamSubscription<List<DocumentSnapshot>> _streamSubscription;

  Future init(BuildContext context, Function refresh) {
    this.context = context;
    this.refresh = refresh;

    _authProvider = new AuthProvider();

    Map<String, dynamic> arguments = ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
    from= arguments["recogidan"];
    to = arguments['destino'];
    imagen = arguments['imagen'];
    fromLat= arguments['fromlat'];
    fromlng= arguments['fromlng'];
    tolat= arguments['tolat'];
    tolng= arguments['tolng'];
    hora=arguments["hora"];
    idCliente=arguments['idCliente'];
    precio=arguments['precio'];
    distancia=arguments['distancia'];
    name=arguments["name"];
    lastname=arguments["lastname"];
    testimado=arguments["tiempoe"];
    tel=arguments["tel"];
    myId=arguments["myId"];
    tokenN=arguments["tokenN"];
    _sendNotification();


    print('este es el from $from to $to imagen $imagen');
    refresh;

  }

  void dispose () {
    _streamSubscription?.cancel();
  }
  navegarClient( ){
    // Launch Waze
    print('aqui vamos a navegar al cliente');
    String mapRequest = "https://waze.com/ul?ll=" + fromLat.toString() + "," + fromlng.toString() + "&navigate=yes&zoom=17";
    Uri url = Uri.parse(mapRequest);
    launchUrl(url,mode:LaunchMode.externalApplication);

  }

  navegarDestino(){
    // Launch Waze
    print('aqui vamos a navegar al destino');
    String mapRequest = "https://waze.com/ul?ll=" + tolat.toString() + "," + tolng.toString() + "&navigate=yes&zoom=17";
    Uri url = Uri.parse(mapRequest);
    launchUrl(url,mode:LaunchMode.externalApplication);

  }
  void lanzarTel(){
    var url=Uri.parse('https://api.whatsapp.com/send?phone=$tel');
    launchUrl(url,mode:LaunchMode.externalApplication);

  }
  void cancelServices()async{
    print('canclo');
    var data={"llave":"carrerastake${hora.toString()}$idCliente","rol":1,"hora_pedido":hora.toString()};
    var response = await Dio().post('https://wegoapli.azurewebsites.net/carreras/cancels',data: data);
    print('este es el dio :${response.statusCode}');
    print(response.data);
  }
  void calificationAndFinich(cal)async{
    coment=comentController.text;
   final data={"id":idCliente,"calificacion":cal,"comentario":coment, "hora":hora.toString(),"mi_id":myId,"rol":"condutor","precio":-precio};
    var response = await Dio().post('https://wegoapli.azurewebsites.net/clients/clientcalification',data: data);
    print('este es el dio :${response.statusCode}');
    print(response.data);
    Navigator.pushNamedAndRemoveUntil(
        context, 'driver/map', (route) => false);
  }


  /*Future<void> getDriverInfo(String idDriver) async {
    Driver driver = await _driverProvider.getById(idDriver);
    _sendNotification(driver.token);
  }*/

  void _sendNotification() async{
    print('TOKEN: enviar notificacion======================================================================================================================');

    dio.options.headers={
      'Content-Type': 'application/json',
      'Authorization': 'Bearer AAAAxYBh0qU:APA91bF-WXSXqeeehj2b3--O_BePVFWf7mqNmdgj_WO4OKv4LodaI1z-JFsq2Miyu1Hy5Ny5O7etF3WtjJFFdmxydhGVE821YnT2BVLeeIG6VJIxAN7HCfogYvkKRX6lFEKZYHmFYiap'
    };

    Map<String, dynamic> data = {
      'click_action': 'Un conductor a tomado tu carrera',
      'idClient': tokenN,
      'origin': name,
      'destination': lastname,
    };
    var response= await dio.post("https://fcm.googleapis.com/fcm/send",data:data);
   // _pushNotificationsProvider.sendMessage(token, data, 'Solicitud de servicio', 'Un cliente esta solicitando viaje');
  }

}