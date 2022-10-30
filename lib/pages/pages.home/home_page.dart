

import 'package:flutter/material.dart';
import 'package:wegocol/pages/pages.home/home_controller.dart';


class HomePage extends StatelessWidget {
  HomeController _con = new HomeController();

  @override
  Widget build(BuildContext context) {

    _con.init(context);// inicializar controlador
    return Scaffold(

      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/img/manejador.jpeg'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.85),BlendMode.darken )
          )
        ),
        child: SafeArea(

          child: Column(

            children: [
              Row(
                children: [
                  Image.asset(
                    'assets/img/logoblanco.png',
                    width: 150,
                    height: 100,
                  )
                ],
              ),
              SizedBox(height: 50,),
              Text('Hola, ¿cual es tu rol?',
              style: TextStyle(
                fontSize: 20,
                color: Colors.orange,

              ),
              ),
              SizedBox(height: 30,),

              _textTypeUser('pasajero'),
              SizedBox(height: 20,),
              _imageTypeUser(context,'assets/img/pasajero.png','client'),
              SizedBox(height: 30,),
              _textTypeUser('conductor'),
              SizedBox(height: 20,),
              _imageTypeUser(context,'assets/img/driver.png','driver')

            ],
          ),
        ),
      ),

    );
  }
  Widget _imageTypeUser(BuildContext context, String image,String typeUser){
    return GestureDetector(
      onTap: (){
        _con.goToLoginPage(typeUser);
      },
      child: CircleAvatar(
        backgroundImage: AssetImage(image),
        radius: 50,
        backgroundColor: Colors.grey[900],
      ),
    );
  }
  Widget _textTypeUser(String typeUser){
    return Text(typeUser,
        style: TextStyle(
        fontSize: 20,
        color: Colors.white
      ),
    );
  }
}
