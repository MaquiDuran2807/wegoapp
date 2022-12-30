import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:wegocol/models/client.dart';
import 'package:wegocol/providers/auth_providers.dart';
import 'package:wegocol/utils/my_progres_dialog.dart';
import 'package:wegocol/utils/snackbar.dart' as utils;

class ClientRegisterController {

  BuildContext context;
  GlobalKey<ScaffoldState> key = new GlobalKey<ScaffoldState>();

  ImagePicker picker = ImagePicker();
  File imageFile;

  TextEditingController usernameController = new TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController lastnameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController idController = TextEditingController();
  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  TextEditingController confirmPasswordController = new TextEditingController();
  Function refresh;


  AuthProvider _authProvider;

  ProgressDialog _progressDialog;
  String genero;

  Future init (BuildContext context,Function refresh) {
    this.context = context;
    this.refresh = refresh;
    _authProvider = new AuthProvider();
    _progressDialog = MyProgressDialog.createProgressDialog(context, 'Espere un momento...');
  }

  void register() async {

      String username = usernameController.text;
      String email = emailController.text.trim();
      String confirmPassword = confirmPasswordController.text.trim();
      String password = passwordController.text.trim();
      String name = nameController.text;
      String lastname = lastnameController.text;
      String telefono = phoneController.text;
      String identification = idController.text;
      print('entro a registrar');
      print('Email: $email');
      print('Password: $password');
      print('nam $name');
      print('lastname: $lastname');
      print('telefono: $telefono');
      print('identificacion: $identification');
      print('Password: $confirmPassword');


    if (username.isEmpty && email.isEmpty && password.isEmpty && confirmPassword.isEmpty && name.isEmpty && lastname.isEmpty && telefono.isEmpty && genero.isEmpty && identification.isEmpty ) {
      print('debes ingresar todos los campos');
      utils.Snackbar.showSnackbar(context, key, 'Debes ingresar todos los campos');
      return;
    }

    if (confirmPassword != password) {
      print('Las contraseñas no coinciden');
      utils.Snackbar.showSnackbar(context, key, 'Las contraseñas no coinciden');
      return;
    }

    if (password.length < 6) {
      print('el password debe tener al menos 6 caracteres');
      utils.Snackbar.showSnackbar(context, key, 'el password debe tener al menos 6 caracteres');
      return;
    }
    if (imageFile==null){
      utils.Snackbar.showSnackbar(context, key, 'la oto es requerida');
      return;
    }
    print('todo bien');



    _progressDialog.show();

    try {

      bool isRegister = await _authProvider.register(email, password);
      String token=_authProvider.getUser().uid;



      if (isRegister) {
        _authProvider.Clientapi(token,email,identification,name,lastname,genero,imageFile,telefono);

        Client client = new Client(
            id: _authProvider.getUser().uid,
            email: _authProvider.getUser().email,
            username: username,
            password: password
        );
       // _authProvider.Clientapi(client.id,email);

        Navigator.pushReplacementNamed(context, 'login');
        utils.Snackbar.showSnackbar(context, key, 'El usuario se registro correctamente');
        print('El usuario se registro correctamente en poco tiempo se notificara su activacion');
        _progressDialog.hide();

      }
      else {
        _progressDialog.hide();
        print('El usuario no se pudo registrar');
      }

    } catch(error) {
      _progressDialog.hide();
      utils.Snackbar.showSnackbar(context, key, 'Error: $error');
      print('Error: $error');
    }

  }
  Future selectImage(ImageSource imageSource) async {
    XFile image = await picker.pickImage(source: imageSource);
    if (image != null) {
      imageFile = File(image.path);
      refresh;
      utils.Snackbar.showSnackbar(context, key, 'imagen seleccionada');


      //update();
    }
  }


  void showAlertDialog(BuildContext context) {

    Widget galleryButton = ElevatedButton(
        onPressed: () {
          Navigator.pop(context);
          selectImage(ImageSource.gallery);
        },
        child: Text(
          'GALERIA',
          style: TextStyle(
              color: Colors.black
          ),
        )
    );
    Widget cameraButton = ElevatedButton(
        onPressed: () {
          Navigator.pop(context);
          selectImage(ImageSource.camera);

        },
        child: Text(
          'CAMARA',
          style: TextStyle(
              color: Colors.black
          ),
        )
    );

    AlertDialog alertDialog = AlertDialog(
      title: Text('Selecciona una opcion'),
      actions: [
        galleryButton,
        cameraButton
      ],
    );

    showDialog(context: context, builder: (BuildContext context) {
      return alertDialog;
    });
  }

}