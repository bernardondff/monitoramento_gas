// ARQUIVO: lib/pages/stats_page.dart
// (VERSÃO CORRIGIDA - SEM O TOOLTIP QUE DAVA ERRO)

import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:fl_chart/fl_chart.dart';

class StatsPage extends StatefulWidget {
  const StatsPage({super.key});

  @override
  State<StatsPage> createState() => _StatsPageState();
}

class _StatsPageState extends State<StatsPage> {
  final DatabaseReference _logsRef =
      FirebaseDatabase.instance.ref('logs_botijao_01');
  double _maxX = 5.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A3644),
      body: StreamBuilder(
        stream: _logsRef.onValue,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.snapshot.value == null) {
            return const Center(child: Text('Sem histórico.', style: TextStyle(color: Colors.white)));
          }

          final List<FlSpot> spots = [];
          final Map<dynamic, dynamic> logs = snapshot.data!.snapshot.value as Map<dynamic, dynamic>;
          final List<Map<dynamic, dynamic>> logEntries = logs.values.toList().cast<Map<dynamic, dynamic>>();
          
          logEntries.sort((a, b) => (a['timestamp'] ?? 0).compareTo(b['timestamp'] ?? 0));

          for (var entry in logEntries) {
            spots.add(FlSpot(
              (entry['timestamp'] ?? 0).toDouble(),
              (entry['nivel'] ?? 0).toDouble(),
            ));
          }

          if (spots.isNotEmpty) {
             _maxX = (logEntries.last['timestamp'] ?? 0).toDouble() + 1;
          }

          return Padding(
            padding: const EdgeInsets.all(24.0),
            child: LineChart(
              LineChartData(
                backgroundColor: const Color(0xFF1E2E35),
                minX: 0, maxX: _maxX, minY: 0, maxY: 100,
                gridData: FlGridData(show: true, drawVerticalLine: true),
                // REMOVI A PARTE QUE DAVA ERRO DO TOOLTIP
                lineTouchData: LineTouchData(
                    touchTooltipData: LineTouchTooltipData(
                        getTooltipItems: (touchedSpots) {
                            return touchedSpots.map((spot) {
                                return LineTooltipItem(
                                    '${spot.y.toInt()}%',
                                    const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)
                                );
                            }).toList();
                        }
                    )
                ),
                lineBarsData: [
                  LineChartBarData(
                    spots: spots,
                    isCurved: true,
                    barWidth: 4,
                    color: const Color(0xFF3399FF),
                    dotData: FlDotData(show: false),
                    // ignore: deprecated_member_use
                    belowBarData: BarAreaData(show: true, color: const Color(0xFF3399FF).withOpacity(0.3)),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}