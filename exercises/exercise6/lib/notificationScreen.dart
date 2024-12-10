import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationScreen extends StatefulWidget {
  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  String? _token;
  String? _messageTitle = "no new notice";
  String? _messageBody = "click button to test";

  @override
  void initState() {
    super.initState();
    _setupFirebaseMessaging();
  }

  Future<void> _setupFirebaseMessaging() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('user already Authorize');
      String? token = await messaging.getToken();
      setState(() {
        _token = token;
      });
      print('FCM Token: $_token');
    } else {
      print('user not authorize');
    }

    // 监听前台消息
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('massage recived: ${message.notification?.title}');
      setState(() {
        _messageTitle = message.notification?.title ?? "no title";
        _messageBody = message.notification?.body ?? "no context";
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message.notification?.body ?? 'message received')),
      );
    });

    // 监听点击通知的操作
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('user click massage: ${message.notification?.title}');
      setState(() {
        _messageTitle = message.notification?.title ?? "click notice";
        _messageBody = message.notification?.body ?? "no content";
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('massage authorize')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'FCM Token:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Text(
              _token ?? "haven't get",
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14, color: Colors.blue),
            ),
            const SizedBox(height: 20),
            const Text(
              'newest massage:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Text(
              _messageTitle ?? "no title",
              style: const TextStyle(fontSize: 14),
            ),
            Text(
              _messageBody ?? "no content",
              style: const TextStyle(fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}