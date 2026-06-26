// lib/features/dashboard/widgets/pump_control_card.dart
import 'package:flutter/material.dart';

import '../../../core/services/firebase_service.dart';

class PumpControlCard extends StatefulWidget {
  final bool currentDesiredState;
  final String deviceId;

  const PumpControlCard({
    super.key,
    required this.currentDesiredState,
    required this.deviceId,
  });

  @override
  State<PumpControlCard> createState() => _PumpControlCardState();
}

class _PumpControlCardState extends State<PumpControlCard> {
  final FirebaseService firebaseService = FirebaseService();
  bool loading = false;

  Future<void> _setMotor(bool value) async {
    if (loading) return;
    setState(() => loading = true);
    try {
      await firebaseService.setMotor(deviceId: widget.deviceId, value: value);
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isOn = widget.currentDesiredState;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFE7DCCB),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFD9C9B3)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.power_settings_new_rounded,
                  color: isOn ? Colors.blue : Colors.grey,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Water Pump',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Color(0xFF4B2E1D),
                      ),
                    ),
                    Text(
                      isOn ? 'Pump ON 💧' : 'Pump OFF',
                      style: const TextStyle(color: Color(0xFF5C6A78)),
                    ),
                  ],
                ),
              ),
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: isOn ? Colors.blue : Colors.grey.shade400,
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: isOn || loading ? null : () => _setMotor(true),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2E7D32),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Turn ON',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: OutlinedButton(
                  onPressed: !isOn || loading ? null : () => _setMotor(false),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.red,
                    side: const BorderSide(color: Color(0xFFFF8A80)),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    loading ? 'Syncing...' : 'Turn OFF',
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
