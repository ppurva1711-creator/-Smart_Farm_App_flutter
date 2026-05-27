import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:firebase_database/firebase_database.dart';

import '../../../core/services/firebase_service.dart';

final firebaseServiceProvider =
    Provider<FirebaseService>((ref) {

  return FirebaseService();
});

final dashboardStreamProvider =
    StreamProvider<DatabaseEvent>((ref) {

  final firebaseService =
      ref.watch(
    firebaseServiceProvider,
  );

  return firebaseService
      .deviceStream();
});