// lib/features/dashboard/widgets/bottom_navbar.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BottomNavbar extends StatelessWidget {
  final int currentIndex;

  const BottomNavbar({super.key, required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: BottomNavigationBar(
        currentIndex: currentIndex.clamp(0, 3),
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        selectedItemColor: const Color(0xFF2E7D32),
        unselectedItemColor: const Color(0xFF8A8F98),
        onTap: (index) {
          if (index == 0) context.go('/');
          if (index == 1) context.go('/valves');
          if (index == 2) context.go('/connectivity');
          if (index == 3) context.go('/admin');
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.grid_view_rounded),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.water_drop_rounded),
            label: 'Valves',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bluetooth_connected_rounded),
            label: 'Connect',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.admin_panel_settings_rounded),
            label: 'Admin',
          ),
        ],
      ),
    );
  }
}
