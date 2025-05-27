import 'dart:async';

import 'package:fitwatch/activityPage.dart';
import 'package:fitwatch/analysis.dart';
import 'package:fitwatch/dataLogs.dart';
import 'package:fitwatch/profilePage.dart';
import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import 'package:fitwatch/globals.dart' as globals;
import 'package:fitwatch/services/bluetooth_service.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

enum ConnectionType { bluetooth, mqtt }

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePage();
}

class _HomePage extends State<HomePage> {
  int currentPageIndex = 0;
  late MqttServerClient _client;
  String _status = "Disconnected";
  List<Map<String, dynamic>> _dataHistory = [];
  ConnectionType? selectedConnection;
  final FitwatchBluetoothService _bluetoothService = FitwatchBluetoothService();
  StreamSubscription? _bluetoothSubscription;

  String? _currentActivity;
  bool _isCollecting = false;

  final List<Map<String, dynamic>> _newDataBuffer = [];

  StreamSubscription<List<MqttReceivedMessage<MqttMessage>>>? _mqttSubscription;

  @override
  void initState() {
    super.initState();
    _loadSavedData();
  }

  Future<void> _loadSavedData() async {
    final prefs = await SharedPreferences.getInstance();
    final savedData = prefs.getString('sensor_data_history');
    if (savedData != null) {
      setState(() {
        _dataHistory = List<Map<String, dynamic>>.from(
            jsonDecode(savedData).map((e) => Map<String, dynamic>.from(e)));
      });
    }
  }

