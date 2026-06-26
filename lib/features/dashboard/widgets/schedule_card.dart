// lib/features/dashboard/widgets/schedule_card.dart
import 'package:flutter/material.dart';

import '../../../core/services/firebase_service.dart';

class ScheduleCard extends StatefulWidget {
  final Map schedules;
  final String deviceId;

  const ScheduleCard({
    super.key,
    required this.schedules,
    required this.deviceId,
  });

  @override
  State<ScheduleCard> createState() => _ScheduleCardState();
}

class _ScheduleCardState extends State<ScheduleCard> {
  final FirebaseService firebaseService = FirebaseService();

  TimeOfDay? startTime;
  TimeOfDay? endTime;

  Future<void> _pickStartTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) setState(() => startTime = picked);
  }

  Future<void> _pickEndTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) setState(() => endTime = picked);
  }

  Future<void> _showAddDialog() async {
    startTime = null;
    endTime = null;

    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: const Text('Add Schedule'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              onPressed: _pickStartTime,
              child: Text(
                startTime == null
                    ? 'Select Start Time'
                    : startTime!.format(context),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _pickEndTime,
              child: Text(
                endTime == null ? 'Select End Time' : endTime!.format(context),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (startTime == null || endTime == null) return;
              await firebaseService.addSchedule(
                deviceId: widget.deviceId,
                start: startTime!.format(context),
                end: endTime!.format(context),
              );
              if (mounted) Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final entries = widget.schedules.entries.toList();

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
          Row(
            children: [
              const Icon(Icons.schedule_rounded, color: Colors.deepPurple),
              const SizedBox(width: 8),
              const Expanded(
                child: Text(
                  'Pump Schedule',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ),
              ElevatedButton(
                onPressed: _showAddDialog,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Add'),
              ),
            ],
          ),
          const SizedBox(height: 10),
          if (entries.isEmpty)
            const Text(
              'No schedules yet.',
              style: TextStyle(color: Color(0xFF6C7278)),
            ),
          ...entries.map((entry) {
            final scheduleId = entry.key.toString();
            final schedule = Map<dynamic, dynamic>.from(
              entry.value is Map ? entry.value as Map : {},
            );
            final enabled = schedule['enabled'] == true;
            final start = schedule['start']?.toString() ?? '--:--';
            final end = schedule['end']?.toString() ?? '--:--';

            return Container(
              margin: const EdgeInsets.only(top: 10),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: enabled
                    ? const Color(0xFFF2ECFF)
                    : const Color(0xFFF2F3F5),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      '$start → $end',
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                  ),
                  Switch(
                    value: enabled,
                    onChanged: (value) async {
                      await firebaseService.toggleSchedule(
                        deviceId: widget.deviceId,
                        scheduleId: scheduleId,
                        enabled: value,
                      );
                    },
                  ),
                  IconButton(
                    onPressed: () async {
                      await firebaseService.deleteSchedule(
                        deviceId: widget.deviceId,
                        scheduleId: scheduleId,
                      );
                    },
                    icon: const Icon(
                      Icons.delete_outline_rounded,
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
