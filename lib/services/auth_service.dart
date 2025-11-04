import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/foundation.dart'; // Para mostrar prints só no debug

class AuthService {
  
  // Instância do Firebase Auth
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Instância do Google Sign-In
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  /// Método principal de Login com Google
  Future<User?> signInWithGoogle() async {
    try {
      // 1. Inicia o fluxo de login do Google (popup).
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      // Se o usuário fechar o popup ou cancelar
      if (googleUser == null) {
        if (kDebugMode) {
          print('Login com Google cancelado pelo usuário.');
        }
        return null;
      }

      // 2. Obtém os detalhes de autenticação (tokens)
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      // 3. Cria uma credencial do Firebase usando os tokens
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // 4. Faz o login no *Firebase* com essa credencial
      final UserCredential userCredential = await _auth.signInWithCredential(credential);
      final User? user = userCredential.user;

      if (user != null && kDebugMode) {
        // ignore: avoid_print
        print('Login com Google/Firebase realizado com sucesso: ${user.displayName}');
      }
      
      return user; // Retorna o usuário do Firebase

    } on FirebaseAuthException catch (e) {
      if (kDebugMode) {
        print('Erro de FirebaseAuth: ${e.message}');
      }
      return null;
    } catch (e) {
      if (kDebugMode) {
        print('Ocorreu um erro inesperado: $e');
      }
      return null;
    }
  }

  /// Método de Logout
  Future<void> signOut() async {
    await _googleSignIn.signOut(); // Desloga do Google
    await _auth.signOut();         // Desloga do Firebase
    if (kDebugMode) {
      print('Usuário deslogado.');
    }
  }
}