  Future<void> _saveData() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString('sensor_data_history', jsonEncode(_dataHistory));
  }

  Future<void> _connectToMqtt() async {
    setState(() {
      globals.isConnecting = true;
      _status = "Connecting...";
    });
    //Replace IP_ADDRESS with the actual MQTT broker IP

    _client =
        MqttServerClient.withPort('192.168.0.141', 'flutter_client', 1883);

    _client.keepAlivePeriod = 30;
    _client.onConnected = _onConnected;
    _client.onDisconnected = _onDisconnected;

    try {
      await _client.connect();
      // _client.subscribe('wearable/sensor_data', MqttQos.atLeastOnce);
      _client.subscribe('sensor/esp', MqttQos.atLeastOnce);
      _client.updates?.listen((messages) {
        final message = messages[0].payload as MqttPublishMessage;
        final payload =
            MqttPublishPayload.bytesToStringAsString(message.payload.message);
        if (!mounted) return;
        _updateData(payload);
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _status = "Connection failed";
        globals.isConnecting = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('MQTT Connection Failed')),
      );
      return;
    }
  }

  Future<void> _connectToBluetooth() async {
    setState(() {
      globals.isConnecting = true;
      _status = "Connecting...";
    });

    try {
      // Initialize Bluetooth
      bool initialized = await _bluetoothService.initialize();
      if (!initialized) {
        throw Exception("Failed to initialize Bluetooth");
      }

      // Scan for devices
      List<BluetoothDevice> devices = await _bluetoothService.scanForDevices();

      if (devices.isEmpty) {
        throw Exception("No ESP32 devices found");
      }

      // Connect to the first device
      bool connected = await _bluetoothService.connectToDevice(devices[0]);
      if (!connected) {
        throw Exception("Failed to connect to device");
      }

      // Listen to data stream
      _bluetoothSubscription = _bluetoothService.dataStream.listen((data) {
        if (!mounted) return;
        _updateData(json.encode(data));
      });

      setState(() {
        _status = "Connected";
        globals.isConnecting = false;
        globals.isConnected = true;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Bluetooth Connected")),
      );
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _status = "Connection failed";
        globals.isConnecting = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Bluetooth Connection Failed: ${e.toString()}')),
      );
    }
  }

  void _onConnected() {
    if (!mounted) return;
    setState(() {
      _status = "Connected";
      globals.isConnecting = false;
      globals.isConnected = true;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("MQTT Connected")),
    );
  }

  void _onDisconnected() {
    if (!mounted) return;
    setState(() => _status = "Disconnected");
  }

  void _startCollection(String activity) {
    setState(() {
      _currentActivity = activity;
      _isCollecting = true;
    });
  }

  void _stopCollection() {
    setState(() {
      _isCollecting = false;
      // Merge buffer with main history
      _dataHistory.insertAll(0, _newDataBuffer);
      _newDataBuffer.clear();
      _saveData();
    });
  }

  void _updateData(String payload) {
    if (!_isCollecting) return; // Critical: Ignore all data when not collecting

    try {
      final data = jsonDecode(payload) as Map<String, dynamic>;
      if (!mounted) return;
      setState(() {
        _newDataBuffer.insert(0, {
          ...data,
          'activity': _currentActivity!,
        });
      });
    } catch (e) {
      print("Data parse error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    print('ANALYSIS SCREEN DATA CHECK:');
    print(
        'Total points: ${_isCollecting ? _newDataBuffer.length + _dataHistory.length : _dataHistory.length}');
    if (_dataHistory.isNotEmpty) {
      print('First point acc_x: ${_dataHistory.first['acc_X']}');
    }
    final ThemeData theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(96, 181, 255, 1),
        actions: [
          PopupMenuButton<ConnectionType>(
              initialValue: selectedConnection,
              onSelected: (ConnectionType connection) {
                setState(() {
                  selectedConnection = connection;
                });
                if (connection == ConnectionType.mqtt) {
                  //trigger MQTT connection
                  _connectToMqtt();
                } else if (connection == ConnectionType.bluetooth) {
                  _connectToBluetooth();
                }
              },
              itemBuilder: (BuildContext context) =>
                  <PopupMenuEntry<ConnectionType>>[
                    const PopupMenuItem<ConnectionType>(
                      value: ConnectionType.mqtt,
                      child: Text('Connect via MQTT'),
                    ),
                    const PopupMenuItem<ConnectionType>(
                      value: ConnectionType.bluetooth,
                      child: Text("Connect via Bluetooth"),
                    )
                  ])
        ],
      ),
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          if (!mounted) return;
          setState(() {
            currentPageIndex = index;
          });
        },
        indicatorColor: Color.fromRGBO(96, 181, 255, 1),
        selectedIndex: currentPageIndex,
        destinations: const <Widget>[
          NavigationDestination(
            selectedIcon: Icon(
              Icons.insights,
              color: Colors.white,
            ),
            icon: Icon(Icons.insights_outlined),
            label: 'Data',
          ),
          NavigationDestination(
            selectedIcon: Icon(
              Icons.label_important,
              color: Colors.white,
            ),
            icon: Icon(Icons.label_important_outline),
            label: 'Activity',
          ),
          NavigationDestination(
              selectedIcon: Icon(
                Icons.analytics,
                color: Colors.white,
              ),
              icon: Icon(Icons.analytics_outlined),
              label: 'Analysis'),
          NavigationDestination(
            selectedIcon: Icon(
              Icons.person,
              color: Colors.white,
            ),
            icon: Icon(Icons.person_outline),
            label: 'Profile',
          ),
        ],
      ),
      body: Column(
        children: [
          if (globals.isConnecting)
            LinearProgressIndicator(
              color: Colors.white,
            ),
          Expanded(
            child: IndexedStack(
              index: currentPageIndex,
              children: [
                DataLogs(
                  dataHistory: _isCollecting
                      ? [..._newDataBuffer, ..._dataHistory]
                      : _dataHistory,
                  status: _status,
                ),
                AnnotateActivity(
                  onStart: _startCollection,
                  onStop: _stopCollection,
                ),
                AnalysisScreen(
                  dataHistory: _isCollecting
                      ? [..._newDataBuffer, ..._dataHistory]
                      : _dataHistory,
                  status: _status,
                ),
                Profile(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _mqttSubscription?.cancel();
    _bluetoothSubscription?.cancel();
    _bluetoothService.dispose();
    _client.disconnect();
    super.dispose();
  }
}
