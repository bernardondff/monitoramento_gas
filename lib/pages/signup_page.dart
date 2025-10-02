import 'package:flutter/material.dart';
import 'package:monitoramento_gas/pages/signup_email_page.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Color(0xFF294046), // cor do fundo igual ao PNG
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo
            Image.asset(
              'assets/logo_app_sem_fundo.png', // troquei para .png
              height: 350, // aumentei o tamanho
            ),
            const SizedBox(height: 20),

            // Nome do App
            const Text(
              "SafeGas\nMONITOR",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 40),

            // Botão Google
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black87,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
              ),
              onPressed: () {
                // depois integramos com Firebase Auth
              },
              icon: const Icon(Icons.account_circle, size: 24, color: Colors.black87),
              label: const Text(
                "Continuar com o Google",
                style: TextStyle(fontSize: 16),
              ),
            ),
            const SizedBox(height: 20),

            // Alternativa de login com e-mail/telefone
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SignUpScreen()),
                );
              },
              child: const Text(
                "Usar e-mail ou telefone",
                style: TextStyle(color: Colors.white70),
              ),
            ),
            const SizedBox(height: 30),

            // Link para Login
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Já tem uma conta?",
                  style: TextStyle(color: Colors.white70),
                ),
                TextButton(
                  onPressed: () {
                    // navegação futura para tela de Login
                  },
                  child: const Text(
                    "Entrar",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
