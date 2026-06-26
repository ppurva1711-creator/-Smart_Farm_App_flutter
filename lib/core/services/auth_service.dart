import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class AuthService {
  AuthService({FirebaseAuth? auth, FirebaseDatabase? database})
    : _auth = auth ?? FirebaseAuth.instance,
      _database = database ?? FirebaseDatabase.instance;

  final FirebaseAuth _auth;
  final FirebaseDatabase _database;

  Stream<User?> authStateChanges() {
    return _auth.authStateChanges();
  }

  User? get currentUser => _auth.currentUser;

  Future<UserCredential> signIn({
    required String email,
    required String password,
  }) async {
    return _auth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
  }

  Future<UserCredential> registerUser({
    required String email,
    required String password,
    required String name,
  }) async {
    final credential = await _auth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );

    final uid = credential.user!.uid;
    await _database.ref('users/$uid/profile').set({
      'email': email.trim(),
      'name': name.trim(),
      'role': 'farmer',
      'createdAt': ServerValue.timestamp,
    });

    return credential;
  }

  Future<bool> isCurrentUserAdmin() async {
    final uid = currentUser?.uid;

    if (uid == null) {
      return false;
    }

    final adminSnapshot = await _database.ref('admins/$uid').get();

    if (adminSnapshot.value == true) {
      return true;
    }

    final roleSnapshot = await _database.ref('users/$uid/profile/role').get();
    return roleSnapshot.value == 'admin';
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}
