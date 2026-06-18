import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FirebaseService {

  FirebaseService({
    FirebaseDatabase? database,
    FirebaseAuth? auth,
  })  : database = database ?? FirebaseDatabase.instance,
        auth = auth ?? FirebaseAuth.instance;

  final FirebaseDatabase database;
  final FirebaseAuth auth;

  static const String selectedDeviceKey = 'selected_device_id';

  String get uid {
    final value = auth.currentUser?.uid;

    if (value == null) {
      throw StateError('User must be logged in before reading farm devices.');
    }

    return value;
  }

  Future<String?> selectedDeviceId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(selectedDeviceKey);
  }

  Future<void> saveSelectedDeviceId(String deviceId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(selectedDeviceKey, normalizeDeviceId(deviceId));
  }

  String normalizeDeviceId(String value) {
    return value.trim().replaceAll(':', '_').toUpperCase();
  }

  DatabaseReference deviceRef(String deviceId) {
    return database.ref('devices/${normalizeDeviceId(deviceId)}');
  }

  DatabaseReference userDeviceRef({
    required String ownerUid,
    required String deviceId,
  }) {
    return database.ref('users/$ownerUid/devices/${normalizeDeviceId(deviceId)}');
  }

  Stream<DatabaseEvent> assignedDevicesStream() {
    return database.ref('users/$uid/devices').onValue;
  }

  Stream<DatabaseEvent> allDevicesStream() {
    return database.ref('devices').onValue;
  }

   Stream<DatabaseEvent> deviceStream(String deviceId) {
    return deviceRef(deviceId).onValue;
  }

  Future<void> registerProvisionedDevice({
    required String deviceId,
    required String ownerUid,
    String? displayName,
    String? wifiSsid,
  }) async {
    final normalizedDeviceId = normalizeDeviceId(deviceId);
    final updates = <String, Object?>{
      'devices/$normalizedDeviceId/deviceId': normalizedDeviceId,
      'devices/$normalizedDeviceId/ownerUid': ownerUid,
      'devices/$normalizedDeviceId/displayName':
          displayName?.trim().isEmpty == false ? displayName!.trim() : normalizedDeviceId,
      'devices/$normalizedDeviceId/provisioning/wifiSsid': wifiSsid,
      'devices/$normalizedDeviceId/provisioning/status': 'provisioned',
      'devices/$normalizedDeviceId/provisioning/updatedAt': ServerValue.timestamp,
      'users/$ownerUid/devices/$normalizedDeviceId/deviceId': normalizedDeviceId,
      'users/$ownerUid/devices/$normalizedDeviceId/displayName':
          displayName?.trim().isEmpty == false ? displayName!.trim() : normalizedDeviceId,
      'users/$ownerUid/devices/$normalizedDeviceId/assignedAt': ServerValue.timestamp,
      'admin/devices/$normalizedDeviceId/ownerUid': ownerUid,
      'admin/devices/$normalizedDeviceId/status': 'provisioned',
      'admin/devices/$normalizedDeviceId/updatedAt': ServerValue.timestamp,
    };

    await database.ref().update(updates);
    await saveSelectedDeviceId(normalizedDeviceId);
  }

     Future<void> setMotor({
    required String deviceId,
    required bool value,
    String valveId = 'valve1',
  }) async {
    await deviceRef(deviceId)
        .child('valves')
         .child(valveId)
        .child('desiredState')
        .set(value);
  }

  Future<void> addSchedule({
    required String deviceId,
    required String start,
    required String end,
  }) async {
    final id = 'schedule_${DateTime.now().millisecondsSinceEpoch}';

    await deviceRef(deviceId).child('schedules').child(id).set({
      'enabled': true,
      'start': start,
      'end': end,
      'createdAt': ServerValue.timestamp,
    });
  }

  Future<void> deleteSchedule({
    required String deviceId,
    required String scheduleId,
  }) async {
    await deviceRef(deviceId).child('schedules').child(scheduleId).remove();
  }

  Future<void> toggleSchedule({
    required String deviceId,
    required String scheduleId,
    required bool enabled,
  }) async {

    await deviceRef(deviceId)
        .child('schedules')
        .child(scheduleId)
        .child('enabled')
        .set(enabled);
  }
}