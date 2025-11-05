import 'package:flutter/material.dart';
import 'package:monitoramento_gas/pages/signup_email_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:monitoramento_gas/services/auth_service.dart';
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
// ... (linha 36, o SizedBox)
  const SizedBox(height: 40),

  // ↓↓↓ COLE ESTE BLOCO INTEIRO (SUBSTITUA SEU BOTÃO) ↓↓↓
  ElevatedButton.icon(
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.white,
      foregroundColor: Colors.black87,
      minimumSize: const Size(double.infinity, 50),
      // Adiciona a borda arredondada que você tinha
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12), 
      ),
    ),

    // 1. ESTE É O "onPressed" QUE USA OS IMPORTS
    onPressed: () async {
      // Mostra um indicador de "carregando"
      showDialog(
        context: context,
        builder: (context) => const Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );

      // USA O 'AuthService' (import 1 some)
      AuthService authService = AuthService();
      // USA O 'User' (import 2 some)
      User? user = await authService.signInWithGoogle();

      if (context.mounted) {
        Navigator.of(context).pop(); // Tira o "carregando"
      }

      if (user != null && context.mounted) {
        // SUCESSO!
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            // USA A 'GasMonitorScreen' (import 3 some)
            // Lembre-se que o nome da sua classe é GasMonitorScreen
            builder: (context) => GasMonitorScreen(user: user), 
          ),
        );
      } else if (context.mounted) {
        // FALHA!
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Falha ao fazer login com o Google.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    },
    icon: const Icon(Icons.person), // ( ícone do Google)
    label: const Text(
      'Continuar com o Google',
      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
    ),
    
  ),

  const SizedBox(height: 20), // Espaçamento
  // ... (aqui continua seu texto "Usar e-mail para login")
            const SizedBox(height: 20),

            // Alternativa de login com e-mail
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  // ajustado para o nome real do widget em signup_email_page.dart
                  MaterialPageRoute(builder: (context) => const SignUpScreen()),
                );
              },
              child: const Text(
                "Usar e-mail para login",
                style: TextStyle(color: Colors.white70),
              ),
            ),
            const SizedBox(height: 30),

            // Link para Login se já tiver conta
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
