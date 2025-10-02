import 'package:flutter/material.dart';
import 'pages/signup_page.dart'; // importa a tela de signup

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // tira a faixa vermelha do debug
      title: "SafeGas",
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const SignUpPage(), // define a tela inicial como a tela de signup
    );
  }
}