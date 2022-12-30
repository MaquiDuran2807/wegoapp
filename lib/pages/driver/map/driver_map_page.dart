
import 'dart:async';
import 'dart:convert';

import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'package:wegocol/models/driverRealtime.dart';
import 'package:wegocol/pages/driver/map/driver_map_controller.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:wegocol/pages/driver/serveces/takeServeces.dart';
import 'package:wegocol/providers/socket.dart';


class DriverMapPage extends StatefulWidget {

  @override
  _DriverMapPageState  createState() => _DriverMapPageState();

}

class _DriverMapPageState extends State<DriverMapPage> {
  final DriverMapController _con = new DriverMapController();
  List <List<EstadoElement>> options=<List<EstadoElement>>[];

  Future <List<EstadoElement>>tomar_datos  ()async {
    print('es el tomar datos este es el token ${_con.token} ubicacion ${_con.position.latitude} y ${_con.position.longitude} en el post inicial');
    print("este es el option$options");
    //final Estado = [];
    print('hizo la peticion');
    var data={"token":_con.token,"ubicacion":{"lat":_con.position.latitude,  "lng":_con.position.longitude}};
    var response = await Dio().post('https://wegoapli.azurewebsites.net/carreras/drivers',data: data);
    print('este es el dio :${response.statusCode}');
    if (response.statusCode == 200) {
      print('este es el response${response.data}');
      var carreras1 =Estado.fromMap(response.data);
      var carreras2=carreras1.estado;

      print(" respuesta carreras2 ${carreras2}");
      options=[];

      options.addAll(carreras2);
      refresh();

    } else {
      throw Exception('fallo la conexion');
    }
  }
@override
  void initState() {
    // TODO: implement initState
  final socketService =Provider.of<SocketService>(context,listen: false );
  Timer.periodic(Duration(seconds: 2), (timer) {
    final socketService =Provider.of<SocketService>(context,listen: false );
    socketService.socket.on('mensaje', (payload) {
      tomar_datos();
      print('este es el payload $payload');
    });
  });

  socketService.socket.on('mensaje', (payload) {
    tomar_datos();
    print(payload);
  });

  super.initState();

    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      _con.init(context,refresh);
    });
    int cont=0;


    Timer.periodic(Duration(seconds: 2), (timer)  {
      print('este es el ${_con.token}');
      print('este es el token $_con.token ubicacion ${_con.position.latitude} y ${_con.position.longitude} en el post inicial');
      cont ++;
      if(cont==1){
        timer.cancel();
      }

      setState(() {
        tomar_datos  ();

      });
    });
    refresh();
  }



  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      key: _con.key,
      drawer: _drawer(),
      appBar: AppBar(
        title: Container(
            child: Row(
              children: [
                Text('WEGO'),
                TextButton(onPressed: tomar_datos, child: Text('refrescar'))
              ],
            )
        ),
        backgroundColor: Colors.black87,

      ),
      body: Container(
        decoration:BoxDecoration(
          color: Colors.black87
        ) ,
        child: Container(
          child: ListView.separated(

                itemCount: options.length,
                itemBuilder: (context,index)=>ListTile(
                  title: Container(
                    
                    width: size.width,
                    margin: EdgeInsets.symmetric(horizontal: 1,),
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(20),
                      color: Colors.orange
                      // colorFilter: ColorFilter.mode(Colors.orange.withOpacity(0.90),BlendMode.difference ),
                        /*image: DecorationImage(
                            //image: AssetImage('assets/img/llamas.png'),
                            image: AssetImage('assets/img/logoempresa.png'),
                            fit: BoxFit.fill,
                            //colorFilter: ColorFilter.mode(Colors.orange.withOpacity(0.10),BlendMode.difference )*/

                    ),

                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [

                            Column(
                              mainAxisSize: MainAxisSize.max,
                              children:[
                                SizedBox(height: 40,width: 90,
                                  child: Text(options[index][0].name,style: TextStyle(color: Colors.black,fontWeight: FontWeight.w700,),softWrap: true,maxLines: 2,textAlign: TextAlign.center,),
                                ),
                                CircleAvatar(backgroundImage: NetworkImage('https://wegoapli.azurewebsites.net/media/'+options[index][0].img),
                                radius: 35,
                              ),
                                SizedBox(height: 45,
                                  child: Expanded(
                                    child: Container(
                                      child: Row(
                                        children: [
                                          Icon(Icons.star),
                                          Text(options[index][0].calificacion.toString(),style: TextStyle(color: Colors.black),softWrap: true,maxLines: 2),
                                        ],
                                      ),
                                    ),
                                  )
                                ),
                  ]
                            ),

                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children:  [
                                    SizedBox(height: 41,
                                      child:Expanded(
                                        child: Container(
                                          child: Row(
                                            children: [
                                              Icon(Icons.person,color: Colors.black87,),
                                              Expanded(child: Text(options[index][0].coordenadas.recogida.direccion,style: TextStyle(color: Colors.black,fontSize: 12,fontFamily: ("MartianMono")),softWrap: true,maxLines: 2)),

                                            ],
                                          ),
                                        ),
                                      ) ,
                                    ),
                                SizedBox(height: 5,),
                                SizedBox(height: 51,
                                      width: size.width,
                                      child: Row(
                                        children: [
                                          Icon(Icons.golf_course,color: Colors.black87,),
                                          Expanded(
                                            child: Text(options[index][0].coordenadas.destino.direccion,style: TextStyle(
                                                color: Colors.black

                                            ),softWrap: true,maxLines: 2,),
                                          ),
                                        ]
                                  ),
                                ),

                                SizedBox(height: 30,
                                  child: Row(
                                    children: [
                                      Icon(Icons.attach_money,color: Colors.black87,),
                                      Text(options[index][0].viaje.precio.toString(),style: TextStyle(fontFamily: ("MartianMono")),),
                                      SizedBox(width: 20,),
                                      Icon(Icons.social_distance,color:Colors.black87 ,),
                                      Text(options[index][0].viaje.distancia,style: TextStyle(fontFamily: ("MartianMono")),),


                                    ],
                                  ),
                                ),



                                SizedBox(height:50,
                                  child: Row(
                                    children: [
                                      Icon(Icons.timer,color: Colors.black87,),
                                      Text(options[index][0].viaje.testimado,style: TextStyle(fontFamily: ("MartianMono")),),
                                      SizedBox(width: 10,),
                                      Expanded(child: Text('distancia al cliente ${(options[index][0].distanciaCliente).round().toString()}m'))
                                    ],
                                  ),
                                )
                                  ]
                                ),
                          ),
                          Column(
                            children: [
                              SizedBox(width: 20,height: 100,)
                            ],
                          )
                        ],
                      ),

                      ),
                  subtitle:Container(
                    decoration: BoxDecoration(

                        color: Color.fromRGBO(236, 175, 55, 0.5)),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [


                          ],
                        )
                      ],
                    ),
                  ) ,
                  onTap: (){
                    DateTime hora=options[index][0].horaPeticion;
                    var idCliente=options[index][0].id;
                    Navigator.of(context).popAndPushNamed( 'driver/serveces', arguments: {"imagen":options[index][0].img,
                    "recogidan":options[index][0].coordenadas.recogida.direccion,
                    "destino":options[index][0].coordenadas.destino.direccion,
                    "fromlat":options[index][0].coordenadas.recogida.lat,
                    "fromlng":options[index][0].coordenadas.recogida.lng,
                    "tolat":options[index][0].coordenadas.destino.lat,
                    "tolng":options[index][0].coordenadas.destino.lng,
                    "hora":hora,
                    'idCliente':idCliente,
                    'precio':options[index][0].viaje.precio,
                    'distancia':options[index][0].viaje.distancia,
                    'name':options[index][0].name,
                    'lastname':options[index][0].lastname,
                    'tiempoe':options[index][0].viaje.testimado,
                    'tel':options[index][0].tel,
                    'myId':_con.id,
                      'tokenN':options[index][0].tokenNotifi
                    });
                    showDialog(
                      context: context,
                      builder: (BuildContext context){
                      return AlertDialog(title: Text('¿desea tomar este servicio?'),
                      content:Container(
                        height: 60,
                        width: 60,
                        child: Column(
                          children: [
                            Row(
                              children: [
                                TextButton(onPressed: (){
                                  Navigator.pushNamedAndRemoveUntil(context, 'driver/map', (route) => false);
                                },
                                    child:Text('volver')
                                ),
                                SizedBox(width: 15,),
                                TextButton(onPressed: (){
                                  _con.takeServeces(hora, idCliente);
                                  Navigator.pop(context);

                                  /*showDialog(context: context,barrierDismissible: false, builder: (BuildContext context,){
                                    return AlertDialog(
                                      backgroundColor: Colors.black,
                                      title: Text("genial, vamos!",style: TextStyle(color: Colors.white),),
                                      */

                                },
                                    child:Text('tomar servicio')
                                )
                              ],
                            )
                          ],
                        ),
                      ),

                      );}
                    );


                    tomar_datos  ();

                  },
                ),
                separatorBuilder: (_,__)=>const Divider(height: 0,),
              ),
          ),
        ),
      );
    }
  Widget _drawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                SizedBox(height: 10),
                Row(
                  children: [
                    CircleAvatar(
                      backgroundImage: _con.imagen != null
                          ? NetworkImage('https://wegoapli.azurewebsites.net/media/'+_con.imagen)
                          : AssetImage('assets/img/profile.jpg'),
                      radius: 50,
                    ),
                    SizedBox(width: 15,),
                    Expanded(
                      child: Text(
                        _con.name ?? 'Nombre de usuario',
                        style: TextStyle(
                            fontSize: 18,
                            color: Colors.black,
                            fontWeight: FontWeight.bold
                        ),
                        maxLines: 1,
                      ),
                    ),
                    SizedBox(width: 5,),
                    Expanded(
                      child: Text(
                        _con.lastname ?? 'apellido',
                        style: TextStyle(
                            fontSize: 18,
                            color: Colors.black,
                            fontWeight: FontWeight.bold
                        ),
                        maxLines: 1,
                      ),
                    ),
                  ],
                ),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        _con.calificacion.toString() ?? 'calificacion',
                        style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[800],
                            fontWeight: FontWeight.bold
                        ),
                        maxLines: 1,
                      ),
                      Icon(Icons.star),
                      SizedBox(width: 90,),
                    ],
                  ),
                ),
              ],
            ),
            decoration: BoxDecoration(
                color: Colors.amber
            ),
          ),
          ListTile(
            title: Text('Editar perfil'),
            trailing: Icon(Icons.edit),
            // leading: Icon(Icons.cancel),
            onTap: _con.goToEditPage,
          ),
          ListTile(
            title: Text('Historial de viajes   ${_con.viajes.toString()}'),
            trailing: Icon(Icons.history),
            // leading: Icon(Icons.cancel),
            //onTap: _con.goToHistoryPage,
          ),
          ListTile(
            title: Text('saldo   ${_con.saldo.toString()}'),
            trailing: Icon(Icons.attach_money),
            // leading: Icon(Icons.cancel),
            //onTap: _con.goToHistoryPage,
          ),
          ListTile(
            title: Text('Cerrar sesion'),
            trailing: Icon(Icons.power_settings_new),
            leading: Icon(Icons.cancel),
            onTap: _con.signOut,
          ),
        ],
      ),
    );
  }
  Widget _buttonDrawer() {
    return Container(
      alignment: Alignment.centerLeft,
      child: IconButton(
        onPressed: _con.openDrawer,
        icon: Icon(Icons.menu, color: Colors.white,),
      ),
    );
  }


  void refresh() {
    if (!mounted) {
      return;
    }
      setState(() {});
    }
}
