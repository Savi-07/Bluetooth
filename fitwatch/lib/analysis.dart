import 'package:fitwatch/sensorChart.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class AnalysisScreen extends StatefulWidget {
  final List<Map<String, dynamic>> dataHistory;
  final String status;

  const AnalysisScreen({
    required this.dataHistory,
    required this.status,
    super.key,
  });

  @override
  State<AnalysisScreen> createState() => _AnalysisScreenState();
}

class _AnalysisScreenState extends State<AnalysisScreen> {
  int selectedIndex = 0; // 0 = Accelerometer, 1 = Gyrometer
  final int _displayPoints = 50;
  @override
  Widget build(BuildContext context) {
    final List<FlSpot> accX = [];
    final List<FlSpot> accY = [];
    final List<FlSpot> accZ = [];
    final List<FlSpot> gyroX = [];
    final List<FlSpot> gyroY = [];
    final List<FlSpot> gyroZ = [];
    // if (widget.dataHistory.isNotEmpty && widget.dataHistory.length >= _displayPoints) {
    double maxY = -double.infinity;
    double minY = double.infinity;
    double gmaxY = -double.infinity;
    double gminY = double.infinity;
    // double maxY = 10, minY = -10; // Default ranges
    // double gmaxY = 10, gminY = -10;

    int dataPointsLength =
        (50 < widget.dataHistory.length) ? 50 : widget.dataHistory.length;
    if (dataPointsLength == 0) {
      return Material(
        child: Expanded(
            child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Empty Data Set',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
              ),
              Text('Start an activity now!')
            ],
          ),
        )),
      );
    }
    // Display latest entries in reverse
    // for (int i = 50; i >= 0; i--) {
    for (int i = dataPointsLength - 1; i >= 0; i--) {
      final data = widget.dataHistory[i];
      final x = _parseDouble(data['acc_X']);
      final y = _parseDouble(data['acc_Y']);
      final z = _parseDouble(data['acc_Z']);
      final gx = _parseDouble(data['gyro_X']);
      final gy = _parseDouble(data['gyro_Y']);
      final gz = _parseDouble(data['gyro_Z']);

      accX.add(FlSpot(50 - i.toDouble(), x));
      accY.add(FlSpot(50 - i.toDouble(), y));
      accZ.add(FlSpot(50 - i.toDouble(), z));

      gyroX.add(FlSpot(50 - i.toDouble(), gx));
      gyroY.add(FlSpot(50 - i.toDouble(), gy));
      gyroZ.add(FlSpot(50 - i.toDouble(), gz));

      maxY = x > maxY ? x : maxY;
      minY = x < minY ? x : minY;
      gmaxY = gx > gmaxY ? gx : gmaxY;
      gminY = gx < gminY ? gx : gminY;
    }

    maxY += 5;
    minY -= 5;
    gmaxY += 5;
    gminY -= 5;

    return Scaffold(
      // appBar: AppBar(title: const Text('Analysis')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Debug info
              // Padding(
              //   padding: const EdgeInsets.all(16.0),
              //   child: Column(
              //     children: [
              //       Text('Total Points: ${dataHistory.length}'),
              //       Text('Y-Range: ${minY.toStringAsFixed(1)} to ${maxY.toStringAsFixed(1)}'),
              //       Text('First X value: ${accX.isNotEmpty ? accX.first.y : "N/A"}'),
              //     ],
              //   ),
              // ),

              const SizedBox(height: 16),
              ToggleButtons(
                isSelected: [selectedIndex == 0, selectedIndex == 1],
                onPressed: (int index) {
                  setState(() {
                    selectedIndex = index;
                  });
                },
                borderRadius: BorderRadius.circular(12),
                selectedColor: Colors.white,
                fillColor: Colors.blue,
                color: Colors.black,
                constraints: const BoxConstraints(minWidth: 150, minHeight: 40),
                children: const [
                  Text("Accelerometer"),
                  Text("Gyrometer"),
                ],
              ),

              // Padding(
              //   padding: const EdgeInsets.symmetric(horizontal: 16.0),
              // Card(
              //   elevation: 4,
              //   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              //   child: Padding(
              //     padding: const EdgeInsets.all(16.0),
              //     child: SizedBox(
              //       height: 300,
              //       child: LineChart(
              //         LineChartData(
              //           minX: 0,
              //           maxX: 50,
              //           minY: minY,
              //           maxY: maxY,
              //           titlesData: const FlTitlesData(
              //             leftTitles: AxisTitles(
              //               sideTitles: SideTitles(showTitles: false),
              //             ),
              //             bottomTitles: AxisTitles(
              //               sideTitles: SideTitles(showTitles: true),
              //             ),
              //           ),
              //           gridData: const FlGridData(show: true),
              //           borderData: FlBorderData(
              //             show: true,
              //             border: Border.all(color: Colors.grey),
              //           ),
              //           lineBarsData: [
              //             _createLineData(accX, Colors.blue),
              //             _createLineData(accY, Colors.orange),
              //             _createLineData(accZ, Colors.green),
              //           ],
              //         ),
              //       ),
              //     ),
              //   ),
              // ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 10,
                    width: 10,
                    decoration: BoxDecoration(
                        color: Colors.blue,
                        border: Border.all(
                          color: Colors.black,
                          width: 1,
                        )),
                  ),
                  const SizedBox(width: 8),
                  const Text("X"),
                  const SizedBox(width: 8),
                  Container(
                    height: 10,
                    width: 10,
                    decoration: BoxDecoration(
                        color: Colors.orange,
                        border: Border.all(
                          color: Colors.black,
                          width: 1,
                        )),
                  ),
                  const SizedBox(width: 8),
                  const Text("Y"),
                  const SizedBox(width: 8),
                  Container(
                    height: 10,
                    width: 10,
                    decoration: BoxDecoration(
                        color: Colors.green,
                        border: Border.all(
                          color: Colors.black,
                          width: 1,
                        )),
                  ),
                  const SizedBox(width: 8),
                  const Text("Z"),
                ],
              ),
              if (selectedIndex == 0)
                SensorChart(
                  xData: accX,
                  yData: accY,
                  zData: accZ,
                  minY: minY,
                  maxY: maxY,
                  showX: true,
                  showY: true,
                  showZ: true,
                )
              else
                SensorChart(
                  xData: gyroX,
                  yData: gyroY,
                  zData: gyroZ,
                  minY: gminY,
                  maxY: maxY,
                  showX: true,
                  showY: true,
                  showZ: true,
                ),

              // ),
              SizedBox(
                height: 10,
              ),
              SizedBox(height: 20),
