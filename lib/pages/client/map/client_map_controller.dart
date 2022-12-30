
import 'dart:async';
import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoder2/geocoder2.dart';
import 'package:google_maps_webservice_ex/places.dart' as places;
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart'as location;
import 'package:flutter_google_places_ex/flutter_google_places_ex.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:provider/provider.dart';
import 'package:wegocol/models/Prices.dart';
import 'package:wegocol/models/directions.dart';
import 'package:wegocol/models/pcarreras.dart';
import 'package:wegocol/providers/auth_providers.dart';
import 'package:wegocol/providers/socket.dart';
import 'package:wegocol/utils/shared_pref.dart';
import 'package:wegocol/utils/snackbar.dart' as utils ;
import 'package:wegocol/models/client.dart';
import 'package:geolocator_android/geolocator_android.dart';
import 'package:geolocator_apple/geolocator_apple.dart';
import 'package:wegocol/providers/google_privider.dart';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;


class ClientMapController {
  BuildContext context;
  Function refresh;
  GlobalKey<ScaffoldState> key = new GlobalKey<ScaffoldState>();
  Completer<GoogleMapController> _mapController = Completer();
  var dio=Dio();

  CameraPosition initialPosition = CameraPosition(
      target: LatLng(4.4320347, -75.2247254),
      zoom: 14.0
  );
  var menucarrera='no';
  double Prices;

  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  GoogleProvider _googleProvider;

  Position _position;
  StreamSubscription<Position> _positionStream;

  BitmapDescriptor markerDriver;


  AuthProvider _authProvider;
 // DriverProvider _driverProvider;
  //ClientProvider _clientProvider;
  //PushNotificationsProvider _pushNotificationsProvider;
  final apiKeygoogle='AIzaSyBJ975dnNWGfw6tl2-u6YCSnnNBgNBJ1e8';
  bool isConnect = false;
  ProgressDialog _progressDialog;

  Set<Polyline> polylines = {};
  List<LatLng> points = [];

  BitmapDescriptor fromMarker;
  BitmapDescriptor toMarker;
  int id;
  String name;
  String lastname;
  String imagen;
  bool isActive;
  double calificacion;
  int viajes;
  int saldo;
  double pporkm;
  double ppormin;
  double pmin;
  int preciofinal;
  Direction _directions;
  String min;
  String km;

  double minTotal;
  double maxTotal;
  double kmValue ;
  double minValue ;
  String token;
  bool carrera=false;
  bool take=false;
  String llave;
  DateTime horap;
  Client client;

  String from;
  LatLng fromLatLng;

  String to;
  LatLng toLatLng;
  String tokenN;
  bool isFromSelected = true;
  SharedPref _sharedPref;
  String correo;

  places.GoogleMapsPlaces _places = places.GoogleMapsPlaces(apiKey:"AIzaSyBJ975dnNWGfw6tl2-u6YCSnnNBgNBJ1e8");


  ///arranca el init ====================================================
  ///
  Future init(BuildContext context, Function refresh) async {
    this.context = context;
    this.refresh = refresh;
    checkGPS();
    getPrices();
    _googleProvider = new GoogleProvider();
    _authProvider = new AuthProvider();
    _sharedPref = new SharedPref();
    markerDriver = await createMarkerImageFromAsset('assets/img/grey_car.png');
    correo = await _sharedPref.read('correo');
    print('paso?===============================================================================================');
    await data();
    saveToken();


  }

  ///arrancan los metodos para controller ================================

  void openDrawer() {
    key.currentState.openDrawer();
  }
  void saveToken() async{
    token=_authProvider.getUser().uid;
    tokenN = await FirebaseMessaging.instance.getToken();
    print('llego a guardar el token de notificacion       $tokenN===============================================================================');
    dynamic data={"id":id ,"tokenN":tokenN};
    dio.post('https://wegoapli.azurewebsites.net/clients/clientnotifica',data: data);
  }
  void data()async{
    print('este es el datta===================================================================================================');
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

  }


  void signOut() async {
    await _authProvider.signOut();
    Navigator.pushReplacementNamed(context, 'home');
  }

