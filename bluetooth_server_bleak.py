import asyncio
from bleak import BleakScanner, BleakClient
import json
import time

# UUID for the characteristic that ESP32 will use to send data
SENSOR_DATA_CHARACTERISTIC_UUID = "0000FFE1-0000-1000-8000-00805F9B34FB"  # This is a standard UUID, adjust if your ESP32 uses a different one

class BLEServer:
    def __init__(self):
        self.client = None
        self.is_connected = False
        self.data_callback = None

    async def scan_for_devices(self):
        print("Scanning for BLE devices...")
        devices = await BleakScanner.discover()
        esp32_devices = [d for d in devices if "ESP32" in d.name]
        return esp32_devices

    async def connect_to_device(self, device):
        try:
            self.client = BleakClient(device)
            await self.client.connect()
            self.is_connected = True
            print(f"Connected to {device.name}")
            
            # Start notification handler
            await self.client.start_notify(
                SENSOR_DATA_CHARACTERISTIC_UUID,
                self.notification_handler
            )
            return True
        except Exception as e:
            print(f"Connection failed: {e}")
            return False

    def notification_handler(self, sender, data):
        try:
            # Decode the received data
            decoded_data = data.decode('utf-8')
            # Parse the JSON data
            sensor_data = json.loads(decoded_data)
            
            # Add timestamp
            sensor_data['timestamp'] = time.strftime('%Y-%m-%d %H:%M:%S')
            
            # If there's a callback function, call it with the data
            if self.data_callback:
                self.data_callback(sensor_data)
                
        except Exception as e:
            print(f"Error processing data: {e}")

    def set_data_callback(self, callback):
        self.data_callback = callback

    async def disconnect(self):
        if self.client and self.is_connected:
            await self.client.disconnect()
            self.is_connected = False
            print("Disconnected from device")

async def main():
    server = BLEServer()
    
    # Example callback function
    def handle_data(data):
        print(f"Received data: {data}")
    
    server.set_data_callback(handle_data)
    
    # Scan for devices
    devices = await server.scan_for_devices()
    
    if devices:
        # Connect to the first ESP32 device found
        await server.connect_to_device(devices[0])
        
        # Keep the connection alive
        try:
            while True:
                await asyncio.sleep(1)
        except KeyboardInterrupt:
            await server.disconnect()
    else:
        print("No ESP32 devices found")

if __name__ == "__main__":
    asyncio.run(main())
