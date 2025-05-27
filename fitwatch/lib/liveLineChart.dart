// import 'package:fl_chart/fl_chart.dart';
// import 'package:flutter/material.dart';

// class LiveLineChart extends StatelessWidget {
//   final List<FlSpot> xData;
//   final List<FlSpot> yData;
//   final List<FlSpot> zData;
//   final double minX;
//   final double maxX;
//   final double minY;
//   final double maxY;

//   const LiveLineChart({
//     required this.minX,
//     required this.maxX,
//     required this.minY,
//     required this.maxY,
//     required this.xData,
//     required this.yData,
//     required this.zData,
//     Key? key,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     if (xData.isEmpty || yData.isEmpty || zData.isEmpty) {
//       return const Center(child: Text('Waiting for data...'));
//     }

//     return LineChart(
//       LineChartData(
//         minX: minX,
//         maxX: maxX,
//         minY: minY,
//         maxY: maxY,
//         clipData: const FlClipData.all(),
//         titlesData: FlTitlesData(
//           leftTitles: AxisTitles(
//             sideTitles: SideTitles(
//               showTitles: true,
//               reservedSize: 40,
//               interval: _calculateInterval(minY, maxY),
//               getTitlesWidget: (value, meta) {
//                 return Padding(
//                   padding: const EdgeInsets.only(right: 8.0),
//                   child: Text(
//                     value.toStringAsFixed(1),
//                     style: const TextStyle(
//                       fontSize: 10,
//                       color: Colors.black54,
//                     ),
//                   ),
//                 );
//               },
//             ),
//           ),
//           bottomTitles: AxisTitles(
//             sideTitles: SideTitles(
//               showTitles: true,
//               reservedSize: 22,
//               interval: _calculateInterval(minX, maxX),
//               getTitlesWidget: (value, meta) {
//                 return Text(
//                   value.toStringAsFixed(0),
//                   style: const TextStyle(
//                     fontSize: 10,
//                     color: Colors.black54,
//                   ),
//                 );
//               },
//             ),
//           ),
//           rightTitles: const AxisTitles(),
//           topTitles: const AxisTitles(),
//         ),
//         gridData: FlGridData(
//           show: true,
//           drawVerticalLine: true,
//           horizontalInterval: _calculateInterval(minY, maxY),
//           verticalInterval: _calculateInterval(minX, maxX),
//           getDrawingHorizontalLine: (value) {
//             return FlLine(
//               color: Colors.grey.withOpacity(0.3),
//               strokeWidth: 1,
//             );
//           },
//           getDrawingVerticalLine: (value) {
//             return FlLine(
//               color: Colors.grey.withOpacity(0.3),
//               strokeWidth: 1,
//             );
//           },
//         ),
//         borderData: FlBorderData(
//           show: true,
//           border: Border.all(
//             color: Colors.grey.withOpacity(0.5),
//             width: 1,
//           ),
//         ),
//         lineBarsData: [
//           _buildLineData(xData, Colors.blue),
//           _buildLineData(yData, Colors.orange),
//           _buildLineData(zData, Colors.green),
//         ],
//       ),
//     );
//   }

//   double _calculateInterval(double min, double max) {
//     final range = max - min;
//     if (range <= 0) return 1;
//     return (range / 5).clamp(1, double.infinity);
//   }

//   LineChartBarData _buildLineData(List<FlSpot> spots, Color color) {
//     return LineChartBarData(
//       spots: spots,
//       isCurved: false, // Straight lines for better real-time feel
//       color: color,
//       barWidth: 2,
//       dotData: const FlDotData(show: false),
//       belowBarData: BarAreaData(show: false),
//     );
//   }
// }
