import 'package:flutter/material.dart';
import 'package:flutter_bootstrap5/flutter_bootstrap5.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'pages/login.dart';

void main() async{
  await dotenv.load(fileName: ".env");
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return FlutterBootstrap5(
      builder: (context) {
        return MaterialApp(
         debugShowCheckedModeBanner: false,
          title: 'FWZ - Admin',
          home: LoginPage(),
        );
      }
    ); 
  }
}
