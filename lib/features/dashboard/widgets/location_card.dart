// lib/features/dashboard/widgets/location_card.dart
import 'package:flutter/material.dart';

class LocationCard extends StatelessWidget {
  final Map location;

  const LocationCard({
    super.key,
    required this.location,
  });

  @override
  Widget build(BuildContext context) {
    final lat = location['lat']?.toString() ?? '--';
    final lng = location['lng']?.toString() ?? '--';
    final speed = location['speedKmph']?.toString() ?? '0';
    final satellites = location['satellites']?.toString() ?? '0';
    final status = location['status']?.toString() ?? 'Unknown';

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE6D8C8)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Device Location', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 10),
          _row('Latitude', lat),
          _row('Longitude', lng),
          _row('Speed', '$speed km/h'),
          _row('Satellites', satellites),
          _row('Status', status),
        ],
      ),
    );
  }

  Widget _row(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(color: Color(0xFF7A746E))),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}