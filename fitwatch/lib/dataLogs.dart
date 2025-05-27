import 'package:flutter/material.dart';

class DataLogs extends StatelessWidget {
  final List<Map<String, dynamic>> dataHistory;
  final String status;

  const DataLogs({super.key, required this.dataHistory, required this.status});

  Widget _buildDataRow(Map<String, dynamic> data) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.grey[200]!))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: 60,
            child: Text(
              data['timestamp'].toString().split(' ').last,
              style: const TextStyle(fontSize: 12),
            ),
          ),
          _buildSensorChip(
              'A',
              '${(data['acc_X']??0.0).toStringAsFixed(1)}'
                  '/${(data['acc_Y']??0.0).toStringAsFixed(1)}'
                  '/${(data['acc_Z']??0.0).toStringAsFixed(1)}'),
              // '${data['acc_X'].toStringAsFixed(1)}'
              //     '/${data['acc_Y'].toStringAsFixed(1)}'
              //     '/${data['acc_Z'].toStringAsFixed(1)}'),
          _buildSensorChip(
              'G',
              '${(data['gyro_X']??0.0).toStringAsFixed(1)}'
                  '/${(data['gyro_Y']??0.0).toStringAsFixed(1)}'
                  '/${(data['gyro_Z']??0.0).toStringAsFixed(1)}'),
              // '${data['gyro_X'].toStringAsFixed(1)}'
              //     '/${data['gyro_Y'].toStringAsFixed(1)}'
              //     '/${data['gyro_Z'].toStringAsFixed(1)}'),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: _getActivityColor(data['activity']),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              data['activity'].toString().substring(0, 3).toUpperCase(),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSensorChip(String label, String value) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(label, style: const TextStyle(fontSize: 10)),
        Text(value, style: const TextStyle(fontSize: 12)),
      ],
    );
  }

  Color _getActivityColor(String activity) {
    switch (activity.toLowerCase()) {
      case 'walking':
        return Colors.blue;
      case 'walking_upstairs':
        return Colors.green;
      case 'walking_downstairs':
        return Colors.red;
      case 'sitting':
        return Colors.amber;
      case 'standing':
        return Colors.orange;
      case 'laying':
        return Colors.deepPurple;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(182, 208, 231, 1),
        title: const Text('Sensor Data', style: TextStyle(
          fontSize: 25,
          fontWeight: FontWeight.w600,
          color: Colors.white),
        ),
        actions: [
          Icon(
            status == "Connected" ? Icons.wifi : Icons.wifi_off,
            color: status == "Connected" ? Colors.green : Colors.red,
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const Text("CURRENT READING",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                dataHistory.isNotEmpty
                    ? _buildDataRow(dataHistory.first)
                    : _buildDataRow({
                        'timestamp': '--:--:--',
                        'acc_x': 0.0,
                        'acc_y': 0.0,
                        'acc_z': 0.0,
                        'gyro_x': 0.0,
                        'gyro_y': 0.0,
                        'gyro_z': 0.0,
                        'activity': 'waiting'
                      }),
              ],
            ),
          ),
          const Divider(height: 1),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child:
                Text("HISTORY", style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: dataHistory.length,
              itemBuilder: (context, index) {
                return _buildDataRow(dataHistory[index]);
              },
            ),
          ),
        ],
      ),
    );
  }
}
