// ARQUIVO: lib/pages/profile_page.dart

import 'package:flutter/material.dart';

// ↓↓↓ GARANTA QUE O NOME DA CLASSE É "ProfilePage" ↓↓↓
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFF1A3644), // Mesma cor de fundo
      body: Center(
        child: Text(
          'Página de Perfil\n(Em Construção)',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white, fontSize: 22),
        ),
      ),
    );
  }
}