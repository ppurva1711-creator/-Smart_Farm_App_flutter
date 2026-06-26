import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/dashboard_provider.dart';

class DeviceSelector extends ConsumerWidget {
  const DeviceSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final devicesAsync = ref.watch(assignedDevicesProvider);
    final selectedDeviceId = ref.watch(selectedDeviceIdProvider);

    return devicesAsync.when(
      loading: () => const LinearProgressIndicator(),
      error: (error, _) => Text(error.toString()),
      data: (event) {
        final value = event.snapshot.value;

        if (value == null) {
          return Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'No device connected yet',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Open the Connectivity tab to provision an ESP32 with BLE and assign it to this login.',
                  ),
                ],
              ),
            ),
          );
        }

        final devices = Map<dynamic, dynamic>.from(value as Map);
        final ids = devices.keys.map((key) => key.toString()).toList();
        final safeSelected = ids.contains(selectedDeviceId)
            ? selectedDeviceId
            : ids.first;

        if (selectedDeviceId != safeSelected) {
          WidgetsBinding.instance.addPostFrameCallback((_) async {
            ref.read(selectedDeviceIdProvider.notifier).state = safeSelected;
            await ref
                .read(firebaseServiceProvider)
                .saveSelectedDeviceId(safeSelected);
          });
        }

        return DropdownButtonFormField<String>(
          value: safeSelected,
          decoration: const InputDecoration(
            labelText: 'Active ESP32 device',
            prefixIcon: Icon(Icons.developer_board),
          ),
          items: ids.map((deviceId) {
            final device = Map<dynamic, dynamic>.from(devices[deviceId] as Map);
            final name = device['displayName']?.toString() ?? deviceId;

            return DropdownMenuItem<String>(
              value: deviceId,
              child: Text('$name ($deviceId)'),
            );
          }).toList(),
          onChanged: (deviceId) async {
            if (deviceId == null) {
              return;
            }

            ref.read(selectedDeviceIdProvider.notifier).state = deviceId;
            await ref
                .read(firebaseServiceProvider)
                .saveSelectedDeviceId(deviceId);
          },
        );
      },
    );
  }
}
