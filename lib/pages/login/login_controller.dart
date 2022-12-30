import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:wegocol/models/driver.dart';
import 'package:wegocol/models/client.dart';
import 'package:wegocol/providers/auth_providers.dart';
import 'package:wegocol/providers/driver_provider.dart';
import 'package:wegocol/utils/my_progres_dialog.dart';
import 'package:wegocol/utils/shared_pref.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:wegocol/providers/client_provider.dart';
import 'package:wegocol/utils/snackbar.dart' as utils ;


class LoginController {

  BuildContext context;
  GlobalKey<ScaffoldState> key = new GlobalKey<ScaffoldState>();

  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();

  AuthProvider _authProvider;
  ProgressDialog _progressDialog;
  DriverProvider _driverProvider;
  ClientProvider _clientProvider;
  String token;
  String email;
  String password;
  Future<bool> reg;


  SharedPref _sharedPref;
  String _typeUser;

  Future init(BuildContext context) async {
    this.context = context;
    _authProvider = new AuthProvider();
    _driverProvider = new DriverProvider();
    _clientProvider = new ClientProvider();
    _progressDialog =
        MyProgressDialog.createProgressDialog(context, 'Espere un momento...');
    _sharedPref = new SharedPref();
    _typeUser = await _sharedPref.read('typeUser');

    print('============== TIPO DE USUARIO===============');
    print(_typeUser);
  }


  void login() async {
    email = emailController.text.trim();
    password = passwordController.text.trim();
    await _sharedPref.save('correo', email);

    print('Email: $email');
    print('Password: $password');

    _progressDialog.show();
    await _authProvider.dataClient(email);
    if (_authProvider.isActive==false){
      utils.Snackbar.showSnackbar(
          context, key, 'El usuario no esta activado aun');
      return;
    }
    try{
      bool isLogin = await _authProvider.login(email, password);
      _progressDialog.hide();
      if(isLogin){
        print('se loguio');
        if (_typeUser == 'client'){
          if (_authProvider.isDriver==false){
            print('entro el cliente y isdriver es : ${_authProvider.isDriver}');
            Navigator.pushNamedAndRemoveUntil(context, 'client/map', (route) => false);
          }
          else{
            print('no es cliente el isdriver es: ${_authProvider.isDriver}');
            utils.Snackbar.showSnackbar(
                context, key, 'El usuario no es valido');
            await _authProvider.signOut();
          }
        }
        else if(_typeUser == 'driver'){
          print('else conductor');
          if (_authProvider.isDriver==true){
            print('entro el conductor y isdriver es : ${_authProvider.isDriver}');
            Navigator.pushNamedAndRemoveUntil(context, 'driver/map', (route) => false);
          }
          else{
            print('no es driver el isdriver es: ${_authProvider.isDriver}');
            utils.Snackbar.showSnackbar(
                context, key, 'El usuario no es valido');
            await _authProvider.signOut();
          }
        }
        else{
          print('usuario no valido');
        }
      }
      else {
        utils.Snackbar.showSnackbar(context, key, 'El usuario no se pudo autenticar');
        print('El usuario no se pudo autenticar');
      }
    }catch(e){
      utils.Snackbar.showSnackbar(context, key, 'Error: $e');
      _progressDialog.hide();
      print('Error: $e');

    }
  }
}