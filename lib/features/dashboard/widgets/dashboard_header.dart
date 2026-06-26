// lib/features/dashboard/widgets/dashboard_header.dart
import 'package:flutter/material.dart';

class DashboardHeader extends StatelessWidget {
  final String operatingMode;
  final String powerMode;
  final int batteryPercent;
  final int solarPercent;

  const DashboardHeader({
    super.key,
    required this.operatingMode,
    required this.powerMode,
    required this.batteryPercent,
    required this.solarPercent,
  });

  @override
  Widget build(BuildContext context) {
    final safeBattery = batteryPercent.clamp(0, 100);
    final safeSolar = solarPercent.clamp(0, 100);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          colors: [Color(0xFFC4763F), Color(0xFFD98A54)],
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x33222222),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Welcome, Farmer',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          Text(
            'Smart Irrigation Dashboard • $operatingMode / $powerMode',
            style: const TextStyle(color: Colors.white, fontSize: 12),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _meter(
                  icon: Icons.battery_full,
                  label: 'Battery (12.5V)',
                  value: safeBattery,
                  barColor: Colors.white,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _meter(
                  icon: Icons.sunny,
                  label: 'Solar Efficiency',
                  value: safeSolar,
                  barColor: const Color(0xFFF7D21B),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _meter({
    required IconData icon,
    required String label,
    required int value,
    required Color barColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: Colors.white, size: 14),
              const Spacer(),
              Text(
                '$value%',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 11,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(99),
            child: LinearProgressIndicator(
              minHeight: 6,
              value: value / 100,
              backgroundColor: Colors.white24,
              valueColor: AlwaysStoppedAnimation(barColor),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: const TextStyle(color: Colors.white, fontSize: 10),
          ),
        ],
      ),
    );
  }
}
