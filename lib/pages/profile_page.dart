// ARQUIVO: lib/pages/profile_page.dart

import 'package:flutter/material.dart';
// ↓↓↓ IMPORTS NECESSÁRIOS ↓↓↓
import 'package:firebase_auth/firebase_auth.dart';
import 'package:monitoramento_gas/services/auth_service.dart';
import 'package:monitoramento_gas/pages/signup_page.dart';

class ProfilePage extends StatelessWidget {
  
  // 1. RECEBE O USUÁRIO
  final User user;
  const ProfilePage({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A3644), // Mesma cor de fundo
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            
            // Ícone do Perfil
            Icon(Icons.person_pin_circle, size: 100, color: Colors.white70),
            const SizedBox(height: 20),

            // Nome do Usuário
            Text(
              user.displayName ?? 'Usuário', // <-- DADO REAL
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),

            // E-mail do Usuário
            Text(
              user.email ?? 'E-mail não disponível', // <-- DADO REAL
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white54,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 50),

            // Botão "Grande" de Logout
            ElevatedButton.icon(
              icon: const Icon(Icons.logout, color: Colors.white),
              label: const Text(
                'Sair da Conta',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent, // Cor de perigo
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () async {
                // Chama a mesma função de logout do AppBar
                await AuthService().signOut();
                if (context.mounted) {
                  // Manda de volta para o Login
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => const SignUpPage()),
                    (Route<dynamic> route) => false,
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}