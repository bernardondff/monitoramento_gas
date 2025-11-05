import 'package:flutter/material.dart';
import 'package:monitoramento_gas/pages/signup_email_page.dart';
import 'package:monitoramento_gas/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:monitoramento_gas/pages/tela_botijao.dart';
class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Color(0xFF294046),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/logo_app_sem_fundo.png',
              height: 350,
            ),
            const SizedBox(height: 20),
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

            // INÍCIO DO BOTÃO SUBSTITUÍDO
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black87,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () async {
                // Mostra indicador de carregamento
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) => const Center(child: CircularProgressIndicator()),
                );

                final AuthService authService = AuthService();
                User? user;
                try {
                  user = await authService.signInWithGoogle();
                } catch (e) {
                  user = null;
                }

                if (context.mounted) Navigator.of(context).pop(); // tira o carregando

                if (user != null && context.mounted) {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => GasMonitorScreen(user: user!), // Add ! to force unwrap
                    ),
                  );
                } else if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Falha ao fazer login com o Google.'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              icon: const Icon(Icons.account_circle, size: 24, color: Colors.black87),
              label: const Text(
                "Continuar com o Google",
                style: TextStyle(fontSize: 16),
              ),
            ),
            // FIM DO BOTÃO SUBSTITUÍDO

            const SizedBox(height: 20),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SignUpScreen()),
                );
              },
              child: const Text(
                "Usar e-mail para login",
                style: TextStyle(color: Colors.white70),
              ),
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Já tem uma conta?",
                  style: TextStyle(color: Colors.white70),
                ),
                TextButton(
                  onPressed: () {
                    // navegar para tela de login quando existir
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
