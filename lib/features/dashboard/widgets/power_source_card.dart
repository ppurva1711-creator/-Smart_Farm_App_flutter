// lib/features/dashboard/widgets/power_source_card.dart
import 'package:flutter/material.dart';

class PowerSourceCard extends StatelessWidget {
  final String powerMode;
  final int solarPercent;

  const PowerSourceCard({
    super.key,
    required this.powerMode,
    required this.solarPercent,
  });

  @override
  Widget build(BuildContext context) {
    final isSolar =
        powerMode.toLowerCase().contains('solar') ||
        powerMode.toLowerCase().contains('auto');

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE6D8C8)),
      ),
      child: Row(
        children: [
          const Text(
            'Power Source',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
              color: Color(0xFF4B2E1D),
            ),
          ),
          const SizedBox(width: 10),
          Text(
            isSolar ? 'AUTO (Solar)' : 'MANUAL (Battery)',
            style: const TextStyle(fontSize: 12, color: Color(0xFF57738C)),
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: isSolar
                  ? const Color(0xFF22C55E)
                  : const Color(0xFF64748B),
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              '$solarPercent%',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 11,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
