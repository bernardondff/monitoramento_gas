import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

class GasMonitorScreen extends StatefulWidget {
  final User user; // Adiciona o usuário
  const GasMonitorScreen({super.key, required this.user}); // Atualiza o construtor

  @override
  State<GasMonitorScreen> createState() => _GasMonitorScreenState();
}

class _GasMonitorScreenState extends State<GasMonitorScreen>
    with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;
  late final AnimationController _controller;

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
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 3. COR DE FUNDO ESCURA GARANTIDA
      backgroundColor: const Color(0xFF1A3644),
      appBar: AppBar(
        title: Text('Bem-vindo, ${widget.user.displayName ?? 'Usuário'}'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              if (context.mounted) {
                Navigator.of(context).pushReplacementNamed('/');
              }
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GasTankWidget(
              percentage: 45,
              controller: _controller,
            ),
            const SizedBox(height: 24),
            const StatusWidget(),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF234455),
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.local_gas_station), label: 'Monitor'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
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

// O RESTO DO CÓDIGO CONTINUA O MESMO

// WIDGET DO BOTIJÃO DE GÁS (COM ANIMAÇÃO)
class GasTankWidget extends StatelessWidget {  // Mudou para StatelessWidget
  final double percentage;
  final AnimationController controller;  // Adiciona o controller
  
  const GasTankWidget({
    super.key, 
    required this.percentage,
    required this.controller,  // Adiciona como required
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
        ],
      ),
    );
  }
}

// CLASSE QUE DESENHA A ONDA
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
    final path = Path();
    path.moveTo(0, size.height);
    path.lineTo(0, size.height - waveHeight);

    for (double i = 0; i <= size.width; i++) {
      path.lineTo(
        i,
        (size.height - waveHeight) +
            (math.sin((i / size.width * 2 * math.pi) +
                    (animationValue * 2 * math.pi)) *
                8),
      );
    }

    path.lineTo(size.width, size.height);
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

// WIDGET PARA A MENSAGEM DE STATUS
class StatusWidget extends StatelessWidget {
  const StatusWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const [
        Text(
          'Status: No leaks detected',
          style: TextStyle(color: Colors.white70, fontSize: 16),
        ),
        SizedBox(width: 8),
        Icon(Icons.check_circle, color: Colors.greenAccent, size: 20),
      ],
    );
  }
}