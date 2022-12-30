import 'dart:async';

import 'package:dio/dio.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:wegocol/providers/auth_providers.dart';
import 'package:wegocol/utils/shared_pref.dart';




// SHA1: 1D:4F:38:94:62:06:9F:C6:75:A7:73:BD:E4:B0:DA:27:80:B1:9D:F0
// P8 - KeyID: VYZH37GGZ9

class PushNotificationService {

  FirebaseMessaging messaging = FirebaseMessaging.instance;

  StreamController _messageStream = new StreamController<Map<String,dynamic>>
      .broadcast();

   Stream<Map<String,dynamic>> get messagesStream => _messageStream.stream;
   AuthProvider _authProvider;
   SharedPref _sharedPref;
  String token;

   Future _backgroundHandler(RemoteMessage message) async {
    // print( 'onBackground Handler ${ message.messageId }');
    print(message.data);
    _messageStream.add(message.data?? {'No data':'no viene data'});
  }

   Future _onMessageHandler(RemoteMessage message) async {
    // print( 'onMessage Handler ${ message.messageId }');
    print(message.data);
    _messageStream.add(message.data ?? {'No data':'no viene data'});
  }

   Future _onMessageOpenApp(RemoteMessage message) async {
    // print( 'onMessageOpenApp Handler ${ message.messageId }');
    print(message.data);
    _messageStream.add(message.data ?? {'No data':'no viene data'});
  }


    Future initializeApp() async {
    // Push Notifications
    //await Firebase.initializeApp();
    await requestPermission();

    token = await FirebaseMessaging.instance.getToken();
    print('Token de notificaciones: $token');

    // Handlers
    FirebaseMessaging.onBackgroundMessage(_backgroundHandler);
    FirebaseMessaging.onMessage.listen(_onMessageHandler);
    FirebaseMessaging.onMessageOpenedApp.listen(_onMessageOpenApp);

    // Local Notifications
  }

  // Apple / Web
  requestPermission() async {
    NotificationSettings settings = await messaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true
    );

    print('User push notification status ${ settings.authorizationStatus }');
  }


  closeStreams() {
    _messageStream.close();
  }

}