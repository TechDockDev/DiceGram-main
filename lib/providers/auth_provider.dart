import 'dart:async';
import 'dart:developer';
import 'package:dicegram/helpers/screen_navigation.dart';
import 'package:dicegram/ui/screens/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthProvider with ChangeNotifier {
  static const LOGGED_IN = "loggedIn";
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String? _verificationCode;
  BuildContext _context;

  AuthProvider(this._context);

  Future signOut() async {
    _auth.signOut();
    notifyListeners();
    return Future.delayed(Duration.zero);
  }

  Future<void> _verifyPhone(phoneNumber) async {
    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: _verificationCompleted,
        verificationFailed: _verificationFailed,
        codeSent: _codeSent,
        codeAutoRetrievalTimeout: _codeAutoRetrievalTimeout,
        timeout: const Duration(seconds: 120));
  }

  void _codeAutoRetrievalTimeout(String verificationID) {
    _verificationCode = verificationID;
    notifyListeners();
  }

  void _verificationFailed(FirebaseAuthException e) {
    log('verification failed$e');
  }

  void _verificationCompleted(PhoneAuthCredential credential) async {
    log('Verification Completed');
    await FirebaseAuth.instance
        .signInWithCredential(credential)
        .then((value) async {
      log('Verification Completed');
      if (value.user != null) {
        changeScreen(_context, Dashboard());
      } else {
        log('Verification Incomplete...');
      }
    });
  }

  void _codeSent(String id, int? resendToken) {
    _verificationCode = id;
    notifyListeners();
  }
}
