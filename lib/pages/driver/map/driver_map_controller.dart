

import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart'as location;
import 'package:progress_dialog/progress_dialog.dart';
import 'package:wegocol/models/driverRealtime.dart';
import 'package:wegocol/providers/auth_providers.dart';
import 'package:wegocol/utils/my_progres_dialog.dart';
import 'package:wegocol/utils/shared_pref.dart';
import 'package:wegocol/utils/snackbar.dart' as utils ;
import 'package:geolocator_android/geolocator_android.dart';
import 'package:geolocator_apple/geolocator_apple.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wegocol/providers/google_privider.dart';


class DriverMapController {
  BuildContext context;
  Function refresh;
  GlobalKey<ScaffoldState> key = new GlobalKey<ScaffoldState>();
  Completer<GoogleMapController> _mapController = Completer();
  List <List<EstadoElement>> options=<List<EstadoElement>>[];
  CameraPosition initialPosition = CameraPosition(
      target: LatLng(1.2342774, -77.2645446),
      zoom: 14.0
  );

  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};

  Position position;
  StreamSubscription<Position> _positionStream;

  BitmapDescriptor markerDriver;
  String token;

  AuthProvider _authProvider;
  //DriverProvider _driverProvider;
  //PushNotificationsProvider _pushNotificationsProvider;

  bool isConnect = false;
  ProgressDialog _progressDialog;
  int id;
  String name;
  String lastname;
  String imagen;
  bool isActive;
  double calificacion;
  int viajes;
  int saldo;
  SharedPref _sharedPref;
  String correo;
  String tokenN;

  //Driver driver;



  Future init(BuildContext context, Function refresh) async {
    this.context = context;
    this.refresh = refresh;
    _authProvider = new AuthProvider();
    _sharedPref = new SharedPref();
    correo = await _sharedPref.read('correo');
    //await _sharedPref.save('encarrera', "false");
    //_driverProvider = new DriverProvider();
    //_pushNotificationsProvider = new PushNotificationsProvider();
    _progressDialog = MyProgressDialog.createProgressDialog(context, 'Conectandose...');
    markerDriver = await createMarkerImageFromAsset('assets/img/taxi_icon.png');
    checkGPS();
    updateLocation();
    data();
    saveToken();
    tomar_datos_ini  ();
    //getDriverInfo();
  }
  void data()async{
    var data={"correo":correo};
    var response = await Dio().post('https://wegoapli.azurewebsites.net/clients/clientinfo',data: data);
    print('este es el dio :${response.statusCode}');
    print(response.data);
    id =response.data["clients"][0]["id"];
    name =response.data["clients"][0]["name"];
    lastname = response.data["clients"][0]["lastname"];
    imagen =response.data["clients"][0]["img"];
    isActive =response.data["clients"][0]["is_active"];
    calificacion =response.data["clients"][0]["calificacion"];
    viajes =response.data["clients"][0]["viajes"];
    saldo =response.data["clients"][0]["saldo"];
    print('lista de client id $id name $name lastname $lastname imagen $imagen isactive $isActive calificacion $calificacion viajes $viajes  saldo$saldo');
    refresh;
  }

  /*void getDriverInfo() {
    Stream<DocumentSnapshot> driverStream = _driverProvider.getByIdStream(_authProvider.getUser().uid);
    _driverInfoSuscription = driverStream.listen((DocumentSnapshot document) {
      driver = Driver.fromJson(document.data());
      refresh();
    });
  }*/
  void takeServeces(hora,idCliente)async{
    print("entro es el token de take serveces ==============================$token ============el hora $hora y el id cliente $idCliente===========================================");
    var data={"token":token,"hora_peticion":hora.toString(),"id":idCliente};
    var response = await Dio().post('https://wegoapli.azurewebsites.net/carreras/take',data: data);
    print('este es el dio :${response.statusCode}');
    print(response.data);
    await _sharedPref.save('encarrera', "true");

    refresh;

  }

  Future <List<EstadoElement>>tomar_datos_ini  ()async {
    print('arranco el init');
    print("este es el option$options");
    //final Estado = [];
    print('este es el token $token ubicacion ${position.latitude} y ${position.longitude} en el post inicial');

    var data={"token":token,"ubicacion":{"lat":position.latitude,  "lng":position.longitude}};
    var response = await Dio().post('https://wegoapli.azurewebsites.net/carreras/drivers',data: data);
    print('este es el dio :${response.statusCode}');
    if (response.statusCode == 200) {
      var carreras1 =Estado.fromMap(response.data);
      var carreras2=carreras1.estado;

      print(" respuesta carreras2 ${carreras2}");
      options=[];

      options.addAll(carreras2);
      print('hizo la peticion al arranque es esta $options');
      refresh();

    } else {
      throw Exception('fallo la conexion');
    }
  }

  void saveToken()async {
    token=_authProvider.getUser().uid;
    tokenN = await FirebaseMessaging.instance.getToken();
    print('estamos en el savetoken y este es el token de notifi $tokenN ============================================');
    dynamic data={"id":id ,"tokenN":tokenN};
    Dio().post('https://wegoapli.azurewebsites.net/clients/clientnotifica',data: data);
  }

  void openDrawer() {
    key.currentState.openDrawer();
  }

  void goToEditPage() {
    Navigator.pushNamed(context, 'driver/edit');
  }

  void dispose() {
    _positionStream?.cancel();
    //_statusSuscription?.cancel();
    //_driverInfoSuscription?.cancel();
  }

  void signOut() async {
    await _authProvider.signOut();
    Navigator.pushNamedAndRemoveUntil(context, 'home', (route) => false);
  }

  void onMapCreated(GoogleMapController controller) {
    controller.setMapStyle('[{"elementType":"geometry","stylers":[{"color":"#212121"}]},{"elementType":"labels.icon","stylers":[{"visibility":"off"}]},{"elementType":"labels.text.fill","stylers":[{"color":"#757575"}]},{"elementType":"labels.text.stroke","stylers":[{"color":"#212121"}]},{"featureType":"administrative","elementType":"geometry","stylers":[{"color":"#757575"}]},{"featureType":"administrative.country","elementType":"labels.text.fill","stylers":[{"color":"#9e9e9e"}]},{"featureType":"administrative.land_parcel","stylers":[{"visibility":"off"}]},{"featureType":"administrative.locality","elementType":"labels.text.fill","stylers":[{"color":"#bdbdbd"}]},{"featureType":"poi","elementType":"labels.text.fill","stylers":[{"color":"#757575"}]},{"featureType":"poi.park","elementType":"geometry","stylers":[{"color":"#181818"}]},{"featureType":"poi.park","elementType":"labels.text.fill","stylers":[{"color":"#616161"}]},{"featureType":"poi.park","elementType":"labels.text.stroke","stylers":[{"color":"#1b1b1b"}]},{"featureType":"road","elementType":"geometry.fill","stylers":[{"color":"#2c2c2c"}]},{"featureType":"road","elementType":"labels.text.fill","stylers":[{"color":"#8a8a8a"}]},{"featureType":"road.arterial","elementType":"geometry","stylers":[{"color":"#373737"}]},{"featureType":"road.highway","elementType":"geometry","stylers":[{"color":"#3c3c3c"}]},{"featureType":"road.highway.controlled_access","elementType":"geometry","stylers":[{"color":"#4e4e4e"}]},{"featureType":"road.local","elementType":"labels.text.fill","stylers":[{"color":"#616161"}]},{"featureType":"transit","elementType":"labels.text.fill","stylers":[{"color":"#757575"}]},{"featureType":"water","elementType":"geometry","stylers":[{"color":"#000000"}]},{"featureType":"water","elementType":"labels.text.fill","stylers":[{"color":"#3d3d3d"}]}]');
    _mapController.complete(controller);
  }


  void updateLocation() async  {
    try {
      await _determinePosition();
      position = await Geolocator.getLastKnownPosition();
      centerPosition();

      addMarker(
          'driver',
          position.latitude,
          position.longitude,
          'Tu posicion',
          '',
          markerDriver
      );
      refresh();

      _positionStream = Geolocator.getPositionStream(
          locationSettings:LocationSettings(accuracy: LocationAccuracy.best,distanceFilter: 1)
      ).listen((Position position) {
        position = position;
        addMarker(
            'driver',
            position.latitude,
            position.longitude,
            'Tu posicion',
            '',
            markerDriver
        );
        animateCameraToPosition(position.latitude, position.longitude);
        refresh();
      });

    } catch(error) {
      print('Error en la localizacion: $error');
    }
  }

  void centerPosition() {
    if (position != null) {
      animateCameraToPosition(position.latitude, position.longitude);
    }
    else {
      utils.Snackbar.showSnackbar(context, key, 'Activa el GPS para obtener la posicion');
    }
  }

  void checkGPS() async {
    bool isLocationEnabled = await Geolocator.isLocationServiceEnabled();
    if (isLocationEnabled) {
      print('GPS ACTIVADO');
      updateLocation();
    }
    else {
      print('GPS DESACTIVADO');
      bool locationGPS = await location.Location().requestService();
      if (locationGPS) {
        updateLocation();
        print('ACTIVO EL GPS');
      }
    }

  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permantly denied, we cannot request permissions.');
    }

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        return Future.error(
            'Location permissions are denied (actual value: $permission).');
      }
    }

    return await Geolocator.getCurrentPosition();
  }

  Future animateCameraToPosition(double latitude, double longitude) async {
    GoogleMapController controller = await _mapController.future;
    if (controller != null) {
      controller.animateCamera(CameraUpdate.newCameraPosition(
          CameraPosition(
              bearing: 0,
              target: LatLng(latitude, longitude),
              zoom: 17
          )
      ));
    }
  }

  Future<BitmapDescriptor> createMarkerImageFromAsset(String path) async {
    ImageConfiguration configuration = ImageConfiguration();
    BitmapDescriptor bitmapDescriptor =
    await BitmapDescriptor.fromAssetImage(configuration, path);
    return bitmapDescriptor;
  }

  void addMarker(
      String markerId,
      double lat,
      double lng,
      String title,
      String content,
      BitmapDescriptor iconMarker
      ) {

    MarkerId id = MarkerId(markerId);
    Marker marker = Marker(
        markerId: id,
        icon: iconMarker,
        position: LatLng(lat, lng),
        infoWindow: InfoWindow(title: title, snippet: content),
        draggable: false,
        zIndex: 2,
        flat: true,
        anchor: Offset(0.5, 0.5),
        rotation: position.heading
    );

    markers[id] = marker;

  }


}