// lib/features/dashboard/widgets/sensor_grid.dart
import 'package:flutter/material.dart';

class SensorGrid extends StatelessWidget {
  final Map sensors;
  final int solarPercent;

  const SensorGrid({
    super.key,
    required this.sensors,
    required this.solarPercent,
  });

  @override
  Widget build(BuildContext context) {
    final waterUsed = (sensors['waterUsed'] ?? 0).toString();

    return Row(
      children: [
        Expanded(
          child: _card(
            icon: Icons.thermostat,
            title: 'Temperature',
            value: '${sensors['temperature'] ?? 0}°C',
            tag: 'Live',
            accent: Colors.orange,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _card(
            icon: Icons.water_drop,
            title: 'Water Used',
            value: '${waterUsed}L',
            tag: 'Usage',
            accent: Colors.blue,
          ),
        ),
      ],
    );
  }

  Widget _card({
    required IconData icon,
    required String title,
    required String value,
    required String tag,
    required Color accent,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE8D7C9)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: accent.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: accent, size: 18),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                decoration: BoxDecoration(
                  color: accent.withValues(alpha: 0.16),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(tag, style: TextStyle(color: accent, fontSize: 10)),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            title,
            style: const TextStyle(fontSize: 12, color: Color(0xFF7A746E)),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Color(0xFF4B2E1D),
            ),
          ),
        ],
      ),
    );
  }
}
