import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:wegocol/models/token.dart';
import 'package:wegocol/models/userinfo.dart';
import 'package:wegocol/utils/shared_pref.dart';

class AuthProvider {
  BuildContext context;

  FirebaseAuth _firebaseAuth;

  bool isDriver;
  int id;
  String name;
  String lastname;
  String imagen;
  bool isActive;
  double calificacion;
  int viajes;
  int saldo;
  SharedPref _sharedPref;

  Future init(BuildContext context) async {
    this.context = context;
    _sharedPref = new SharedPref();
  }


  AuthProvider() {

    _firebaseAuth = FirebaseAuth.instance;
  }

  User getUser() {
    return _firebaseAuth.currentUser;
  }

  bool isSignedIn() {
    final currentUser = _firebaseAuth.currentUser;

    if (currentUser == null) {
      return false;
    }

    return true;
  }

  void checkIfUserIsLogged(BuildContext context, String typeUser) {
    FirebaseAuth.instance.authStateChanges().listen((User user) {
      // QUE EL USUARIO ESTA LOGEADO
      if (user != null && typeUser != null) {
        if (typeUser == 'client') {
          Navigator.pushReplacementNamed(
              context, 'client/map');
        }
        else {
          Navigator.pushReplacementNamed(
              context, 'driver/map');
        }
        print('El usuario esta logeado');
      }
      else {
        print('El usuario no esta logeado');
      }
    });
  }

  Future<bool> login(String email, String password) async {
    String errorMessage;

    try {
      await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
    } catch (error) {
      print(error);
      // CORREO INVALIDO
      // PASSWORD INCORRECTO
      // NO HAY CONEXION A INTERNET
      errorMessage = error.code;
    }

    if (errorMessage != null) {
      return Future.error(errorMessage);
    }

    return true;
  }

  Future<bool> register(String email, String password) async {
    String errorMessage;

    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
    } catch (error) {
      print(error);
      // CORREO INVALIDO
      // PASSWORD INCORRECTO
      // NO HAY CONEXION A INTERNET
      errorMessage = error.code;
    }

    if (errorMessage != null) {
      return Future.error(errorMessage);
    }

    return true;
  }

  Future<void> signOut() async {
    return Future.wait([_firebaseAuth.signOut()]);
  }
  void dataClient(email)async{
    print('llego a tomar la data');
    var data={"correo":email};
    var response = await Dio().post('https://wegoapli.azurewebsites.net/clients/clientinfo',data: data);
    print('este es el dio :${response.statusCode}');
    print(response.data);
    isDriver=Clientinfo.fromMap(response.data).conductor;
    var ClientExist1=Clientinfo.fromMap(response.data).clients;

    print('este es el is client info $ClientExist1');
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
  void Clientapi(token,email,identification,name,lastname,genero,imagen,telefono)async {
    print('llego a la peticion');
    String filename = imagen.path
        .split('/')
        .last;
    FormData data = FormData.fromMap({
      "token": token,
      "correo": email,
      "identification": identification,
      "name": name,
      "lastname": lastname,
      "genero": genero,
      "telefono": telefono,
      "imagen": await MultipartFile.fromFile(imagen.path, filename: filename)
    });
    var response = await Dio().post(
        'https://wegoapli.azurewebsites.net/clients/3', data: data);
    print('este es el dio :${response.statusCode}');
    print(response.data);
  }

}