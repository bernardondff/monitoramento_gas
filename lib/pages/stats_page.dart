// ARQUIVO: lib/pages/stats_page.dart

import 'package:flutter/material.dart';
// ↓↓↓ IMPORT NECESSÁRIO ↓↓↓
import 'package:firebase_database/firebase_database.dart';

class StatsPage extends StatefulWidget {
  const StatsPage({super.key});

  @override
  State<StatsPage> createState() => _StatsPageState();
}

class _StatsPageState extends State<StatsPage> {
  
  // 1. Crie uma "Referência" para o "endereço" que queremos escutar
  final DatabaseReference _databaseRef = 
      FirebaseDatabase.instance.ref('botijoes/botijao_01');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A3644), // Mesma cor de fundo
      
      // 2. O StreamBuilder "escuta" a referência
      body: StreamBuilder(
        stream: _databaseRef.onValue, // "onValue" escuta mudanças em tempo real
        builder: (context, snapshot) {
          
          // --- CENÁRIO 1: CARREGANDO ---
          // Se o snapshot (os dados) ainda não chegou
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // --- CENÁRIO 2: ERRO OU SEM DADOS ---
          // Se deu erro ou se os dados vieram "null"
          if (!snapshot.hasData || snapshot.data!.snapshot.value == null) {
            return const Center(
              child: Text(
                'Nenhum dado encontrado.\nAguardando hardware...',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white70, fontSize: 18),
              ),
            );
          }

          // --- CENÁRIO 3: SUCESSO! OS DADOS CHEGARAM ---
          // Os dados estão em 'snapshot.data!.snapshot.value'
          // Convertemos os dados (que são um JSON) para um 'Map' do Dart
          Map<dynamic, dynamic> data = 
              snapshot.data!.snapshot.value as Map<dynamic, dynamic>;
          
          // Pegamos os valores de dentro do Map
          // Usamos '?? 0' ou '?? false' como fallback seguro
          int nivel = data['nivel'] ?? 0;
          String status = data['status'] ?? 'Desconhecido';
          bool vazamento = data['vazamento'] ?? false;
          
          // Exibe os dados na tela
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'DADOS EM TEMPO REAL:',
                  style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 40),
                
                // Exibindo o Nível
                Text(
                  'Nível: $nivel%',
                  style: TextStyle(color: Colors.blueAccent, fontSize: 32, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                
                // Exibindo o Status
                Text(
                  'Status: $status',
                  style: TextStyle(color: Colors.white70, fontSize: 20),
                ),
                const SizedBox(height: 20),

                // Exibindo o Alerta de Vazamento
                if (vazamento)
                  Text(
                    'PERIGO: VAZAMENTO DETECTADO!',
                    style: TextStyle(color: Colors.red, fontSize: 22, fontWeight: FontWeight.bold),
                  )
                else
                  Text(
                    'Seguro',
                    style: TextStyle(color: Colors.greenAccent, fontSize: 22, fontWeight: FontWeight.bold),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}