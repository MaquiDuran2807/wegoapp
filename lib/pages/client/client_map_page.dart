
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:wegocol/pages/client/map/client_map_controller.dart';
import 'package:wegocol/providers/auth_providers.dart';
import 'package:wegocol/providers/socket.dart';
import 'package:wegocol/utils/Colors.dart' as utils;

class ClientMapPage extends StatefulWidget {
  @override
  _ClientMapPageState createState() => _ClientMapPageState();
}

class _ClientMapPageState extends State<ClientMapPage> {

  ClientMapController _con = new ClientMapController();
  AuthProvider _authProvider=new AuthProvider();


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      _con.init(context,refresh);

    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    print('SE EJECUTO EL DISPOSE');
    _con.dispose();
  }

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      key: _con.key,
      drawer: _drawer(),
      body: Stack(
        children: [
          _googleMapsWidget(),
          SafeArea(
            child: Column(
              children: [
                _buttonDrawer(),
                _cardGooglePlaces(),
                _buttonChangeTo(),
                _buttonCenterPosition(),
                Expanded(child: Container()),
                _buttonRequest(),
                carrera(_con.menucarrera)
              ],
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: _iconMyLocation(),
          )
        ],
      ),
    );
  }

  Widget _iconMyLocation() {
    return Image.asset(
      'assets/img/my_location.png',
      width: 65,
      height: 65,
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
              onTap: _con.goToHistoryPage,
            ),
            ListTile(
              title: Text('saldo   ${_con.saldo.toString()}'),
              trailing: Icon(Icons.attach_money),
              // leading: Icon(Icons.cancel),
              onTap: _con.goToHistoryPage,
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

  Widget carrera(carreras){
    if (carreras == 'si') {
      return AnimatedContainer(duration: Duration(milliseconds: 300),
        height:MediaQuery
            .of(context)
            .size
            .height * 0.35 ,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              height: MediaQuery
                  .of(context)
                  .size
                  .height * 0.35,
              decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30), topRight: Radius.circular(30))
              ),
              child: Column(
                children: [

                  ListTile(
                    title: Text(
                      'Desde',
                      style: TextStyle(
                          fontSize: 15
                      ),
                    ),
                    subtitle: Text(
                      _con.from ?? '',
                      style: TextStyle(
                          fontSize: 13
                      ),
                    ),
                    leading: Icon(Icons.location_on),
                  ),
                  ListTile(
                    title: Text(
                      'Hasta',
                      style: TextStyle(
                          fontSize: 15
                      ),
                    ),
                    subtitle: Text(
                      _con.to ?? '',
                      style: TextStyle(
                          fontSize: 13
                      ),
                    ),
                    leading: Icon(Icons.my_location),
                  ),
                  ListTile(
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Precio',
                          style: TextStyle(
                              fontSize: 15
                          ),
                        ),
                        Text("distancia",style: TextStyle(
                            fontSize: 15
                        )
                        )
                      ],
                    ),
                    subtitle: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            '${_con.minTotal?.toStringAsFixed(2) ?? '0.0'}\$ - ${_con
                                .maxTotal?.toStringAsFixed(2) ?? '0.0'}\$',
                            style: TextStyle(
                                fontSize: 13
                            ),
                            maxLines: 1,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            '${_con.km?.toString() ?? '0.0'} Km - ${_con
                                .min?.toString() ?? '0.0'} min',
                            style: TextStyle(
                                fontSize: 13
                            ),
                            maxLines: 1,
                          ),
                        ),
                      ],
                    ),
                    leading: Icon(Icons.attach_money),
                  ),
                  Container(
                      margin: EdgeInsets.symmetric(horizontal: 30),
                      child: Row(
                        children: [
                          TextButton(
                            onPressed: _con.cancelrequest,
                            child:Text('volver') ,
                          ),
                          TextButton(
                            onPressed: (){
                              _con.carrera=true;
                              _con.goToRequest();
                            },
                            child:Text('confirmar') ,
                          ),
                        ],
                      )
                  )
                ],
              ),
            ),
          ],
        ),
      );
    }
    return AnimatedContainer(duration: Duration(milliseconds: 300),
      child:const SizedBox(height: 10,),
    );

  }

  Widget _buttonCenterPosition() {
    return GestureDetector(
      onTap: _con.centerPosition,
      child: Container(
        alignment: Alignment.centerRight,
        margin: EdgeInsets.symmetric(horizontal: 18),
        child: Card(
          shape: CircleBorder(),
          color: Colors.white,
          elevation: 4.0,
          child: Container(
            padding: EdgeInsets.all(10),
            child: Icon(
              Icons.location_searching,
              color: Colors.grey[600],
              size: 20,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buttonChangeTo() {
    return GestureDetector(
      onTap: _con.changeFromTO,
      child: Container(
        alignment: Alignment.centerRight,
        margin: EdgeInsets.symmetric(horizontal: 18),
        child: Card(
          shape: CircleBorder(),
          color: Colors.white,
          elevation: 4.0,
          child: Container(
            padding: EdgeInsets.all(10),
            child: Icon(
              Icons.refresh,
              color: Colors.grey[600],
              size: 20,
            ),
          ),
        ),
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

  Widget _buttonRequest (){
    final elevatedButtonStyle=ElevatedButton.styleFrom(
      primary: utils.Colors.orowego,
    );
    return ElevatedButton(

       onPressed: _con.requestDriver,
      child:Container(
        margin: EdgeInsets.symmetric(horizontal: 50),

        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,


          children: [
            SizedBox(width: 25,),
            _con.isConnect ? Text('DESCONECTARSE',style:TextStyle(
                color: Colors.black
            ),): Text('SOLICITAR',style:TextStyle(
                color: Colors.black
            ),),
            SizedBox(width: 10,),
            CircleAvatar(
              minRadius: 3,
              backgroundColor: Colors.black,
              child: Icon(Icons.arrow_forward_ios,color: Colors.orange,size: 19,),
            )

          ],
        ),
      ),
      style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(utils.Colors.orowego),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0))
          )
      ),


    );

  }

  Widget _googleMapsWidget() {
    return GoogleMap(
      mapType: MapType.normal,
      initialCameraPosition: _con.initialPosition,
      onMapCreated: _con.onMapCreated,
      myLocationEnabled: false,
      myLocationButtonEnabled: false,
      polylines: _con.polylines,
      markers: Set<Marker>.of(_con.markers.values),
      onCameraMove: (position)  {
        _con.initialPosition = position;
      },
      onCameraIdle: () async {
        await _con.setLocationDraggableInfo();
      },

    );
  }

  Widget _cardGooglePlaces() {
    return Container(

      width: MediaQuery.of(context).size.width * 0.9,
      child: Card(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20)
        ),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _infoCardLocation(
                  'Desde',
                  _con.from ?? 'Lugar de recogida',
                      () async {
                    await _con.showGoogleAutoComplete(true);
                  }
              ),
              SizedBox(height: 5),
              Container(
                width: double.infinity,
                  child: Divider(color: Colors.grey, height: 10)
              ),
              SizedBox(height: 5),
              _infoCardLocation(
                  'Hasta',
                  _con.to ?? 'Lugar de destino',
                      () async {
                    await _con.showGoogleAutoComplete(false);
                  }
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoCardLocation(String title, String value, Function function) {
    return GestureDetector(
      onTap: function,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Text(
            title,
            style: TextStyle(
                color: Colors.grey,
                fontSize: 10
            ),
            textAlign: TextAlign.start,
          ),
          Text(
            value,
            style: TextStyle(
                color: Colors.black,
                fontSize: 14,
                fontWeight: FontWeight.bold
            ),
            maxLines: 2,
          ),
        ],
      ),
    );
  }

  void refresh() {
    setState(() {});
  }

}
