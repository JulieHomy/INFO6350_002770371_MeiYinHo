import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'screens/browse_posts_screen.dart';
import 'screens/new_post_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(HyperGarageSaleApp());
}

class HyperGarageSaleApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HyperGarage Sale',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: BrowsePostsScreen(),
      routes: {
        '/new-post': (context) => NewPostScreen(),
      },
    );
  }
}
