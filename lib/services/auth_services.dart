

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthService {
  // handles Auth
  final _auth = FirebaseAuth.instance;



  Future<void> signOut() async {
    await _auth.signOut();
  }

  // Sign in
  Future<void> signIn(AuthCredential authCredential) async {
    await FirebaseAuth.instance.signInWithCredential(authCredential);
  }



  Future<void> signInWithOTP({@required verId, @required smsCode}) async {
    AuthCredential authCredential = PhoneAuthProvider.getCredential(
        verificationId: verId, smsCode: smsCode);
    await signIn(authCredential);
  }
}