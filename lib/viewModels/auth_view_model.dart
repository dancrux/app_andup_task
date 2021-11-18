import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

enum AuthStatus {
  uninitialized,
  initialized,
  authenticated,
  authenticating,
  unauthenticated,
}

class AuthViewModel extends ChangeNotifier {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  AuthStatus _authStatus = AuthStatus.uninitialized;

  AuthStatus get authStatus => _authStatus;

  AuthViewModel() {
    _firebaseAuth.authStateChanges().listen(onAuthStateChanged);
  }

  // Future<FirebaseApp> _initializeFirebase() async {
  //   User? user = _firebaseAuth.currentUser;

  //   // if (user != null) {
  //   //   Navigator.of(context).pushReplacement(
  //   //     MaterialPageRoute(
  //   //       builder: (context) => const HomeScreen(),
  //   //     ),
  //   //   );
  //   // }

  //   return firebaseApp;
  // }

  Future<void> onAuthStateChanged(User? firebaseUser) async {
    await Firebase.initializeApp();
    _authStatus = AuthStatus.initialized;
    if (firebaseUser == null) {
      _authStatus = AuthStatus.unauthenticated;
    } else {
      _authStatus = AuthStatus.authenticated;
    }
    notifyListeners();
  }
}