_buildActivityDurationChart(_calculateActivityDurations()),
            ],
          ),
        ),
      ),
    );
  }

  LineChartBarData _createLineData(List<FlSpot> spots, Color color) {
    return LineChartBarData(
      spots: spots,
      isCurved: false,
      color: color,
      barWidth: 1.5,
      dotData: const FlDotData(show: false),
      belowBarData: BarAreaData(show: false),
    );
  }

  double _parseDouble(dynamic val) {
    if (val is num) return val.toDouble();
    if (val is String) return double.tryParse(val) ?? 0.0;
    return 0.0;
  }

  Map<String, Duration> _calculateActivityDurations() {
  final now = DateTime.now();
  final todayStart = DateTime(now.year, now.month, now.day);
  final durations = <String, Duration>{
    "walking": Duration.zero,
    "walking_upstairs": Duration.zero,
    "walking_downstairs": Duration.zero,
    "sitting": Duration.zero,
    "standing": Duration.zero,
    "laying": Duration.zero,
  };

  // Filter and sort today's data
  final todayData = widget.dataHistory.where((entry) {
    final timestamp = DateTime.parse(entry['timestamp']);
    return timestamp.isAfter(todayStart);
  }).toList()..sort((a, b) => DateTime.parse(a['timestamp'])
      .compareTo(DateTime.parse(b['timestamp'])));

  String? currentActivity;
  DateTime? activityStartTime;

  for (final entry in todayData) {
    final entryActivity = entry['activity']?.toString().toLowerCase();
    if (!durations.containsKey(entryActivity)) continue;

    if (currentActivity != entryActivity) {
      if (currentActivity != null && activityStartTime != null) {
        final duration = DateTime.parse(entry['timestamp']).difference(activityStartTime);
        if (duration.inSeconds > 0) {
          durations[currentActivity] = durations[currentActivity]! + duration;
        }
      }
      currentActivity = entryActivity;
      activityStartTime = DateTime.parse(entry['timestamp']);
    }
  }

  return durations;
}

