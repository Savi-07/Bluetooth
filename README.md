1. Make sure your ESP32 is configured to send data over Bluetooth with the same format as it does over MQTT.
  -The data should be JSON formatted with the same fields (acc_X, acc_Y, acc_Z, gyro_X, gyro_Y, gyro_Z).
   
2.On your ESP32, you'll need to:
  -Set up a Bluetooth Low Energy (BLE) server
  -Create a characteristic with the UUID "0000FFE1-0000-1000-8000-00805F9B34FB" (or update the UUID in the code to match your ESP32's UUID)
  -Send the sensor data through this characteristic
  
3.In the Flutter app:
  -Click the menu button in the top-right corner
  -Select "Connect via Bluetooth"
  -The app will scan for ESP32 devices and connect to the first one it finds
  -Once connected, you can start collecting data just like with MQTT

  













This repository contains the Flutter app code for the **TinyML** project. The app uses the **MQTT protocol** to communicate with a **wearable fit watch** and fetch sensor data. This README provides instructions on how to set up and configure the app to mimic its behavior locally.

---

## Prerequisites

Before running the app, make sure you have the following installed:

- [Flutter](https://flutter.dev/docs/get-started/install) (latest stable version)
- [Dart](https://dart.dev/get-dart)
- [MQTT Broker](#)
  - You will need a running MQTT broker. Get the broker IP address.
- **Visual Studio Code** (VS Code) with the following extensions:
  - [Flutter](https://marketplace.visualstudio.com/items?itemName=Dart-Code.flutter)
  - [Dart](https://marketplace.visualstudio.com/items?itemName=Dart-Code.dart-code)
---

## Setup

1. **Clone the repository** to your local machine:

    ```bash
    git clone https://github.com/T-Soni/TinyML.git
    cd fitwatch/
    ```

2. **Install dependencies:**

    Inside your project directory, run the following command to install all necessary Flutter dependencies:

    ```bash
    flutter pub get
    ```

3. **Set up the MQTT Broker Configuration:**

    You need to replace certain values in the code to connect the app with the correct MQTT broker and topic.

    - **Broker IP Address:**
      - Open `lib/home.dart`
      - Replace `'IP_ADDRESS'` with the actual IP address of your MQTT broker:

        ```dart
        _client = MqttServerClient.withPort('IP_ADDRESS', 'flutter_client', 1883);
        ```

    - **MQTT Topic:**
      - Open `lib/home.dart`
      - Replace `'wearable/sensor_data'` with the topic your wearable device publishes to:

        ```dart
        _client.subscribe('wearable/sensor_data', MqttQos.atLeastOnce);
        ```

      **Note:** This should be the topic configured in your MQTT broker that corresponds to the wearable device's data.

4. **Run the app:**

    After updating the broker and topic, you can run the app on your device or emulator:

    ```bash
    flutter run
    ```

---

## Project Structure

The project consists of the following key components:

- **lib/home.dart**: Handles the MQTT communication for fetching data from the wearable device.
- **lib/main.dart**: Main entry point of the app
- **pubspec.yaml**: Lists all dependencies and app settings.

---

## Configuration

### MQTT Broker

- Replace `'IP_ADDRESS'` with the **IP address** or **hostname** of your MQTT broker.
- Make sure your broker is accessible and running.

### MQTT Topic

- Replace `'wearable/sensor_data'` with the **topic** that the wearable device is publishing data to. This is configured on the broker.

---