  void onMapCreated(GoogleMapController controller) {
    controller.setMapStyle('[{"elementType":"geometry","stylers":[{"color":"#212121"}]},{"elementType":"labels.icon","stylers":[{"visibility":"off"}]},{"elementType":"labels.text.fill","stylers":[{"color":"#757575"}]},{"elementType":"labels.text.stroke","stylers":[{"color":"#212121"}]},{"featureType":"administrative","elementType":"geometry","stylers":[{"color":"#757575"}]},{"featureType":"administrative.country","elementType":"labels.text.fill","stylers":[{"color":"#9e9e9e"}]},{"featureType":"administrative.land_parcel","stylers":[{"visibility":"off"}]},{"featureType":"administrative.locality","elementType":"labels.text.fill","stylers":[{"color":"#bdbdbd"}]},{"featureType":"poi","elementType":"labels.text.fill","stylers":[{"color":"#757575"}]},{"featureType":"poi.park","elementType":"geometry","stylers":[{"color":"#181818"}]},{"featureType":"poi.park","elementType":"labels.text.fill","stylers":[{"color":"#616161"}]},{"featureType":"poi.park","elementType":"labels.text.stroke","stylers":[{"color":"#1b1b1b"}]},{"featureType":"road","elementType":"geometry.fill","stylers":[{"color":"#2c2c2c"}]},{"featureType":"road","elementType":"labels.text.fill","stylers":[{"color":"#8a8a8a"}]},{"featureType":"road.arterial","elementType":"geometry","stylers":[{"color":"#373737"}]},{"featureType":"road.highway","elementType":"geometry","stylers":[{"color":"#3c3c3c"}]},{"featureType":"road.highway.controlled_access","elementType":"geometry","stylers":[{"color":"#4e4e4e"}]},{"featureType":"road.local","elementType":"labels.text.fill","stylers":[{"color":"#616161"}]},{"featureType":"transit","elementType":"labels.text.fill","stylers":[{"color":"#757575"}]},{"featureType":"water","elementType":"geometry","stylers":[{"color":"#000000"}]},{"featureType":"water","elementType":"labels.text.fill","stylers":[{"color":"#3d3d3d"}]}]');
    _mapController.complete(controller);
  }

  void updateLocation() async  {
    print('===========================================================es el update');
    try {
      await _determinePosition();
      print('=================================================== este es el geolocator del updatae');
      _position = await Geolocator.getLastKnownPosition();
      print('position $_position');// UNA VEZ

      centerPosition();


    } catch(error) {
      print('Error en la localizacion: $error');
    }
  }
  void cancelrequest(){
    print('cancelar pues');
    menucarrera='no';
    take=false;
    refresh;
    utils.Snackbar.showSnackbar(context, key, 'elija de nuevo su destino');
  }

 void requestDriver()async{
    if (carrera){
      goToRequest();
      return;
    }
    if (fromLatLng != null && toLatLng != null) {
      setPolylines();
      await getGoogleMapsDirections(fromLatLng,toLatLng);

      print(token);
     menucarrera='si';
     refresh;
    }
    else {
      utils.Snackbar.showSnackbar(context, key, 'Seleccionar el lugar de recogida y destino');
    }
  }
  void dispose() {
    _positionStream?.cancel();

  }
  void calculatePrice() async {
    print('entro a calcular km vale $km');
    //Prices prices = await _pricesProvider.getAll();
    kmValue = double.parse(km.split(" ")[0]) * pporkm;
    minValue = double.parse(min.split(" ")[0]) * ppormin;
    double total = kmValue + minValue+pmin;
    print('estamos calculando el precio $kmValue y $minValue');

    minTotal = total - 0.5;
    maxTotal = (total + 0.5);
    preciofinal=maxTotal.round();
    print("este es el precio $minTotal");

    refresh();
  }

