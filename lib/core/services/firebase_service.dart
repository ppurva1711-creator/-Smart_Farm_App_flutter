import 'package:firebase_database/firebase_database.dart';

class FirebaseService {

  final FirebaseDatabase database =
      FirebaseDatabase.instance;

  late final DatabaseReference deviceRef =
      database
          .ref()
          .child('devices')
          .child('farm_001');

  Stream<DatabaseEvent> deviceStream() {
    return deviceRef.onValue;
  }

  Future<void> setMotor(bool value) async {

    await deviceRef
        .child('valves')
        .child('valve1')
        .child('desiredState')
        .set(value);
  }

  Future<void> addSchedule({
    required String start,
    required String end,
  }) async {

    final id =
        'schedule_${DateTime.now().millisecondsSinceEpoch}';

    await deviceRef
        .child('schedules')
        .child(id)
        .set({

      "enabled": true,
      "start": start,
      "end": end,

      "createdAt":
          DateTime.now()
              .millisecondsSinceEpoch,
    });
  }

  Future<void> deleteSchedule(
      String scheduleId) async {

    await deviceRef
        .child('schedules')
        .child(scheduleId)
        .remove();
  }

  Future<void> toggleSchedule({
    required String scheduleId,
    required bool enabled,
  }) async {

    await deviceRef
        .child('schedules')
        .child(scheduleId)
        .child('enabled')
        .set(enabled);
  }
}