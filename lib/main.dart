import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

// Importe suas telas
import 'package:monitoramento_gas/pages/signup_page.dart';
import 'package:monitoramento_gas/pages/tela_botijao.dart'; // Onde está a GasMonitorScreen

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Vamos inicializar o Firebase com segurança
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    
    // Se deu certo, roda o MyApp
    runApp(const MyApp());

  } catch (e) { 
    // Se deu erro, mostra uma tela de erro
    runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: Text(
            'Falha ao conectar com o Firebase.\n\n${e.toString()}',
            textAlign: TextAlign.center,
          ),
        ),
        ),
      ),
    );
  }
}

// O App principal
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "SafeGas",
      theme: ThemeData(
        brightness: Brightness.dark, // Tema escuro
        scaffoldBackgroundColor: const Color(0xFF1A3644),
        primaryColor: const Color(0xFF1A3644),
        fontFamily: 'Roboto',
      ),
      // A "home" do nosso app agora é o "Vigia" de autenticação
      home: const AuthWrapper(),
    );
  }
}


// O "VIGIA" DE AUTENTICAÇÃO
//
// Este widget vai "escutar" o Firebase e decidir
// para qual tela o usuário deve ir.
class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      // "Escuta" o status de login do Firebase em tempo real
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        
        // 1. Se estiver "carregando" a informação
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        // 2. Se o Firebase JÁ TEM um usuário logado
        if (snapshot.hasData) {
          // 'snapshot.data!' é o objeto 'User'
          return GasMonitorScreen(user: snapshot.data!);
        }

        // 3. Se NÃO TEM usuário logado
        return const SignUpPage();
      },
    );
  }
}