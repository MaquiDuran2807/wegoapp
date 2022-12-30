import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'package:lottie/lottie.dart';
import 'package:wegocol/pages/client/serveces/clientRequestController.dart';

import 'package:wegocol/pages/driver/serveces/takeServecesController.dart';

class ClientTravelRequestPage extends StatefulWidget {
  @override
  _ClientTravelRequestPageState createState() => _ClientTravelRequestPageState();
}

class _ClientTravelRequestPageState extends State<ClientTravelRequestPage> {

  ClientTravelRequestController _con = new ClientTravelRequestController();
  String img;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      _con.init(context, refresh);
      refresh();
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _con.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      key: _con.key,
      body: SingleChildScrollView(
        child: Column(
          children: [
            _driverInfo(),
            _lottieAnimation(),
            SizedBox(height: 10,),
            Text('Califica el Servicio'),
            SizedBox(height: 0,),
            Row(
              children: [
                SizedBox(width: 35,),
                calificationB(1),
                calificationB(2),
                calificationB(3),
                calificationB(4),
                calificationB(5),
              ],
            ),
            textFieldComent(),
            SizedBox(height: 6,),
            _texttel(),
            SizedBox(height: 6,),
            _textPrice()
          ],
        ),
      ),
      bottomNavigationBar: _buttonCancel(),
    );
  }

  Widget _buttonCancel() {
    return Container(

        height: 50,
        margin: EdgeInsets.all(30),
        child: ElevatedButton(
          style: ButtonStyle(backgroundColor: MaterialStateColor.resolveWith((states) => Colors.redAccent) ),
          onPressed: () {
            _con.cancelServices();
            Navigator.pushNamedAndRemoveUntil(
                context, 'client/map', (route) => false);
          },
          child: Row(
            children: [
              Text('Cancelar')
            ],
          ),
        )
    );
  }

  Widget _textPrice() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.attach_money),
          Text(
            '${_con.precio}',
            style: TextStyle(fontSize: 30),
          ),
        ],
      ),
    );
  }
  Widget textFieldComent(){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30),

      child:TextField(
        controller: _con.comentController,
        keyboardType: TextInputType.emailAddress,
        style: TextStyle(color: Colors.white),


        decoration: InputDecoration(
          suffixIcon:Icon(
            Icons.mail_outline_outlined,
            color: Colors.white,
          ),
          hintText: 'comentario',
          hintStyle: TextStyle(color: Colors.black),
          label: Text('Comentario'),
          labelStyle: TextStyle(color: Colors.black,fontSize: 20),


        ),
      ),

    );
  }


  Widget _lottieAnimation() {
    return Lottie.asset(
        'assets/json/car-control.json',
        width: MediaQuery
            .of(context)
            .size
            .width * 0.70,
        height: MediaQuery
            .of(context)
            .size
            .height * 0.35,
        fit: BoxFit.fill
    );
  }

  Widget _texttel() {
    return Container(
      child: TextButton(
        onPressed: (){
          _con.lanzarTel();

        },
        child: Text(
          'Escribe a tu conductor',
          style: TextStyle(
              fontSize: 16
          ),
        ),
      ),
    );
  }

  Widget _driverInfo() {
    refresh();
    return ClipPath(

      child: Container(
        height: MediaQuery
            .of(context)
            .size
            .height * 0.3,
        color: Colors.black,
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage(
                  'https://wegoapli.azurewebsites.net/media/${_con.imagen}'),
            ),

            Container(
              margin: EdgeInsets.symmetric(vertical: 10),
              child: Text(
                '${_con.name??''} ${_con.lastname??''}',
                maxLines: 1,
                style: TextStyle(
                    fontSize: 18,
                    color: Colors.white
                ),
              ),
            ),
            
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.star_rate,color: Colors.yellow,),
                Text('${_con.calificacion}',style: TextStyle(
                    fontSize: 18,
                    color: Colors.white
                ),),
              ],
            )
          ],
        ),
      ),
    );
  }



  Widget calificationB(value){
    return Container(
      child: Row(
        children: [
          TextButton(onPressed: (){
            print(value);
          }, child: Icon(Icons.star_rate_sharp,color: Colors.orange,))

        ],
      ),
    );
  }

  void refresh() {
    setState(() {
      img=_con.imagen;
    });
  }
}