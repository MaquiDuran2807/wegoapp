import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'package:lottie/lottie.dart';

import 'package:wegocol/pages/driver/serveces/takeServecesController.dart';

class DriverTravelRequestPage extends StatefulWidget {
  @override
  _DriverTravelRequestPageState createState() => _DriverTravelRequestPageState();
}

class _DriverTravelRequestPageState extends State<DriverTravelRequestPage> {

  DriverTravelRequestController _con = new DriverTravelRequestController();

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
      body: WillPopScope(
        onWillPop: _onwil,
        child: SingleChildScrollView(
          child: Column(
            children: [
              _driverInfo(),
              _lottieAnimation(),
              botonesirClient(),
              botonto(),
              _textLookingFor(),
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
              _textCounter(),
            ],

          ),
        ),
      ),
      bottomNavigationBar: _buttonCancel(),
    );
  }

  Widget _buttonCancel() {
    return Container(

        height: 50,
        //margin: (30),
        child: ElevatedButton(
          style: ButtonStyle(backgroundColor: MaterialStateColor.resolveWith((states) => Colors.redAccent) ),
          onPressed: () {
            _con.cancelServices();
            Navigator.pushNamedAndRemoveUntil(
                context, 'driver/map', (route) => false);

          },
          child: Row(
            children: [
              Text('Cancelar')
            ],
          ),
        )
    );
  }

  Widget _textCounter() {
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

  Widget _lottieAnimation() {
    return Lottie.asset(
        'assets/json/car-control.json',
        width: MediaQuery
            .of(context)
            .size
            .width * 0.60,
        height: MediaQuery
            .of(context)
            .size
            .height * 0.30,
        fit: BoxFit.fill
    );
  }

  Widget _textLookingFor() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30),
      child: Column(

        children: [
          SizedBox(height: 10,),
          Text(
            'recorrido ${_con.distancia} en un tiempo estimado de ${_con.testimado} ',
            style: TextStyle(
                fontSize: 16
            ),
          ),
          TextButton(onPressed: (){
            _con.lanzarTel();
          }, child: Text('enviar mensaje ${_con.tel}'))
        ],
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
            .height * 0.25,
        color: Colors.black,
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 25,),
            CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage(
                  'https://wegoapli.azurewebsites.net/media/${_con.imagen}'),
            ),

            Container(
              margin: EdgeInsets.symmetric(vertical: 10),
              child: Text(
                '${_con.name} ${_con.lastname}',
                maxLines: 1,
                style: TextStyle(
                    fontSize: 18,
                    color: Colors.white
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget botonesirClient() {
    return Container(
        decoration: BoxDecoration(
            color: Colors.orange,
            borderRadius: BorderRadius.circular(10)
        ),
        height: 50,
        width: MediaQuery
            .of(context)
            .size
            .width * 0.8,
        child: ElevatedButton(
          style: ButtonStyle(backgroundColor: MaterialStateColor.resolveWith((states) => Colors.orange) ),
          onPressed: () {
            _con.navegarClient();
          },
          child: Container(

            child: Row(
                children: [
                  Expanded(child: Text('Navegar Al Cliente en ${_con.from} '))
                ]

            ),
          ),

        )
    );
  }

  Widget botonto() {
    return Container(
      decoration: BoxDecoration(
          color: Colors.orange,
          borderRadius: BorderRadius.circular(10)
      ),
      height: 50,
      width: MediaQuery
          .of(context)
          .size
          .width * 0.8,
      child: ElevatedButton(
        style: ButtonStyle(backgroundColor: MaterialStateColor.resolveWith((states) => Color.fromRGBO(100, 10, 6, 1)) ),
        onPressed: () {
          _con.navegarDestino();
        },
        child: Row(
                children: [
                  Expanded(child: Text('Navegar Al Destino ${_con.to} '))
                ],
              ),
          ),
        );
  }
  Widget textFieldComent(){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30),

      child:TextField(
        controller: _con.comentController,
        keyboardType: TextInputType.text,
        style: TextStyle(color: Colors.black),


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
  Widget calificationB(value){
    return Container(
      child: Row(
        children: [
          TextButton(onPressed: (){
            _con.calificationAndFinich(value);
            print(value);
          }, child: Icon(Icons.star_rate_sharp,color: Colors.orange,))

        ],
      ),
    );
  }

  void refresh() {
    setState(() {});
  }

  Future<bool> _onwil() {
    return  showDialog(
        context: context,
        builder: (BuildContext context){
      return AlertDialog(
        title: Text('¿Desea cancelar la carrera?'),
        content: Text('si sale de la aplicacion cancelará la carrera'),
        actions: [
          TextButton(onPressed: (){
            Navigator.pop(context);
          }, child: Text('volver')),
          TextButton(onPressed: (){
            _con.cancelServices();
          }, child: Text('Si,cancelar la carrera'))
        ],
      );}

    );
  }
}