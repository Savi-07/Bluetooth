import 'dart:async';
import 'dart:convert';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:permission_handler/permission_handler.dart';

class FitwatchBluetoothService {
  static final FitwatchBluetoothService _instance =
      FitwatchBluetoothService._internal();
  factory FitwatchBluetoothService() => _instance;
  FitwatchBluetoothService._internal();

  StreamController<Map<String, dynamic>> _dataController =
      StreamController<Map<String, dynamic>>.broadcast();
  Stream<Map<String, dynamic>> get dataStream => _dataController.stream;

  BluetoothDevice? _connectedDevice;
  BluetoothCharacteristic? _characteristic;
  bool _isConnected = false;

  bool get isConnected => _isConnected;

  Future<bool> initialize() async {
    // Request necessary permissions
    Map<Permission, PermissionStatus> statuses = await [
      Permission.bluetooth,
      Permission.bluetoothScan,
      Permission.bluetoothConnect,
      Permission.location,
    ].request();

    bool allGranted = true;
    statuses.forEach((permission, status) {
      if (!status.isGranted) {
        allGranted = false;
      }
    });

    if (!allGranted) {
      return false;
    }

    return true;
  }

  Future<List<BluetoothDevice>> scanForDevices() async {
    List<BluetoothDevice> devices = [];

    try {
      // Start scanning
      await FlutterBluePlus.startScan(timeout: Duration(seconds: 4));

      // Listen to scan results
      await for (List<ScanResult> results in FlutterBluePlus.scanResults) {
        for (ScanResult result in results) {
          if (result.device.name.contains("ESP32")) {
            if (!devices.contains(result.device)) {
              devices.add(result.device);
            }
          }
        }
      }
    } catch (e) {
      print("Error scanning for devices: $e");
    } finally {
      await FlutterBluePlus.stopScan();
    }

    return devices;
  }

  Future<bool> connectToDevice(BluetoothDevice device) async {
    try {
      await device.connect();
      _connectedDevice = device;
      _isConnected = true;

      // Discover services
      List<BluetoothService> services = await device.discoverServices();

      // Find the characteristic for sensor data
      for (BluetoothService service in services) {
        for (BluetoothCharacteristic characteristic
            in service.characteristics) {
          if (characteristic.properties.notify) {
            _characteristic = characteristic;
            await characteristic.setNotifyValue(true);
            characteristic.onValueReceived.listen((value) {
              _handleData(value);
            });
            return true;
          }
        }
      }

      return false;
    } catch (e) {
      print("Error connecting to device: $e");
      _isConnected = false;
      return false;
    }
  }

  void _handleData(List<int> value) {
    try {
      String decodedString = utf8.decode(value);
      Map<String, dynamic> data = json.decode(decodedString);
      _dataController.add(data);
    } catch (e) {
      print("Error handling data: $e");
    }
  }

  Future<void> disconnect() async {
    if (_connectedDevice != null) {
      await _connectedDevice!.disconnect();
      _connectedDevice = null;
      _characteristic = null;
      _isConnected = false;
    }
  }

  void dispose() {
    _dataController.close();
  }
}
