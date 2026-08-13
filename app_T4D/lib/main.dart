import 'package:flutter/material.dart';
import 'screens/login_screen.dart';

void main() {
  runApp(const T4DApp());
}

class T4DApp extends StatelessWidget {
  const T4DApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'T4D',
      home: LoginScreen(
        setVista: (vista) {
          print('Vista: $vista');
        },
      ),
    );
  }
}