import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class SensorChart extends StatelessWidget {
  final List<FlSpot> xData;
  final List<FlSpot> yData;
  final List<FlSpot> zData;
  final double minY;
  final double maxY;
  final bool showX;
  final bool showY;
  final bool showZ;

  const SensorChart({
    super.key,
    required this.xData,
    required this.yData,
    required this.zData,
    required this.minY,
    required this.maxY,
    this.showX = true,
    this.showY = false,
    this.showZ = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 250,
      child: Card(
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: LineChart(
            LineChartData(
              minX: 0,
              maxX: 50,
              minY: minY,
              maxY: maxY,
              titlesData: const FlTitlesData(
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: true),
                ),
              ),
              gridData: const FlGridData(show: true),
              borderData: FlBorderData(
                show: true,
                border: Border.all(color: Colors.grey),
              ),
              lineBarsData: [
                if (showX) _createLineData(xData, Colors.blue),
                if (showY) _createLineData(yData, Colors.orange),
                if (showZ) _createLineData(zData, Colors.green),
              ],
            ),
          ),
        ),
      ),
    );
  }

  LineChartBarData _createLineData(List<FlSpot> spots, Color color) {
    return LineChartBarData(
      spots: spots,
      isCurved: true,
      color: color,
      barWidth: 1.5,
      dotData: const FlDotData(show: false),
      belowBarData: BarAreaData(show: false),
    );
  }
}
