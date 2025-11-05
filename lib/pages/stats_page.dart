import 'package:flutter/material.dart';

class StatsPage extends StatelessWidget {
  const StatsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color( 0xFF1A3644),
      body: Center(
        child: Text(
          'Página de Estatísticas/n(Em construção)',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white, fontSize: 22),
        ),
      ),
    );
  }
}