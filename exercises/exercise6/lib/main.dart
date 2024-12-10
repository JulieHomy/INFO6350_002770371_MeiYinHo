import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'firebase_options.dart';
import 'notification_screen.dart';


Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  print('message: ${message.messageId}');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();


  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await FirebaseMessaging.instance.requestPermission();

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final FirebaseMessaging _messaging;
  String? _token;

  @override
  void initState() {
    super.initState();

    _messaging = FirebaseMessaging.instance;

    _messaging.getToken().then((token) {
      setState(() {
        _token = token;
      });
      print('FCM Token: $_token');
    });


    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('message: ${message.messageId}');

    });


    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('notify user: ${message.messageId}');

    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'FCM Demo',
      home: NotificationScreen(),
    );
  }
}
