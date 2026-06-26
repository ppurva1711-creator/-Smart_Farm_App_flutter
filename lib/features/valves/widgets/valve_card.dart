// lib/features/valves/widgets/valve_card.dart
import 'package:flutter/material.dart';
import '../../../core/services/firebase_service.dart';

class ValveCard extends StatefulWidget {
  final String deviceId;
  final String valveId;
  final Map<dynamic, dynamic> valveData;

  const ValveCard({
    super.key,
    required this.deviceId,
    required this.valveId,
    required this.valveData,
  });

  @override
  State<ValveCard> createState() => _ValveCardState();
}

class _ValveCardState extends State<ValveCard> {
  final FirebaseService firebaseService = FirebaseService();

  bool loading = false;

  Future<void> _toggleValve(bool nextState) async {
    if (loading) return;
    setState(() => loading = true);
    try {
      await firebaseService.setMotor(
        deviceId: widget.deviceId,
        valveId: widget.valveId,
        value: nextState,
      );
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final valveMap = Map<dynamic, dynamic>.from(widget.valveData as Map);
    final bool desiredState = valveMap['desiredState'] == true;
    final bool hardwareState = valveMap['hardwareState'] == true;

    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: hardwareState
              ? const Color(0xFFB7E4C7)
              : const Color(0xFFF5C2C7),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: (hardwareState ? Colors.green : Colors.red)
                    .withValues(alpha: 0.12),
                child: Icon(
                  Icons.tune_rounded,
                  color: hardwareState ? Colors.green : Colors.red,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  widget.valveId.toUpperCase(),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              Text(
                hardwareState ? 'OPEN' : 'CLOSED',
                style: TextStyle(
                  color: hardwareState ? Colors.green : Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: loading ? null : () => _toggleValve(!desiredState),
              style: ElevatedButton.styleFrom(
                backgroundColor: desiredState ? Colors.red : Colors.green,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              child: Text(
                loading
                    ? 'Syncing...'
                    : (desiredState ? 'TURN OFF' : 'TURN ON'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
