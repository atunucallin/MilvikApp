import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:milvikapp/components/RoundedButtonBorder.dart';
import 'package:milvikapp/components/rounded_button.dart';
import 'package:milvikapp/services/auth_services.dart';
import 'package:milvikapp/utils/constants.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

import 'choose_country_screen.dart';

class LoginScreen extends StatefulWidget {
  static const String id = 'login_screen';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool showSpinner = false;
  final _auth = FirebaseAuth.instance;
  String mobile = '', verificationId, smsCode, countryCode = '', otpCode = '';

  // bool codeSent = false;
  bool countrySent = false;
  TextEditingController controller = TextEditingController();

  createOTPdialog(BuildContext context) {
    return CupertinoAlertDialog(
      title: new Text("Dialog Title"),
      content: new Text("This is my content"),
      actions: <Widget>[
        CupertinoDialogAction(
          isDefaultAction: true,
          child: Text("Yes"),
        ),
        CupertinoDialogAction(
          child: Text("No"),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Flexible(
                child: Hero(
                  tag: 'logo',
                  child: Container(
                    height: 200.0,
                    child: Image.asset('images/logo.png'),
                  ),
                ),
              ),
              SizedBox(
                height: 48.0,
              ),
              RoundedButtonBorder(
                title: countrySent ? countryCode : 'Entry Country Code',
                onPressed: () {
                  _navigateAndDisplayCountrySelection(context);
                  //    createOTPdialog(context);
                  //  showAlertDialog(context);
                },
              ),
              SizedBox(
                height: 8.0,
              ),
              TextField(
                keyboardType: TextInputType.phone,
                textAlign: TextAlign.center,
                onChanged: (value) {
                  mobile = value;
                },
                decoration: kTextFieldDecoration.copyWith(
                    hintText: 'Enter your mobile Number'),
              ),
              SizedBox(
                height: 8.0,
              ),
              /*codeSent
                  ? TextField(
                      keyboardType: TextInputType.phone,
                      textAlign: TextAlign.center,
                      onChanged: (value) {
                        this.smsCode = value;
                      },
                      decoration: kTextFieldDecoration.copyWith(
                          hintText: 'Enter your OTP'),
                    )
                  : Container(),*/
              SizedBox(
                height: 24.0,
              ),
              /*RoundedButton(
                title: codeSent ? 'Verify' : 'Login',
                colour: Colors.lightBlueAccent,
                onPressed: () async {
                  setState(() {
                    showSpinner = true;
                  });
                  print(mobile);
                  codeSent
                      ? AuthService().signInWithOTP(
                          verId: verificationId, smsCode: smsCode)
                      : verifyMobile(mobile);
                  setState(() {
                    showSpinner = false;
                  });
                },
              ),*/
              RoundedButton(
                title: 'Login',
                colour: Colors.lightBlueAccent,
                onPressed: () async {
                  /*setState(() {
                    showSpinner = true;
                  });*/
                  print(mobile);
                  await verifyMobile(mobile);
//                  setState(() {
//                    showSpinner = false;
//                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> verifyMobile(String mobile) async {
    if (mobile.length < 10 || countryCode.isEmpty) {
      Fluttertoast.showToast(msg: 'Mobile Number cannot be empty');
      return;
    }
    setState(() {
      showSpinner = true;
    });
    mobile = countryCode + mobile;
    print('MOBILE Number Entered $mobile');

    final PhoneVerificationCompleted verified = (AuthCredential authResult) {
      AuthService().signIn(authResult);
      print('ENTEERED VERIFY MOBILE METHOD');
    };

    final PhoneVerificationFailed verificationFailed =
        (AuthException authException) {
      print(authException.message);
    };

    final PhoneCodeSent smsSent = (String verId, [int foreceResend]) {
      this.verificationId = verId;
      setState(() {
        showSpinner = false;
        //   this.codeSent = true;
        /*showAlertDialog(context).then((value) => {
              print('Final Value' + value),
              AuthService().signInWithOTP(verId: verificationId, smsCode: value)
            });*/
      });
      print('SMS SENT');
      showAlertDialog(context);
    };
    final PhoneCodeAutoRetrievalTimeout autoTimeout = (String verId) {
      this.verificationId = verId;
      print('AUTO TIME OUT');
    };

    try {
      await _auth.verifyPhoneNumber(
          phoneNumber: mobile,
          timeout: const Duration(seconds: 5),
          verificationCompleted: verified,
          verificationFailed: verificationFailed,
          codeSent: smsSent,
          codeAutoRetrievalTimeout: autoTimeout);
      print('API CALL DONE');
    } catch (e) {
      print(e);
    }
  }

  Future<String> showAlertDialog(BuildContext context) {
    showDialog(
        context: context,
        child: CupertinoAlertDialog(
          title: Text("Please Enter OTP"),
          content: Card(
            color: Colors.transparent,
            elevation: 0.0,
            child: Column(
              children: <Widget>[
                CupertinoTextField(
                  controller: controller,
                  placeholder: "Enter OTP",
                  keyboardType: TextInputType.number,
                  maxLength: 6,
                  onChanged: (v) {
                    this.smsCode = v;
                  },
                ),
              ],
            ),
          ),
          actions: <Widget>[
            CupertinoDialogAction(
                isDefaultAction: true,
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Cancel')),
            CupertinoDialogAction(
                textStyle: TextStyle(color: Colors.red),
                isDefaultAction: true,
                onPressed: () async {
                  Navigator.pop(context);
                  if (controller.text.toString().length == 6) {
                    setState(() {
                      showSpinner = true;
                    });
                    AuthService()
                        .signInWithOTP(verId: verificationId, smsCode: smsCode)
                        .catchError((error) {
                      Fluttertoast.showToast(msg: error.toString());
                      print('MOBILE Number Entered $error.toString');
                    });
                  } else {
                    print("FAKE ELSE");
                  }
                },
                child: Text('Submit')),
          ],
        ));
  }

  _navigateAndDisplayCountrySelection(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ChooseCountry()),
    );

    // After the Selection Screen returns a result, hide any previous snackbars
    // and show the new result.

    if (result != null) {
      print('COUNTRY SELECTED :: ' + result);
      setState(() {
        countryCode = result;
        this.countrySent = true;
      });
    }
  }
}
