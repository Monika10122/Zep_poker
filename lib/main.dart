import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import '/logic/widget_tree.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: 'YOUR_API_KEY', 
      appId: 'YOUR_API_ID', 
      messagingSenderId: 'YOUR_MESAGING_SENDER_ID', 
      projectId: 'yOUR_PROJECT_ID')
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Zep Poker',
      theme: ThemeData(
        primarySwatch: Colors.brown,
      ),
      home: const WidgetTree(),
    );
  }
}