import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dicegram/helpers/key_constants.dart';
import 'package:dicegram/helpers/user_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import 'dashboard.dart';

class OtpScreen extends StatefulWidget {
  final String _phoneNumber;
  final String _username;
  const OtpScreen(this._phoneNumber, this._username, {Key? key})
      : super(key: key);

  @override
  _OTPScreenState createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OtpScreen> {
  String? _verificationCode;
  final GlobalKey<ScaffoldState> _scaffoldkey = GlobalKey<ScaffoldState>();

  String? _otp;
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
        body: SingleChildScrollView(
      child: Container(
        height: height,
        width: width,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment(-0.5, 0.5),
            colors: [Color(0xffFCEE21), Color(0xFFFF0000)],
          ),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(40.0),
              child: Image(
                  fit: BoxFit.fill,
                  width: width,
                  image: const AssetImage('assets/images/logo2.png')),
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.all(28.0),
              child: PinCodeTextField(
                appContext: context,
                length: 6,
                obscureText: true,
                obscuringCharacter: '*',
                blinkWhenObscuring: true,
                animationType: AnimationType.fade,
                pinTheme: PinTheme(
                  shape: PinCodeFieldShape.box,
                  borderRadius: BorderRadius.circular(10),
                  fieldHeight: 50,
                  fieldWidth: 40,
                  activeFillColor: Colors.white,
                  disabledColor: Colors.white,
                  selectedColor: Colors.white,
                  activeColor: Colors.white,
                  errorBorderColor: Colors.white,
                  inactiveColor: Colors.white,
                  inactiveFillColor: Colors.white,
                  selectedFillColor: Colors.white,
                ),
                cursorColor: Colors.black,
                animationDuration: const Duration(milliseconds: 300),
                enableActiveFill: true,
                keyboardType: TextInputType.number,
                boxShadows: const [
                  BoxShadow(
                      offset: Offset(1, 1),
                      color: Colors.black38,
                      blurRadius: 8,
                      spreadRadius: 1)
                ],
                onCompleted: (v) {
                  _otp = v;
                },
                onChanged: (value) {
                  log(value);
                },
              ),
            ),
            InkWell(
                onTap: () async {
                  try {
                    await FirebaseAuth.instance
                        .signInWithCredential(PhoneAuthProvider.credential(
                            verificationId: _verificationCode!, smsCode: _otp!))
                        .then((value) async {
                      if (value.user != null) {
                        Map<String, dynamic> userData = Map();
                        userData[KeyConstants.ID] = value.user!.uid;
                        userData[KeyConstants.LAST_SEEN] =
                            FieldValue.serverTimestamp();
                        userData[KeyConstants.IMAGE_URL] = "";
                        userData[KeyConstants.CREATED_AT] =
                            FieldValue.serverTimestamp();
                        userData[KeyConstants.ONLINE] = false;
                        userData[KeyConstants.NUMBER] = value.user!.phoneNumber;
                        userData[KeyConstants.USER_NAME] = widget._username;
                        bool status = await UserServices().createUser(userData);
                        if (status) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const Dashboard()));
                        } else {
                          log('Cant save user data');
                          const snackBar = SnackBar(
                            content: Text('Cant save user data!'),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        }
                      } else {
                        FocusScope.of(context).unfocus();
                        _scaffoldkey.currentState?.showSnackBar(
                            const SnackBar(content: Text('User is null')));
                      }
                    });
                  } catch (e) {
                    FocusScope.of(context).unfocus();
                    _scaffoldkey.currentState?.showSnackBar(
                        const SnackBar(content: Text('invalid OTP')));
                  }
                },
                child: Container(
                  decoration: const BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [Color(0xFFFF1803), Color(0xffFF4A0B)]),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black38,
                          spreadRadius: 1,
                          blurRadius: 8,
                          offset: Offset(4, 8), // changes position of shadow
                        ),
                      ],
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  child: const Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 8.0, horizontal: 32),
                    child: Text(
                      'Login',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                ))
          ],
        ),
      ),
    ));
  }

  @override
  void initState() {
    super.initState();
    _verifyPhone();
  }

  void _verifyPhone() async {
    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: widget._phoneNumber,
        verificationCompleted: _verificationCompleted,
        verificationFailed: _verificationFailed,
        codeSent: _codeSent,
        codeAutoRetrievalTimeout: _codeAutoRetrievalTimeout,
        timeout: const Duration(seconds: 120));
  }

  void _codeAutoRetrievalTimeout(String verificationID) {
    setState(() {
      _verificationCode = verificationID;
    });
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
        Map<String, dynamic> userData = Map();
        userData[KeyConstants.ID] = value.user!.uid;
        userData[KeyConstants.LAST_SEEN] = FieldValue.serverTimestamp();
        userData[KeyConstants.IMAGE_URL] = "";
        userData[KeyConstants.CREATED_AT] = FieldValue.serverTimestamp();
        userData[KeyConstants.ONLINE] = false;
        userData[KeyConstants.NUMBER] = value.user!.phoneNumber;
        userData[KeyConstants.USER_NAME] = widget._username;
        bool status = await UserServices().createUser(userData);
        if (status) {
          Navigator.pushAndRemoveUntil<dynamic>(
            context,
            MaterialPageRoute<dynamic>(
              builder: (BuildContext context) => const Dashboard(),
            ),
            (route) => false, //if you want to disable back feature set to false
          );
        } else {
          log('Cant save user data');
          const snackBar = SnackBar(
            content: Text('Yay! A SnackBar!'),
          );

          // Find the ScaffoldMessenger in the widget tree
          // and use it to show a SnackBar.
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
      } else {
        log('Verification Incomplete...');
      }
    });
  }

  void _codeSent(String id, int? resendToken) {
    setState(() {
      log('Code sent');
      _verificationCode = id;
    });
  }
}