   void getPrices()async{
     var response = await dio.get('https://wegoapli.azurewebsites.net/carreras/price', );
     print('tomo los precios : ${response.data}');
     pporkm=response.data["precios"][0]["ppkm"];
     ppormin=response.data["precios"][0]["ppm"];
     pmin=response.data["precios"][0]["pm"];
     print('este es el precio por km $pporkm este eñ min $ppormin y este el minimo $pmin');
  }
  void goToRequest() async{
    if(carrera==false){
      return;
    }
    else if(take){
      Navigator.pushNamed(context, 'client/serveces');
    }else{
      final socketService =Provider.of<SocketService>(context,listen: false );
      socketService.socket.emit('mensaje',{'nombre':'carrera!!!'});

      final data={"cliente_id": token,"coordenadas": {"recogida":{"lat": _position.latitude,  "lng":  _position.longitude,"direccion":from},"destino":{"lat": toLatLng.latitude, "lng": toLatLng.longitude,"direccion":to}},"viaje":{"distancia":km,"precio":preciofinal,"testimado":min}};
      print(data);
      dio.options.connectTimeout=5000;
      dio.options.receiveTimeout=3000;
      dio.options.headers={'Content-Type': 'application/json',
        'Connection': 'keep-alive'
      };
      try {
        var response = await dio.post('https://wegoapli.azurewebsites.net/carreras/', data: data,);
        print(response.data.toString());
        var carre=Pcarreras.fromMap(response.data);
        llave=carre.consultar.toString();
        horap=carre.horaPeticion;
      }catch(error,stackTrace){
        print('el error es $error , el stackTrace es $stackTrace');
      }

      take=true;
      Navigator.pushNamed(context, 'client/serveces',arguments: {
        "llave":llave,
        "horap":horap,
        "precio":preciofinal,
        "id":id

      });
      print('llego hata aquiu');
      print('esta es una instancia del socket para llamar carreras $socketService');
    }
  }


  void onError(places.PlacesAutocompleteResponse response) {
    print(response.errorMessage);
  }

  Future<Null> showGoogleAutoComplete(bool isFrom) async {

    places.Prediction p = await PlacesAutocomplete.show(
        context: context,
        apiKey:apiKeygoogle ,
        mode: Mode.overlay,
        language: 'es',
        strictbounds: true,
        radius: 50000,
        location: places.Location(lat: 4.4389662,lng: -75.2277724)

    );
    print(p.description);

    if (p != null) {
      places.PlacesDetailsResponse detail =
      await _places.getDetailsByPlaceId(p.placeId, language: 'es');
      double lat = detail.result.geometry.location.lat;
      double lng = detail.result.geometry.location.lng;
      GeoData address = await Geocoder2.getDataFromAddress(address: p.description, googleMapApiKey: apiKeygoogle);
      if (address != null) {
        if (address.city.length > 0) {
          if (detail != null) {
            String direction = detail.result.name;
            String city = address.city;
            String department = address.state;

            if (isFrom) {
              from = '$direction, $city, $department';
              fromLatLng = new LatLng(lat, lng);
            }
            else {
              to = '$direction, $city, $department';
              toLatLng = new LatLng(lat, lng);
            }

            refresh();
          }
        }
      }


    }
  }
  Future<void> setPolylines() async {
    points=[];
    print("entro a poli");
    PointLatLng pointFromLatLng = PointLatLng(fromLatLng.latitude, fromLatLng.longitude);
    PointLatLng pointToLatLng = PointLatLng(toLatLng.latitude, toLatLng.longitude);
    print("estos som los polilines que hay ========$pointToLatLng y $pointFromLatLng");
    PolylineResult result = await PolylinePoints().getRouteBetweenCoordinates(
        apiKeygoogle,
        pointFromLatLng,
        pointToLatLng
    );

    for (PointLatLng point in result.points) {
      points.add(LatLng(point.latitude, point.longitude));
    }

    Polyline polyline = Polyline(
        polylineId: PolylineId('poly'),
        color: Colors.amber,
        points: points,
        width: 6
    );
    print('añadir a polilines');

    polylines.add(polyline);
    addMarker(
        'recogida',
        fromLatLng.latitude,
        fromLatLng.longitude,
        'Conductor disponible',
        'yo',
        markerDriver
    );
    addMarker(
        'llegada',
        toLatLng.latitude,
        toLatLng.longitude,
        'llegada',
        'yo',
        markerDriver
    );

    refresh();
    print('desppues del refresh');
  }




