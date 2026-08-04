import 'package:firebase_auth/firebase_auth.dart';
import '../models/model.dart';
import 'firestore_service.dart';

/// Wraps Firebase Auth. Residents sign in with phone/email + password;
/// barangay officials use the separate admin web dashboard (not this app).
class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirestoreService _firestore = FirestoreService();

  Stream<User?> get authStateChanges => _auth.authStateChanges();
  User? get currentUser => _auth.currentUser;

  Future<UserCredential> signIn({required String email, required String password}) {
    return _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  Future<UserCredential> register({
    required String email,
    required String password,
    required String fullName,
    required String purokZone,
    required String contactNumber,
  }) async {
    final credential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
    final uid = credential.user!.uid;
    await _firestore.upsertResidentProfile(
      ResidentProfile(
        uid: uid,
        fullName: fullName,
        purokZone: purokZone,
        contactNumber: contactNumber,
        role: 'resident',
      ),
    );
    return credential;
  }

  Future<void> signOut() => _auth.signOut();

  Future<void> sendPasswordReset(String email) => _auth.sendPasswordResetEmail(email: email);
}