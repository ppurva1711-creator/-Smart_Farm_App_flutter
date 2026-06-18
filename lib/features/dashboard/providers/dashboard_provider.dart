import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/services/auth_service.dart';

import '../../../core/services/firebase_service.dart';

final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService();
});
final firebaseServiceProvider = Provider<FirebaseService>((ref) {
  return FirebaseService();
});

final authStateProvider = StreamProvider<User?>((ref) {
  return ref.watch(authServiceProvider).authStateChanges();
});

final isAdminProvider = FutureProvider<bool>((ref) {
  final authState = ref.watch(authStateProvider).valueOrNull;

  if (authState == null) {
    return false;
  }

  return ref.watch(authServiceProvider).isCurrentUserAdmin();
});

final selectedDeviceIdProvider = StateProvider<String?>((ref) {
  return null;
});

final persistedSelectedDeviceProvider = FutureProvider<String?>((ref) {
  return ref.watch(firebaseServiceProvider).selectedDeviceId();
});

 final assignedDevicesProvider = StreamProvider<DatabaseEvent>((ref) {
  final user = ref.watch(authStateProvider).valueOrNull;

  if (user == null) {
    return const Stream.empty();
  }

  return ref.watch(firebaseServiceProvider).assignedDevicesStream();
});

final dashboardStreamProvider = StreamProvider<DatabaseEvent>((ref) {
  final deviceId = ref.watch(selectedDeviceIdProvider);

  if (deviceId == null || deviceId.isEmpty) {
    return const Stream.empty();
  }

  return ref.watch(firebaseServiceProvider).deviceStream(deviceId);
});

final allDevicesProvider = StreamProvider<DatabaseEvent>((ref) {
  final isAdmin = ref.watch(isAdminProvider).valueOrNull ?? false;

  if (!isAdmin) {
    return const Stream.empty();
  }

  return ref.watch(firebaseServiceProvider).allDevicesStream();
});