Color _getActivityColor(String activity) {
  switch (activity) {
    case "walking": return Colors.blue;
    case "walking_upstairs": return Colors.green;
    case "walking_downstairs": return Colors.red;
    case "sitting": return Colors.amber;
    case "standing": return Colors.orange;
    case "laying": return Colors.deepPurple;
    default: return Colors.grey;
  }
}

Widget _buildActivityDurationChart(Map<String, Duration> activityDurations) {
  const allActivities = [
    "walking", "walking_upstairs", "walking_downstairs",
    "sitting", "standing", "laying"
  ];

  final maxSeconds = activityDurations.values.fold<double>(0, 
    (max, d) => d.inSeconds > max ? d.inSeconds.toDouble() : max);

  return Card(
    elevation: 4,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Today\'s Activity Duration',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 200,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                minY: 0,
                maxY: maxSeconds * 1.2,
                barTouchData: BarTouchData(
                  enabled: true,
                  touchTooltipData: BarTouchTooltipData(
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      final activity = allActivities[group.x];
                      final duration = Duration(seconds: rod.toY.round());
                      String timeText;
                      if (duration.inHours > 0) {
                        timeText = '${duration.inHours}h ${duration.inMinutes.remainder(60)}m';
                      } else if (duration.inMinutes > 0) {
                        timeText = '${duration.inMinutes}m ${duration.inSeconds.remainder(60)}s';
                      } else {
                        timeText = '${duration.inSeconds}s';
                      }
                      return BarTooltipItem(
                        '${activity.replaceAll('_', ' ')}\n$timeText',
                        const TextStyle(color: Colors.white),
                      );
                    },
                    tooltipMargin: 10,
                    tooltipPadding: const EdgeInsets.all(8),
                    tooltipBorder: BorderSide(color: Colors.grey.shade800),
                    direction: TooltipDirection.top,
                  ),
                ),
                titlesData: FlTitlesData(
                  show: true,
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        final activity = allActivities[value.toInt()];
                        return Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            activity.split('_').map((s) => s[0].toUpperCase() + s.substring(1)).join(' '),
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 10),
                          ),
                        );
                      },
                      reservedSize: 42,
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 28,
                      interval: maxSeconds > 60 ? (maxSeconds/5).roundToDouble() : 
                               maxSeconds > 10 ? 10 : 1,
                      getTitlesWidget: (value, meta) {
                        final duration = Duration(seconds: value.toInt());
                        if (duration.inHours > 0) {
                          return Text('${duration.inHours}h', style: const TextStyle(fontSize: 10));
                        } else if (duration.inMinutes > 0) {
                          return Text('${duration.inMinutes}m', style: const TextStyle(fontSize: 10));
                        } else {
                          return Text('${duration.inSeconds}s', style: const TextStyle(fontSize: 10));
                        }
                      },
                    ),
                  ),
                ),
                gridData: const FlGridData(show: true),
                borderData: FlBorderData(
                  show: true,
                  border: Border.all(color: Colors.grey),
                ),
                barGroups: allActivities.map((activity) {
                  final seconds = activityDurations[activity]?.inSeconds.toDouble() ?? 0;
                  return BarChartGroupData(
                    x: allActivities.indexOf(activity),
                    barRods: [
                      BarChartRodData(
                        toY: seconds,
                        color: _getActivityColor(activity),
                        width: 16,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
}
