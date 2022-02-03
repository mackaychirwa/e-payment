import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/auth_strings.dart';
import 'package:local_auth/local_auth.dart';

// import 'package:mbpayment/screens/transactionhistory/transaction_history.dart';
import 'package:toast/toast.dart';
import 'package:total_load_up/CustomWidgets/Widgets.dart';
import 'package:total_load_up/screens/Profile.dart';
import 'package:total_load_up/screens/homeScreen.dart';

class Account extends StatelessWidget {
  GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();
  final auth = FirebaseAuth.instance;
  final user = FirebaseAuth.instance.currentUser;
  LocalAuthentication _fingerauth = LocalAuthentication();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: _globalKey,
        drawer: Drawer(
          child: ineyo(),
        ),
        appBar: AppBar(
          backgroundColor: Colors.blue[600],
          elevation: 0.0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            iconSize: 28.0,
            onPressed: () {},
          ),
          title: Text('Profile'),
          centerTitle: true,
        ),
        body: Scaffold(
          resizeToAvoidBottomInset: false,
          body: Stack(
            children: [
              Center(
                child: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                    stream: FirebaseFirestore.instance
                        .collection('Users')
                        .doc(user.uid)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return CircularProgressIndicator();
                      } else {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            SizedBox(height: 13),
                            Container(
                              margin: EdgeInsets.symmetric(vertical: 10),
                              child: Row(
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.all(10),
                                  ),
                                  Expanded(child: Divider()),
                                ],
                              ),
                            ),
                            Text(
                              'Avatar:',
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 10),
                            ClipOval(
                              child: Image.network(
                                '${snapshot.data.data()['avatar'].toString()}',
                                width: 90,
                                height: 90,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.symmetric(vertical: 10),
                              child: Row(
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.all(10),
                                  ),
                                  Expanded(child: Divider()),
                                ],
                              ),
                            ),
                            Text(
                              'Name:',
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                            Text(
                              '${snapshot.data.data()['fullname'].toString()}',
                              style: TextStyle(fontSize: 15),
                              textAlign: TextAlign.center,
                            ),
                            Container(
                              margin: EdgeInsets.symmetric(vertical: 10),
                              child: Row(
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.all(10),
                                  ),
                                  Expanded(child: Divider()),
                                ],
                              ),
                            ),
                            Text(
                              'Email:',
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                            Text(
                              '${user.email}',
                              style: TextStyle(fontSize: 15),
                              textAlign: TextAlign.center,
                            ),
                            Container(
                              margin: EdgeInsets.symmetric(vertical: 10),
                              child: Row(
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.all(10),
                                  ),
                                  Expanded(child: Divider()),
                                ],
                              ),
                            ),
                            Text(
                              'User Id:',
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                            Text(
                              '${user.uid}',
                              style: TextStyle(fontSize: 15),
                              textAlign: TextAlign.center,
                            ),
                            Container(
                              margin: EdgeInsets.symmetric(vertical: 10),
                              child: Row(
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.all(10),
                                  ),
                                  Expanded(child: Divider()),
                                ],
                              ),
                            ),
                            ElevatedButton(
                                child: Text(
                                  'Edit Profile',
                                  style: TextStyle(color: Colors.white),
                                ),
                                onPressed: () async {
                                  // if (_startFingerAuth() != "Failed") {
                                  PushReplaceTo(context, Profile());
                                  // } else {
                                  //   Toast.show(
                                  //       'Failed to authenticate', context,
                                  //       duration: 5, gravity: Toast.CENTER);
                                  // }
                                }),
                          ],
                        );
                      }
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<String> _startFingerAuth() async {
    bool _isAuthenticated = false;
    AndroidAuthMessages _androidMsg = AndroidAuthMessages(
      biometricHint: 'To edit your profile please authenticate',
      cancelButton: 'Close',
    );
    try {
      _isAuthenticated = await _fingerauth.authenticate(
        localizedReason: 'Please scan your biometric or use PIN to continue',
        useErrorDialogs: true,
        stickyAuth: true,
        androidAuthStrings: _androidMsg,
      );
    } on PlatformException catch (e) {
      print(e.message);
    }

    if (_isAuthenticated) {
      return "Authenticated";
    }
    return "Failed";
  }
}
