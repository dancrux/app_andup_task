import 'package:app_andup_task/constants/styles.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

enum AuthStatus {
  uninitialized,
  initialized,
  authenticated,
  authenticating,
  unauthenticated,
}

class AuthViewModel extends ChangeNotifier {
  static final GoogleSignIn googleSignIn = GoogleSignIn();
  final FirebaseAuth _firebaseAuth;
  User? _user;

  AuthStatus _authStatus = AuthStatus.uninitialized;

  AuthStatus get authStatus => _authStatus;

  User? get user => _user;

  AuthViewModel.instance() : _firebaseAuth = FirebaseAuth.instance {
    _firebaseAuth.authStateChanges().listen(onAuthStateChanged);
  }

  Future<void> onAuthStateChanged(User? firebaseUser) async {
    if (firebaseUser == null) {
      _authStatus = AuthStatus.unauthenticated;
    } else {
      _authStatus = AuthStatus.authenticated;
    }
    notifyListeners();
  }

  static Future<FirebaseApp> initializeFirebase() async {
    FirebaseApp firebaseApp = await Firebase.initializeApp();
    return firebaseApp;
  }

  Future<User?> signInWithGoogle({required BuildContext context}) async {
    final GoogleSignInAccount? googleSignInAccount =
        await googleSignIn.signIn();

    if (googleSignInAccount != null) {
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken);

      try {
        final UserCredential userCredential =
            await _firebaseAuth.signInWithCredential(credential);
        _user = userCredential.user;
        _authStatus = AuthStatus.authenticated;
        notifyListeners();
      } on FirebaseAuthException catch (e) {
        _authStatus = AuthStatus.unauthenticated;
        notifyListeners();
        switch (e.code) {
          case 'account-exists-with-different-credential':
            ScaffoldMessenger.of(context).showSnackBar(customSnackBar(
                content:
                    'Account Mismatch please cross check, or retry with a different account'));
            break;
          case 'invalid-credential':
            ScaffoldMessenger.of(context).showSnackBar(customSnackBar(
                content:
                    'Could not sign in with selected account, try a different account'));
            break;
          default:
            ScaffoldMessenger.of(context).showSnackBar(customSnackBar(
                content: 'An Unknown Error Occured while processing'));
        }
      } catch (e) {
        _authStatus = AuthStatus.unauthenticated;
        notifyListeners();
        ScaffoldMessenger.of(context).showSnackBar(customSnackBar(
            content: 'Could not p roceed with sign in please retry'));
      }
    }
    return user;
  }

  Future<User?> registerWithEmailPassword(
      {required String name,
      required String email,
      required String password,
      required BuildContext context}) async {
    try {
      _authStatus = AuthStatus.authenticating;
      notifyListeners();
      UserCredential userCredential = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);
      _user = userCredential.user;
      await user?.updateDisplayName(name);
      await user?.reload();
      _user = _firebaseAuth.currentUser;
      _authStatus = AuthStatus.authenticated;
      notifyListeners();
    } on FirebaseAuthException catch (e) {
      _authStatus = AuthStatus.unauthenticated;
      notifyListeners();
      if (e.code == 'weak-password') {
        ScaffoldMessenger.of(context).showSnackBar(customSnackBar(
            content: 'Password is too weak, try a better combination'));
      } else if (e.code == 'email-already-in-use') {
        ScaffoldMessenger.of(context)
            .showSnackBar(customSnackBar(content: 'Email is already in use'));
      }
    } catch (e) {
      _authStatus = AuthStatus.unauthenticated;
      notifyListeners();
      ScaffoldMessenger.of(context).showSnackBar(customSnackBar(
          content: 'Something went wrong trying to sign up, please retry'));
    }
    return user;
  }

  Future<User?> signInWithEmailPassword({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    try {
      _authStatus = AuthStatus.authenticating;
      notifyListeners();
      UserCredential userCredential = await _firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);
      _user = userCredential.user;
      await user?.reload();
      _user = _firebaseAuth.currentUser;
      _authStatus = AuthStatus.authenticated;
      notifyListeners();
    } on FirebaseAuthException catch (e) {
      _authStatus = AuthStatus.unauthenticated;
      notifyListeners();
      if (e.code == 'user-not-found') {
        ScaffoldMessenger.of(context).showSnackBar(customSnackBar(
            content: 'Email does not match an existing account'));
      } else if (e.code == 'wrong-password') {
        ScaffoldMessenger.of(context)
            .showSnackBar(customSnackBar(content: 'Password is incorrect'));
      }
    }
    return user;
  }

  Future signOut(BuildContext context) async {
    try {
      await googleSignIn.signOut();
      await _firebaseAuth.signOut();
      _authStatus = AuthStatus.unauthenticated;
      notifyListeners();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          customSnackBar(content: 'Error Signing Out, Please Retry'));
    }

    return Future.delayed(Duration.zero);
  }

  static SnackBar customSnackBar({required String content}) {
    return SnackBar(
      content: Text(
        content,
        style: AppStyles.bodyText1,
      ),
    );
  }
}
