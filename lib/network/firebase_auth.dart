import 'package:app_andup_task/constants/styles.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseAuthentication {
  static FirebaseAuth auth = FirebaseAuth.instance;
  static User? user;
  static final GoogleSignIn googleSignIn = GoogleSignIn();

  static Future<FirebaseApp> initializeFirebase() async {
    FirebaseApp firebaseApp = await Firebase.initializeApp();
    return firebaseApp;
  }

  static Future<User?> signInWithGoogle({required BuildContext context}) async {
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
            await auth.signInWithCredential(credential);
        user = userCredential.user;
      } on FirebaseAuthException catch (e) {
        if (e.code == 'account-exists-with-different-credential') {
          ScaffoldMessenger.of(context).showSnackBar(customSnackBar(
              content:
                  'Account Mismatch please cross check, or retry with a different account'));
        } else if (e.code == 'invalid-credential') {
          ScaffoldMessenger.of(context).showSnackBar(customSnackBar(
              content:
                  'Could not sign in with selected account, try a different account'));
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(customSnackBar(
            content: 'Could not proceed with sign in please retry'));
      }
    }
    return user;
  }

  static Future<User?> registerWithEmailPassword(
      {required String name,
      required String email,
      required String password,
      required BuildContext context}) async {
    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
          email: email, password: password);
      user = userCredential.user;
      await user?.updateDisplayName(name);
      await user?.reload();
      user = auth.currentUser;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        ScaffoldMessenger.of(context).showSnackBar(customSnackBar(
            content: 'Password is too weak, try a better combination'));
      } else if (e.code == 'email-already-in-use') {
        ScaffoldMessenger.of(context)
            .showSnackBar(customSnackBar(content: 'Email is already in use'));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(customSnackBar(
          content: 'Something went wrong trying to sign up, please retry'));
    }
    return user;
  }

  static Future<User?> signInWithEmailPassword({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
          email: email, password: password);
      user = userCredential.user;
      await user?.reload();
      user = auth.currentUser;
    } on FirebaseAuthException catch (e) {
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

  static Future<void> signOut(BuildContext context) async {
    try {
      await googleSignIn.signOut();
      await auth.signOut();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          customSnackBar(content: 'Error Signing Out, Please Retry'));
    }
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
