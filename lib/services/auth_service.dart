import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

final _auth = FirebaseAuth.instance;

Stream<User?> get authStateChanges => _auth.authStateChanges();
User? get currentUser => _auth.currentUser;

Future<UserCredential> signInWithEmail(String email, String password) =>
    _auth.signInWithEmailAndPassword(email: email, password: password);

Future<UserCredential> registerWithEmail(String email, String password) =>
    _auth.createUserWithEmailAndPassword(email: email, password: password);

Future<UserCredential?> signInWithGoogle() async {
  final googleUser = await GoogleSignIn().signIn();
  if (googleUser == null) return null;
  final googleAuth = await googleUser.authentication;
  final credential = GoogleAuthProvider.credential(
    accessToken: googleAuth.accessToken,
    idToken: googleAuth.idToken,
  );
  return _auth.signInWithCredential(credential);
}

Future<void> signOut() async {
  await GoogleSignIn().signOut();
  await _auth.signOut();
}
