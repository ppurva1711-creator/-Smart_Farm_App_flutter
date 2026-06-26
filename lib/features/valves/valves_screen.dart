import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../auth/login_screen.dart';
import '../dashboard/providers/dashboard_provider.dart';
import '../dashboard/widgets/bottom_navbar.dart';
import '../dashboard/widgets/device_selector.dart';
import 'widgets/valve_card.dart';

class ValvesScreen extends ConsumerWidget {
  const ValvesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);

    return authState.when(
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (error, _) =>
          Scaffold(body: Center(child: Text(error.toString()))),
      data: (user) {
        if (user == null) {
          return const LoginScreen();
        }

        final selectedDeviceId = ref.watch(selectedDeviceIdProvider);
        final dashboardAsync = ref.watch(dashboardStreamProvider);

        return Scaffold(
          backgroundColor: const Color(0xFFF7F3EE),

          appBar: AppBar(
            title: const Text('Valves Control'),

            centerTitle: true,

            backgroundColor: Colors.orange,
            foregroundColor: Colors.white,
          ),

          body: ListView(
            padding: const EdgeInsets.all(16),

            children: [
              const DeviceSelector(),
              const SizedBox(height: 16),
              if (selectedDeviceId == null)
                const Text(
                  'Select or provision a device before controlling valves.',
                )
              else
                dashboardAsync.when(
                  data: (event) {
                    final value = event.snapshot.value;

                    if (value == null) {
                      return const Text('No valve data found for this device.');
                    }

                    final data = Map<dynamic, dynamic>.from(value as Map);
                    final valves = Map<dynamic, dynamic>.from(
                      (data['valves'] ?? {}) as Map,
                    );

                    if (valves.isEmpty) {
                      return const Text('No valves configured yet.');
                    }

                    return Column(
                      children: valves.entries.map((entry) {
                        return ValveCard(
                          deviceId: selectedDeviceId,
                          valveId: entry.key.toString(),
                          valveData: entry.value,
                        );
                      }).toList(),
                    );
                  },
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (error, _) => Text(error.toString()),
                ),
            ],
          ),

          bottomNavigationBar: const BottomNavbar(currentIndex: 1),
        );
      },
    );
  }
}
