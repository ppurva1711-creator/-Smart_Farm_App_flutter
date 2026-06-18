// lib/features/dashboard/dashboard_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../auth/login_screen.dart';
import 'providers/dashboard_provider.dart';
import 'widgets/bottom_navbar.dart';
import 'widgets/dashboard_header.dart';
import 'widgets/device_selector.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
 Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);
    final persistedDevice = ref.watch(persistedSelectedDeviceProvider);

    persistedDevice.whenData((deviceId) {
      final selected = ref.read(selectedDeviceIdProvider);

      if (selected == null && deviceId != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          ref.read(selectedDeviceIdProvider.notifier).state = deviceId;
        });
      }
    });

    return authState.when(
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator())),
      error: (error, _) => Scaffold(
        body: Center(child: Text(error.toString())),),
      data: (user) {
        if (user == null) {
          return const LoginScreen();
        }

         final dashboardAsync = ref.watch(dashboardStreamProvider);
        final sensors = Map<dynamic, dynamic>.from(data['sensors'] is Map ? data['sensors'] as Map : {});
        final schedules = Map<dynamic, dynamic>.from(data['schedules'] is Map ? data['schedules'] as Map : {});
        final location = Map<dynamic, dynamic>.from(data['location'] is Map ? data['location'] as Map : {});
        final valves = Map<dynamic, dynamic>.from(data['valves'] is Map ? data['valves'] as Map : {});
        final waterUsage = Map<dynamic, dynamic>.from(data['waterUsage'] is Map ? data['waterUsage'] as Map : {});

        final valve1 = Map<dynamic, dynamic>.from(valves['valve1'] is Map ? valves['valve1'] as Map : {});
        final desiredState = valve1['desiredState'] == true;

        final solarPercent = (data['solarPercent'] as num?)?.toInt() ?? 0;
        final operatingMode = data['operatingMode']?.toString() ?? 'Unknown';
        final powerMode = data['powerMode']?.toString() ?? 'Unknown';

        return Scaffold(
          appBar: AppBar( title: const Text('Smart Farm'),
            actions: [
              IconButton(
                tooltip: 'Sign out',
                onPressed: () => ref.read(authServiceProvider).signOut(),
                icon: const Icon(Icons.logout),
              ),
            ],),

           body: Padding(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFFFFF8F1), Color(0xFFFFFCFA)],
              ),
            ),
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                DashboardHeader(
                  operatingMode: operatingMode,
                  powerMode: powerMode,
                  batteryPercent: (sensors['battery'] as num?)?.toInt() ?? 0,
                  solarPercent: solarPercent,
                ),
                const SizedBox(height: 14),
                SensorGrid(
                  sensors: sensors,
                  solarPercent: solarPercent,
                  waterUsedLitres: (waterUsage['totalLitres'] as num?)?.toDouble() ?? 0,
                  currentFlowRate: (waterUsage['currentFlowRate'] as num?)?.toDouble() ?? 0,
                ),
                const SizedBox(height: 14),
                PumpControlCard(currentDesiredState: desiredState),
                const SizedBox(height: 14),
                PowerSourceCard(powerMode: powerMode, solarPercent: solarPercent),
                const SizedBox(height: 14),
                ScheduleCard(schedules: schedules),
                const SizedBox(height: 14),
                LocationCard(location: location),
              ],
            ),
          ),
          bottomNavigationBar: const BottomNavbar(currentIndex: 0),
        );
      },
    );
  }
}