  void changeFromTO() {
    isFromSelected = !isFromSelected;

    if (isFromSelected) {
      utils.Snackbar.showSnackbar(context, key, 'Estas seleccionando el lugar de recogida');
    }
    else {
      utils.Snackbar.showSnackbar(context, key, 'Estas seleccionando el destino');
    }

  }
  Future<Null> setLocationDraggableInfo() async {
    if (initialPosition != null) {
      double lat = initialPosition.target.latitude;
      double lng = initialPosition.target.longitude;

      List<Placemark> address = await placemarkFromCoordinates(lat, lng);

      if (address != null) {
        if (address.length > 0) {
          String direction = address[0].thoroughfare;
          String street = address[0].subThoroughfare;
          String city = address[0].locality;
          String department = address[0].administrativeArea;
          String country = address[0].country;

          if (isFromSelected) {
            from = '$direction #$street, $city, $department';
            fromLatLng = new LatLng(lat, lng);
          }
          else {
            to = '$direction #$street, $city, $department';
            toLatLng = new LatLng(lat, lng);
          }

          refresh();
        }
      }
    }
  }

  void goToEditPage() {
    Navigator.pushNamed(context, 'client/edit');
  }

  void goToHistoryPage() {
    Navigator.pushNamed(context, 'client/history');
  }

  void getGoogleMapsDirections(LatLng from, LatLng to) async {
    _directions = await _googleProvider.getGoogleMapsDirections(
        from.latitude,
        from.longitude,
        to.latitude,
        to.longitude
    );
    min = _directions.duration.text;
    km = _directions.distance.text;

    print('KM: $km');
    print('MIN: $min');
    calculatePrice();
    refresh();
  }





  /*
   void calculatePrice() async {
    Prices prices = await _pricesProvider.getAll();
    double kmValue = double.parse(km.split(" ")[0]) * prices.km;
    double minValue = double.parse(min.split(" ")[0]) * prices.min;
    double total = kmValue + minValue;

    minTotal = total - 0.5;
    maxTotal = total + 0.5;

    refresh();
  }



  void getNearbyDrivers() {
    Stream<List<DocumentSnapshot>> stream =
    _geofireProvider.getNearbyDrivers(_position.latitude, _position.longitude, 50);

    stream.listen((List<DocumentSnapshot> documentList) {

      for (DocumentSnapshot d in documentList) {
        print('DOCUMENT: $d');
      }

      for (MarkerId m in markers.keys) {
        bool remove = true;

        for (DocumentSnapshot d in documentList) {
          if (m.value == d.id) {
            remove = false;
          }
        }

        if (remove) {
          markers.remove(m);
          refresh();
        }

      }

      for (DocumentSnapshot d in documentList) {
        GeoPoint point = d.data()['position']['geopoint'];
        addMarker(
            d.id,
            point.latitude,
            point.longitude,
            'Conductor disponible',
            d.id,
            markerDriver
        );
      }

      refresh();

    });
  }*/

  void centerPosition() {
    if (_position != null) {
      animateCameraToPosition(_position.latitude, _position.longitude);
    }
    else {
      utils.Snackbar.showSnackbar(context, key, 'Activa el GPS para obtener la posicion');
    }
  }

  void checkGPS() async {
    print('==================================================es el check gps');
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
    print('es el determinate position =========================================================');
    bool serviceEnabled;
    LocationPermission permission;


    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    print('es el sevice enable $serviceEnabled ==========================');
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
    print('vamos pal get current========================================');
    return await Geolocator.getCurrentPosition();
  }

  Future animateCameraToPosition(double latitude, double longitude) async {
    GoogleMapController controller = await _mapController.future;
    if (controller != null) {
      controller.animateCamera(CameraUpdate.newCameraPosition(
          CameraPosition(
              bearing: 0,
              target: LatLng(latitude, longitude),
              zoom: 14
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
        rotation: _position.heading
    );

    markers[id] = marker;

  }

}