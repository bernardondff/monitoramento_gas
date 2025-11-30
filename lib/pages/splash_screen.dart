// ARQUIVO: lib/pages/splash_screen.dart
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:monitoramento_gas/pages/tela_botijao.dart'; // GasMonitorScreen
import 'package:monitoramento_gas/pages/signup_page.dart'; // SignUpPage

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkLogin();
  }

  _checkLogin() async {
    // Espera 2 segundos para mostrar o logo
    await Future.delayed(const Duration(seconds: 2));

    // Verifica se tem usuário logado
    User? user = FirebaseAuth.instance.currentUser;

    if (mounted) {
      if (user != null) {
        // Se tiver logado, vai pra Home
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => GasMonitorScreen(user: user)),
        );
      } else {
        // Se não, vai pro Login
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const SignUpPage()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A3644),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Se tiver o logo, descomente a linha abaixo:
            // Image.asset('assets/logo_app_sem_fundo.png', height: 150),
            const Icon(Icons.shield, size: 100, color: Colors.white),
            const SizedBox(height: 20),
            const CircularProgressIndicator(color: Colors.white),
          ],
        ),
      ),
    );
  }
}