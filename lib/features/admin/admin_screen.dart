import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../auth/login_screen.dart';
import '../dashboard/providers/dashboard_provider.dart';
import '../dashboard/widgets/bottom_navbar.dart';

class AdminScreen extends ConsumerWidget {
  const AdminScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);
    final isAdmin = ref.watch(isAdminProvider);
    final devices = ref.watch(allDevicesProvider);

    return authState.when(
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (error, _) =>
          Scaffold(body: Center(child: Text(error.toString()))),
      data: (user) {
        if (user == null) {
          return const LoginScreen();
        }

        return Scaffold(
          appBar: AppBar(
            title: const Text('Admin Devices'),
            actions: [
              IconButton(
                tooltip: 'Sign out',
                onPressed: () => ref.read(authServiceProvider).signOut(),
                icon: const Icon(Icons.logout),
              ),
            ],
          ),
          body: isAdmin.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, _) => Center(child: Text(error.toString())),
            data: (allowed) {
              if (!allowed) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(24),
                    child: Text(
                      'This login is not marked as an admin. Add admins/{uid}: true in Firebase to view all hardware.',
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
              }

              return devices.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, _) => Center(child: Text(error.toString())),
                data: (event) {
                  final value = event.snapshot.value;

                  if (value == null) {
                    return const Center(
                      child: Text('No devices provisioned yet.'),
                    );
                  }

                  final data = Map<dynamic, dynamic>.from(value as Map);

                  return ListView(
                    padding: const EdgeInsets.all(16),
                    children: data.entries.map((entry) {
                      final device = Map<dynamic, dynamic>.from(
                        entry.value as Map,
                      );
                      final ownerUid =
                          device['ownerUid']?.toString() ?? 'Unknown owner';
                      final displayName =
                          device['displayName']?.toString() ??
                          entry.key.toString();
                      final status = device['provisioning'] is Map
                          ? Map<dynamic, dynamic>.from(
                              device['provisioning'] as Map,
                            )['status']
                          : 'unknown';

                      return Card(
                        child: ListTile(
                          leading: const Icon(Icons.developer_board),
                          title: Text(displayName),
                          subtitle: Text(
                            'Device: ${entry.key}\nOwner UID: $ownerUid\nStatus: $status',
                          ),
                          isThreeLine: true,
                        ),
                      );
                    }).toList(),
                  );
                },
              );
            },
          ),
          bottomNavigationBar: const BottomNavbar(currentIndex: 3),
        );
      },
    );
  }
}
