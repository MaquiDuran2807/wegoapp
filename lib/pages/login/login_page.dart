import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:wegocol/pages/login/login_controller.dart';
import 'package:wegocol/utils/Colors.dart' as util;

class LoginPage extends StatefulWidget {


  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  LoginController _con=new LoginController();
  @override
  void initState(){
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      _con.init(context);
    });
  }
  Widget build(BuildContext context) {
    return Scaffold(
      key:_con.key ,
      body:SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/img/manejador.jpeg'),
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.85),BlendMode.darken )
              )
          ),
          child: SafeArea(

            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(height: 50,),
            Image.asset(
              'assets/img/logoblanco.png',
              width: 150,
              height: 100,
              ),
              Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 20,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        textBienvenido(),
                        textVenido(),

                      ],
                    ),
                    SizedBox(height: 50,),
                    textFieldEmail(),
                    SizedBox(height: 20,),
                    textFieldPassword(),
                    SizedBox(height: 20,),
                    botonSubmit(),
                    SizedBox(height: 20,),
                    textbuttonForgotPassword('¿Olvidaste Tu Contraseña?'),
                    SizedBox(height: 20,),
                    textbuttonRegister("registrarse"),
                    SizedBox(height:MediaQuery.of(context).size.height*0.32,)
                  ],
                ),
              )
            ],
          ),
        ),
    ),
      ),
    );



  }
  Widget textbuttonRegister(text){
    return TextButton(onPressed: (){
      Navigator.pushNamed(context, 'register');
    },
        child:Text(text,style: TextStyle(
            color: Colors.white,
            fontSize: 15
        ),)
    );
  }

  Widget textbuttonForgotPassword(text){
    return TextButton(onPressed: (){},
        child:Text(text,style: TextStyle(
          color: Colors.white,
          fontSize: 15
        ),)
    );
  }
  Widget botonSubmit(){
    final elevatedButtonStyle=ElevatedButton.styleFrom(
      primary: util.Colors.orowego
    );
    return ElevatedButton(
        onPressed: () {
          _con.login();

        },
        child: Text('iniciar sesion',style:TextStyle(
          color: util.Colors.vinowego
        ),),
      style: elevatedButtonStyle

    );

  }

  Widget textFieldPassword() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30),

      child: TextField(
        controller: _con.passwordController,
        keyboardType: TextInputType.visiblePassword,
        style: TextStyle(color: Colors.white),
        obscureText: true,
        decoration: InputDecoration(
          suffixIcon: Icon(
            Icons.lock_open_outlined,
            color: Colors.white,
          ),
          hintText: 'contraseña',
          hintStyle: TextStyle(color: Colors.white),
          label: Text('contraseña'),
          labelStyle: TextStyle(color: Colors.white,fontSize: 20),



        ),
      ),

    );
  }
  Widget textFieldEmail(){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30),

      child:TextField(
        controller: _con.emailController,
        keyboardType: TextInputType.emailAddress,
        style: TextStyle(color: Colors.white),


        decoration: InputDecoration(
          suffixIcon:Icon(
            Icons.mail_outline_outlined,
            color: Colors.white,
          ),
          hintText: 'correo@gmail.com',
          hintStyle: TextStyle(color: Colors.white),
          label: Text('correo'),
          labelStyle: TextStyle(color: Colors.white,fontSize: 20),


        ),
      ),

    );
  }
  Widget textVenido(){
    return Container(

      child: Row(
        children: [
          Text('venido',
              style: TextStyle(
                fontSize: 30,
                color: util.Colors.vinowego,
              )
          ),
        ],
      ),
    );
  }
  Widget textBienvenido(){
    return  Container(
    alignment: Alignment.center,
    child: Center(
    child: Row(
    children: [
    Text('Bien',
    style: TextStyle(
    fontSize: 30,
    color: util.Colors.orowego,
    ),
    ),
    ],
    ),
    ),
    );
  }



}
