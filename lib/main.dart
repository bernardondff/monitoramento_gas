// ARQUIVO: lib/main.dart

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:monitoramento_gas/firebase_options.dart';
// IMPORTS NOVOS PARA NOTIFICAÇÃO
import 'package:firebase_messaging/firebase_messaging.dart';
import 'dart:async';

import 'package:monitoramento_gas/pages/splash_screen.dart';

// --- LÓGICA DE NOTIFICAÇÃO EM SEGUNDO PLANO ---
// Esta função precisa ser FORA de qualquer classe (top-level)
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Se precisar usar outros serviços do Firebase aqui, tem que inicializar antes.
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // ignore: avoid_print
  print("Notificação recebida em segundo plano: ${message.notification?.title}");
}
// ----------------------------------------------

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Inicializa o Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // --- CONFIGURAÇÃO DO FCM (FIREBASE CLOUD MESSAGING) ---
  
  // 1. Define o manipulador para mensagens em segundo plano
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // 2. Pega a instância do Messaging
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  // 3. Pede permissão ao usuário (crucial no iOS, boa prática no Android 13+)
  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: true, // Alerta crítico para vazar som mesmo no silencioso (se o OS deixar)
    provisional: false,
    sound: true,
  );
  // ignore: avoid_print
  print('Permissão de notificação: ${settings.authorizationStatus}');

  // 4. Inscreve o dispositivo no tópico "alerta_vazamento"
  // É para este tópico que a nossa Cloud Function envia a mensagem.
  await messaging.subscribeToTopic('alerta_vazamento');
  // ignore: avoid_print
  print('Inscrito no tópico alerta_vazamento!');

  // 5. Configura como o app lida com notificações quando está ABERTO (foreground)
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    // ignore: avoid_print
    print('Mensagem recebida com o app aberto!');
    if (message.notification != null) {
      // Aqui você pode mostrar um dialog, um snackbar, etc.
      // ignore: avoid_print
      print('Título: ${message.notification!.title}, Corpo: ${message.notification!.body}');
    }
  });
  
  // -----------------------------------------------------

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SafeGas Monitor',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF3399FF),
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
        fontFamily: 'Roboto',
      ),
      // Inicia pela Splash Screen, que decide se vai pro Login ou Home
      home: const SplashScreen(),
    );
  }
}