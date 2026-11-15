import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class TrendChart extends StatelessWidget {
  const TrendChart({super.key, required this.values, required this.color, required this.unit});
  final List<double> values;
  final Color color;
  final String unit;

  @override
  Widget build(BuildContext context) {
    final spots = values.asMap().entries
        .map((entry) => FlSpot(entry.key.toDouble(), entry.value))
        .toList();
    final minY = values.reduce((a, b) => a < b ? a : b) - 8;
    final maxY = values.reduce((a, b) => a > b ? a : b) + 8;
    return SizedBox(
      height: 190,
      child: LineChart(
        LineChartData(
          minY: minY < 0 ? 0 : minY,
          maxY: maxY,
          gridData: FlGridData(show: true, drawVerticalLine: false, getDrawingHorizontalLine: (_) => FlLine(color: Colors.white12, strokeWidth: 1)),
          borderData: FlBorderData(show: false),
          titlesData: FlTitlesData(
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 34, getTitlesWidget: (value, meta) => Text(value.toInt().toString(), style: const TextStyle(fontSize: 10, color: Colors.white54)))),
            bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, interval: 1, getTitlesWidget: (value, meta) {
              const labels = ['D1', 'D2', 'D3', 'D4', 'D5', 'D6', 'D7'];
              final index = value.toInt();
              return Padding(padding: const EdgeInsets.only(top: 8), child: Text(index >= 0 && index < labels.length ? labels[index] : '', style: const TextStyle(fontSize: 10, color: Colors.white54)));
            })),
          ),
          lineBarsData: [
            LineChartBarData(
              spots: spots,
              isCurved: true,
              color: color,
              barWidth: 3,
              dotData: const FlDotData(show: true),
              belowBarData: BarAreaData(show: true, color: color.withValues(alpha: 0.12)),
            ),
          ],
        ),
      ),
    );
  }
}
