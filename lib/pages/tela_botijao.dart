import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:firebase_auth/firebase_auth.dart';

class GasMonitorScreen extends StatefulWidget {
  // torne o usuário opcional para compatibilidade com instâncias atuais
  final User? user;

  const GasMonitorScreen({super.key, this.user});

  @override
  State<GasMonitorScreen> createState() => _GasMonitorScreenState();
}

class _GasMonitorScreenState extends State<GasMonitorScreen> {
  int _selectedIndex = 0; // Alterado de 1 para 0

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 3. COR DE FUNDO ESCURA GARANTIDA
      backgroundColor: const Color(0xFF1A3644),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        // 2. REMOVE A SETA DE VOLTAR
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(Icons.shield_outlined, color: Colors.white70),
            SizedBox(width: 8),
            Text(
              'SafeGas Monitor',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ],
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Spacer(),
            GasTankWidget(percentage: 75),
            SizedBox(height: 40),
            StatusWidget(),
            Spacer(),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF234455),
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart_outlined),
            activeIcon: Icon(Icons.bar_chart),
            label: 'History',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_outlined),
            activeIcon: Icon(Icons.settings),
            label: 'Settings',
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

// O RESTO DO CÓDIGO CONTINUA O MESMO

// WIDGET DO BOTIJÃO DE GÁS (COM ANIMAÇÃO)
class GasTankWidget extends StatefulWidget {
  final double percentage;
  const GasTankWidget({super.key, required this.percentage});

  @override
  State<GasTankWidget> createState() => _GasTankWidgetState();
}

class _GasTankWidgetState extends State<GasTankWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

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
    return SizedBox(
      width: 200,
      height: 300,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(100),
            ),
          ),
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: CustomPaint(
                  size: const Size(200, 300),
                  painter: WavePainter(
                    animationValue: _controller.value,
                    percentage: widget.percentage,
                    color: const Color(0xFF3399FF),
                  ),
                ),
              );
            },
          ),
          Text(
            '${widget.percentage.toInt()}%',
            style: const TextStyle(
              fontSize: 56,
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

// CLASSE QUE DESENHA A ONDA
class WavePainter extends CustomPainter {
  final double animationValue;
  final double percentage;
  final Color color;

  WavePainter(
      {required this.animationValue,
      required this.percentage,
      required this.color});

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