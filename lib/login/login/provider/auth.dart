import 'package:firebase_auth/firebase_auth.dart';
import 'package:equatable/equatable.dart';

class AuthUser extends Equatable {
  final String uid;
  final String? email;

  const AuthUser(this.uid, this.email);

  @override
  List<Object?> get props => [uid];
}

abstract class AuthRepositoryBase {
  Stream<AuthUser?> get onAuthStateChanged;

  Future<AuthUser?> signInAnonymously();

  // Future<AuthUser?> signInWithGoogle();

  Future<AuthUser?> createUserWithEmailAndPassword(
      String email, String password);

  Future<AuthUser?> signInWithEmailAndPassword(String email, String password);

  Future<void> signOut();
}

class AuthRepository extends AuthRepositoryBase {
  final _firebaseAuth = FirebaseAuth.instance;

  AuthUser? _userFromFirebase(User? user) =>
      user == null ? null : AuthUser(user.uid, user.email);

  @override
  Stream<AuthUser?> get onAuthStateChanged =>
      _firebaseAuth.authStateChanges().asyncMap(_userFromFirebase);

  @override
  Future<AuthUser?> signInAnonymously() async {
    final user = await _firebaseAuth.signInAnonymously();
    return _userFromFirebase(user.user);
  }

  @override
  Future<AuthUser?> createUserWithEmailAndPassword(
      String email, String password) async {
    final user = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
    return _userFromFirebase(user.user);
  }

  @override
  Future<AuthUser?> signInWithEmailAndPassword(
      String email, String password) async {
    final user = await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
    return _userFromFirebase(user.user);
  }

  @override
  Future<void> signOut() async {
    // await GoogleSignIn().signOut();
    await _firebaseAuth.signOut();
  }

  // @override
  // Future<AuthUser?> signInWithGoogle() async {
  //   // Trigger the authentication flow
  // // final  googleUser = await GoogleSignIn().signIn();

  // // Obtain the auth details from the request
  // final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

  // // Create a new credential
  // final credential = GoogleAuthProvider.credential(
  //   accessToken: googleAuth?.accessToken,
  //   idToken: googleAuth?.idToken,
  // );

  // // Once signed in, return the UserCredential
  // final authResult = await FirebaseAuth.instance.signInWithCredential(credential);
  // return _userFromFirebase(authResult.user);
  // }
}
