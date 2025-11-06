// ARQUIVO: lib/pages/tela_botijao.dart
// (VERSÃO FINAL COM A CORREÇÃO DO ProfilePage)

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:monitoramento_gas/services/auth_service.dart';
import 'package:monitoramento_gas/pages/signup_page.dart';

// Imports das novas telas e do Realtime Database
import 'package:monitoramento_gas/pages/stats_page.dart';
import 'package:monitoramento_gas/pages/profile_page.dart';
import 'package:firebase_database/firebase_database.dart';


class GasMonitorScreen extends StatefulWidget {
  final User user; 
  const GasMonitorScreen({super.key, required this.user});

  @override
  State<GasMonitorScreen> createState() => _GasMonitorScreenState();
}

class _GasMonitorScreenState extends State<GasMonitorScreen>
    with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;
  late final AnimationController _controller;
  late final List<Widget> _pages;

  final DatabaseReference _databaseRef = 
      FirebaseDatabase.instance.ref('botijoes/botijao_01');

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();

    // Inicializa a lista de telas com o StreamBuilder
    _pages = [
      
      // Tab 0: Home (AGORA "ESCUTANDO" O FIREBASE)
      StreamBuilder(
        stream: _databaseRef.onValue, // O "escutador"
        builder: (context, snapshot) {
          
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.snapshot.value == null) {
            // Mostra 0% como fallback
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GasTankWidget(
                    percentage: 0, // Mostra 0%
                    controller: _controller,
                  ),
                  const SizedBox(height: 24),
                  const StatusWidget(status: "Aguardando dados...", vazamento: false),
                ],
              ),
            );
          }

          // SUCESSO! Os dados chegaram
          Map<dynamic, dynamic> data = 
              snapshot.data!.snapshot.value as Map<dynamic, dynamic>;
          
          int nivel = data['nivel'] ?? 0;
          String status = data['status'] ?? 'Desconhecido';
          bool vazamento = data['vazamento'] ?? false;
          
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GasTankWidget(
                  percentage: nivel.toDouble(), // <-- DADO REAL
                  controller: _controller,
                ),
                const SizedBox(height: 24),
                StatusWidget(status: status, vazamento: vazamento), // <-- DADO REAL
              ],
            ),
          );
        },
      ),
      // FIM DA TAB 0
      
      // Tab 1: Stats 
      const StatsPage(),
      
      // ↓↓↓ AQUI ESTÁ A CORREÇÃO ↓↓↓
      // Tab 2: Profile (Agora passa o usuário)
      ProfilePage(user: widget.user), // <-- CORRIGIDO
      // ↑↑↑ FIM DA CORREÇÃO ↑↑↑
    ];
  }


  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A3644),
      appBar: AppBar(
        title: Text('Bem-vindo, ${widget.user.displayName ?? 'Usuário'}'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false, 
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white70),
            onPressed: () async {
              await AuthService().signOut();
              if (context.mounted) {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const SignUpPage()),
                  (Route<dynamic> route) => false,
                );
              }
            },
          ),
        ],
      ),
      
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF234455),
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined), 
            activeIcon: Icon(Icons.home),
            label: 'Home'
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart_outlined),
            activeIcon: Icon(Icons.bar_chart),
            label: 'Monitor',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline), 
            activeIcon: Icon(Icons.person), 
            label: 'Profile'
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white54,
        onTap: _onItemTapped,
        showSelectedLabels: false,
        showUnselectedLabels: false,
      ),
    );
  }
}

// --- WIDGET DO BOTIJÃO DE GÁS ---
class GasTankWidget extends StatelessWidget {
  final double percentage;
  final AnimationController controller;

  const GasTankWidget({
    super.key,
    required this.percentage,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 160,
      height: 240,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 120,
            height: 200,
            decoration: BoxDecoration(
              color: const Color(0xFF1E2E35),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white24),
            ),
          ),
          AnimatedBuilder(
            animation: controller,
            builder: (context, child) {
              return CustomPaint(
                size: const Size(120, 200),
                painter: WavePainter(
                  animationValue: controller.value,
                  percentage: percentage,
                  color: Colors.lightBlueAccent,
                ),
              );
            },
          ),
          Text(
            '${percentage.toInt()}%',
            style: const TextStyle(
              fontSize: 48,
              color: Colors.white,
              fontWeight: FontWeight.bold,
              shadows: [
                Shadow(
                  blurRadius: 10.0,
                  color: Colors.black26,
                  offset: Offset(2.0, 2.0),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// --- CLASSE QUE DESENHA A ONDA ---
class WavePainter extends CustomPainter {
  final double animationValue;
  final double percentage;
  final Color color;

  WavePainter({
    required this.animationValue,
    required this.percentage,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    final double waveHeight = size.height * (percentage / 100);
    
    // Correção da onda para nível baixo
    final double waveAmplitude = math.min(8.0, waveHeight / 2);
    
    final path = Path();
    path.moveTo(0, size.height);
    path.lineTo(0, size.height - waveHeight);

    for (double i = 0; i <= size.width; i++) {
      path.lineTo(
        i,
        (size.height - waveHeight) +
            (math.sin((i / size.width * 2 * math.pi) +
                    (animationValue * 2 * math.pi)) *
                waveAmplitude), // <-- USA A AMPLITUDE CORRIGIDA
      );
    }

    path.lineTo(size.width, size.height);
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}


// --- WIDGET DE STATUS "INTELIGENTE" ---
class StatusWidget extends StatelessWidget {
  final String status;
  final bool vazamento;

  const StatusWidget({
    super.key, 
    required this.status, 
    required this.vazamento
  });

  @override
  Widget build(BuildContext context) {
    final Color statusColor = vazamento ? Colors.redAccent : Colors.greenAccent;
    final IconData statusIcon = vazamento ? Icons.warning_amber_rounded : Icons.check_circle;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Status: $status', // Mostra o status real
          style: const TextStyle(color: Colors.white70, fontSize: 16),
        ),
        const SizedBox(width: 8),
        Icon(statusIcon, color: statusColor, size: 20), // Mostra o ícone real
      ],
    );
  }
}