import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';

import '../auth/login_screen.dart';
import '../dashboard/providers/dashboard_provider.dart';
import '../dashboard/widgets/bottom_navbar.dart';

class ConnectivityScreen extends ConsumerStatefulWidget {
  const ConnectivityScreen({super.key});

  @override
  ConsumerState<ConnectivityScreen> createState() => _ConnectivityScreenState();
}

class _ConnectivityScreenState extends ConsumerState<ConnectivityScreen> {
  static final Guid serviceUuid = Guid('4fafc201-1fb5-459e-8fcc-c5c9c331914b');
  static final Guid provisioningCharacteristicUuid =
      Guid('beb5483e-36e1-4688-b7f5-ea07361b26a8');

  final ssidController = TextEditingController();
  final passwordController = TextEditingController();
  final deviceNameController = TextEditingController();
  final manualDeviceIdController = TextEditingController();

  ScanResult? selectedResult;
  bool provisioning = false;
  String status = 'Scan for SmartFarm_BLE, choose the ESP32, then send Wi-Fi credentials.';

  @override
  void dispose() {
    ssidController.dispose();
    passwordController.dispose();
    deviceNameController.dispose();
    manualDeviceIdController.dispose();
    super.dispose();
  }

  Future<void> requestBluetoothPermissions() async {
    await [
      Permission.bluetoothScan,
      Permission.bluetoothConnect,
      Permission.locationWhenInUse,
    ].request();
  }

  Future<void> startScan() async {
    await requestBluetoothPermissions();
    await FlutterBluePlus.stopScan();
    setState(() {
      selectedResult = null;
      status = 'Scanning for SmartFarm_BLE devices...';
    });
    await FlutterBluePlus.startScan(
      withNames: const ['SmartFarm_BLE'],
      timeout: const Duration(seconds: 10),
    );
  }

  Future<void> provisionSelectedDevice() async {
    final user = ref.read(authStateProvider).valueOrNull;

    if (user == null) {
      return;
    }

    if (ssidController.text.trim().isEmpty || passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Wi-Fi SSID and password are required.')),
      );
      return;
    }

    setState(() {
      provisioning = true;
      status = 'Connecting over BLE...';
    });

    final firebaseService = ref.read(firebaseServiceProvider);
    final fallbackDeviceId = manualDeviceIdController.text.trim().isNotEmpty
        ? manualDeviceIdController.text.trim()
        : selectedResult?.device.remoteId.str ?? '';
    final normalizedDeviceId = firebaseService.normalizeDeviceId(fallbackDeviceId);

    if (normalizedDeviceId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Select a BLE device or enter the ESP32 MAC/device ID.')),
      );
      return;
    }

    try {
      final result = selectedResult;

      if (result != null) {
        final device = result.device;
        await device.connect(timeout: const Duration(seconds: 15));
        setState(() {
          status = 'Writing provisioning payload...';
        });

        final services = await device.discoverServices();
        final provisioningService = services.firstWhere(
          (service) => service.uuid == serviceUuid,
          orElse: () => throw StateError('SmartFarm provisioning BLE service not found.'),
        );
        final characteristic = provisioningService.characteristics.firstWhere(
          (item) => item.uuid == provisioningCharacteristicUuid,
          orElse: () => throw StateError('SmartFarm provisioning BLE characteristic not found.'),
        );

        final payload = jsonEncode({
          'ssid': ssidController.text.trim(),
          'password': passwordController.text,
          'uid': user.uid,
          'deviceId': normalizedDeviceId,
          'firebaseRoot': 'devices/$normalizedDeviceId',
        });

        await characteristic.write(
          utf8.encode(payload),
          withoutResponse: false,
          allowLongWrite: true,
        );
        await device.disconnect();
      }

      await firebaseService.registerProvisionedDevice(
        deviceId: normalizedDeviceId,
        ownerUid: user.uid,
        displayName: deviceNameController.text,
        wifiSsid: ssidController.text.trim(),
      );

      ref.read(selectedDeviceIdProvider.notifier).state = normalizedDeviceId;

      setState(() {
        status = 'Provisioned $normalizedDeviceId. ESP32 can now use Wi-Fi + Firebase.';
      });
    } catch (error) {
      setState(() {
        status = error.toString();
      });
    } finally {
      if (mounted) {
        setState(() {
          provisioning = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authStateProvider);

    return authState.when(
      loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (error, _) => Scaffold(body: Center(child: Text(error.toString()))),
      data: (user) {
        if (user == null) {
          return const LoginScreen();
        }

        return Scaffold(
          appBar: AppBar(
            title: const Text('Connectivity'),
            actions: [
              IconButton(
                tooltip: 'Sign out',
                onPressed: () => ref.read(authServiceProvider).signOut(),
                icon: const Icon(Icons.logout),
              ),
            ],
          ),
          body: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'BLE Provisioning → Wi-Fi Operations',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Logged in UID: ${user.uid}\nThis UID is sent once over BLE and then stored under users/{uid}/devices.',
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: ssidController,
                decoration: const InputDecoration(
                  labelText: 'Wi-Fi SSID',
                  prefixIcon: Icon(Icons.wifi),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Wi-Fi Password',
                  prefixIcon: Icon(Icons.password),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: deviceNameController,
                decoration: const InputDecoration(
                  labelText: 'Farm / Device display name',
                  prefixIcon: Icon(Icons.badge),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: manualDeviceIdController,
                decoration: const InputDecoration(
                  labelText: 'Device ID override (MAC, optional)',
                  helperText: 'Use AA:BB:CC:11:22:33 if BLE remote ID is not the ESP32 Wi-Fi MAC.',
                  prefixIcon: Icon(Icons.memory),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: provisioning ? null : startScan,
                icon: const Icon(Icons.bluetooth_searching),
                label: const Text('Scan for ESP32'),
              ),
              const SizedBox(height: 12),
              StreamBuilder<List<ScanResult>>(
                stream: FlutterBluePlus.scanResults,
                initialData: const [],
                builder: (context, snapshot) {
                  final results = snapshot.data ?? [];

                  if (results.isEmpty) {
                    return const Text('No SmartFarm_BLE devices found yet.');
                  }

                  return Column(
                    children: results.map((result) {
                      final name = result.advertisementData.advName.isNotEmpty
                          ? result.advertisementData.advName
                          : result.device.platformName;
                      return RadioListTile<ScanResult>(
                        value: result,
                        groupValue: selectedResult,
                        onChanged: provisioning
                            ? null
                            : (value) {
                                setState(() {
                                  selectedResult = value;
                                  manualDeviceIdController.text = value?.device.remoteId.str ?? '';
                                });
                              },
                        title: Text(name.isEmpty ? 'SmartFarm ESP32' : name),
                        subtitle: Text(result.device.remoteId.str),
                      );
                    }).toList(),
                  );
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: provisioning ? null : provisionSelectedDevice,
                icon: provisioning
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.send),
                label: const Text('Send Credentials & Register Device'),
              ),
              const SizedBox(height: 16),
              Text(status),
            ],
          ),
          bottomNavigationBar: const BottomNavbar(currentIndex: 2),
        );
      },
    );
  }
}
