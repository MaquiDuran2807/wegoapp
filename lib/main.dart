import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wegocol/pages/client/serveces/cllientRequest.dart';
import 'package:wegocol/pages/driver/serveces/takeServeces.dart';
import 'package:wegocol/pages/driver/serveces/takeServecesController.dart';
import 'package:wegocol/pages/login/registerpage.dart';
import 'package:wegocol/providers/mesassing_provider.dart';
import 'package:wegocol/providers/socket.dart';
import 'package:wegocol/pages/client/client_map_page.dart';
import 'package:wegocol/pages/driver/map/driver_map_page.dart';
import 'package:wegocol/pages/login/login_page.dart';
import 'package:wegocol/pages/pages.home/home_page.dart';



void main()async {
  
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp( Myapp());
}

class Myapp extends StatefulWidget {

  @override
  State<Myapp> createState() => _MyappState();
}

class _MyappState extends State<Myapp> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    PushNotificationService pushNotificationsProvider = new PushNotificationService();
    pushNotificationsProvider.initializeApp();
  }

  @override
  Widget build(BuildContext context) {
    return  MultiProvider(
      providers: [ChangeNotifierProvider(create: (_)=>SocketService())],
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'wego',
          initialRoute: 'home',
          routes: {
            'home':(context)=>HomePage(),
            'login':(context)=>LoginPage(),
            'register':(context)=>ClientRegisterPage(),
            'driver/map':(BuildContext context)=> DriverMapPage(),
            'client/map':(context)=>ClientMapPage(),
            'driver/serveces':(context)=>DriverTravelRequestPage(),
            'client/serveces':(context)=>ClientTravelRequestPage(),
          },
      ),
    );
  }
}