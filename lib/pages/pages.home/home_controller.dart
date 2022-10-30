import 'package:flutter/material.dart';
import 'package:wegocol/providers/auth_providers.dart';
import 'package:wegocol/utils/shared_pref.dart';

class HomeController {
  BuildContext context;
  SharedPref _sharedPref;
  AuthProvider _authProvider;
  String _typeUser;

  Future init(BuildContext context) async{
    this.context = context;
    _sharedPref = new SharedPref();
    _authProvider=new AuthProvider();
    _typeUser = await _sharedPref.read('typeUser');
    _authProvider.checkIfUserIsLogged(context,_typeUser);
  }

  void goToLoginPage(String typeUser) {
    saveTypeUser(typeUser);
    Navigator.pushNamed(context, 'login');
  }
  void saveTypeUser(String typeUser) async {
    await _sharedPref.save('typeUser', typeUser);
  }
}