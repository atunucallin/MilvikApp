import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:milvikapp/screens/home_screen.dart';
import 'package:milvikapp/screens/login_screen.dart';

class AuthService {
  // handles Auth
  final _auth = FirebaseAuth.instance;

  handleAuth() {
    return StreamBuilder(
      stream: FirebaseAuth.instance.onAuthStateChanged,
      builder: (BuildContext context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          FirebaseUser user = snapshot.data;
          if (user == null) {
            return LoginScreen();
          }
          return Dashboard();
        } else {
          return Scaffold(
            body: Center(
              child: Container(
                height: 200.0,
                child: Image.asset('images/logo.png'),
              ),
            ),
          );
        }
      },
    );
  }

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
