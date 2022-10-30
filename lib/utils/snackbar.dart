import 'package:flutter/material.dart';
import 'package:wegocol/utils/colors.dart' as utils;

class Snackbar {

  static void showSnackbar(BuildContext context, GlobalKey<ScaffoldState> key, String text) {
    if (context == null) return;
    if (key == null) return;
    if (key.currentState == null) return;


    FocusScope.of(context).requestFocus(new FocusNode());

    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(new SnackBar(
      content: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Color.fromARGB(255, 255, 255, 255),
          fontSize: 14
        ),
      ),
      backgroundColor: utils.Colors.vinowego,
      duration: Duration(seconds: 3)
    ));

  }

}