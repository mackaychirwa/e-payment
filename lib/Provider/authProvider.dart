import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

class AuthProvider with ChangeNotifier {

  final _auth = FirebaseAuth.instance;


  // Reset Password
  void resetPassword({@required BuildContext context, String email}) async {
    if (email.isNotEmpty) {
      print('Success');
      await Future.delayed(Duration(seconds: 2));
      _auth.sendPasswordResetEmail(email: email);
      Toast.show('Email sent! Please check your email to reset password.', context,
          duration: 5, gravity: Toast.CENTER);
      Navigator.pop(context);
    } else {
      print('Failed');
    }
  }


  // Resend Email Verification
  Future<void> resendEmailVerify() async{
    await Future.delayed(Duration(seconds: 2));

  }

}
