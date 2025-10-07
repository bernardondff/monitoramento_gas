import 'package:flutter/material.dart';
// Garanta que este caminho para a tela do botijão está correto!
import 'package:monitoramento_gas/pages/tela_botijao.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  SignUpScreenState createState() => SignUpScreenState();
}

class SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  bool _acceptTerms = false;

  // ESTA É A FUNÇÃO CORRIGIDA
  void _signUp() {
    String username = _usernameController.text.trim();
    String email = _emailController.text.trim();
    String password = _passwordController.text;
    String confirmPassword = _confirmPasswordController.text;

    if (username.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty) {
      _showMessage("Por favor, preencha todos os campos.");
      return;
    }

    if (password != confirmPassword) {
      _showMessage("As senhas não coincidem.");
      return;
    }

    if (!_acceptTerms) {
      _showMessage("Você precisa aceitar os termos para continuar.");
      return;
    }

    // AQUI A MÁGICA ACONTECE: NAVEGAÇÃO PARA A TELA DO BOTIJÃO
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const GasMonitorScreen()),
    );
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.redAccent,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF294046),
      appBar: AppBar(
        title: const Text("Criar Conta"),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 20),
            _buildTextField(_usernameController, "Usuário"),
            const SizedBox(height: 16),
            _buildTextField(_emailController, "Email",
                keyboardType: TextInputType.emailAddress),
            const SizedBox(height: 16),
            _buildTextField(_passwordController, "Senha", obscureText: true),
            const SizedBox(height: 16),
            _buildTextField(_confirmPasswordController, "Confirmar Senha",
                obscureText: true),
            const SizedBox(height: 24),
            Row(
              children: [
                Switch(
                  value: _acceptTerms,
                  onChanged: (value) {
                    setState(() {
                      _acceptTerms = value;
                    });
                  },
                  activeThumbColor: const Color(0xFF3399FF),
                ),
                const Expanded(
                  child: Text(
                    "Aceito os termos de uso",
                    style: TextStyle(color: Colors.white70),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF3399FF),
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 50),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
              ),
              onPressed: _signUp,
              child: const Text(
                "Cadastrar",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label,
      {bool obscureText = false, TextInputType? keyboardType}) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white70),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.white24),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF3399FF)),
        ),
      ),
    );
  }
}