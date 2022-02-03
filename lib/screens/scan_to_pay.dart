import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:local_auth/auth_strings.dart';
import 'package:local_auth/local_auth.dart';
import 'package:toast/toast.dart';

import 'package:total_load_up/CustomWidgets/CustomAppBar.dart';
import 'package:total_load_up/classes/DatabaseManager.dart';
import 'package:total_load_up/classes/ScanCapture.dart';
import 'package:twilio_flutter/twilio_flutter.dart';

import 'PaymentDetails.dart';
import 'homeScreen.dart';

class Scanpay extends StatefulWidget {
  final PassdataQR value;
  final ScanResult values;
  Scanpay({Key key, this.value, this.values}) : super(key: key);

  @override
  _ScanpayState createState() => _ScanpayState();
}

class _ScanpayState extends State<Scanpay> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  //authentication and user
  final auth = FirebaseAuth.instance;
  final user = FirebaseAuth.instance.currentUser;
  final db = FirebaseFirestore.instance;

  var data;

  // this is for biometrics
  LocalAuthentication authent = LocalAuthentication();
  bool _canCheckBiometrics;
  List<BiometricType> _availableBiometrics;
  String _authorized = 'Not Authorized';
  int messageSent;

  //This is for twilio
  TwilioFlutter twilioFlutter;

  @override
  void initState() {
    twilioFlutter = TwilioFlutter(
        accountSid: 'ACe09887bf28e6cf32bc48bcdfb91b1f39',
        authToken: 'ebc6c3ff6aa4fa1b3911d6a07fd1aaf4',
        twilioNumber: '+17085016720');
    super.initState();
  }

  Future<void> sendSms() async {
    twilioFlutter.sendSMS(
        toNumber: '${(messageSent)}',
        messageBody:
            'Thank you For using total malawi services,.\n You have made a purchase of 1000\n at Chitawira.');
    print('Sent Successful');
  }

  void getSms() async {
    var data = await twilioFlutter.getSmsList();
    print(data);
    await twilioFlutter.getSMS('***************************');
  }

  //end twillio

  //functions for biometrics
  Future<void> _checkBiometrics() async {
    bool canCheckBiometrics;
    try {
      canCheckBiometrics = await authent.canCheckBiometrics;
    } on PlatformException catch (e) {
      print(e);
    }
    if (!mounted) return;
    setState(() {
      _canCheckBiometrics = canCheckBiometrics;
    });
  }

  Future<void> _getAvailableBiometrics() async {
    List<BiometricType> availableBiometrics;
    try {
      availableBiometrics =
          authent.getAvailableBiometrics() as List<BiometricType>;
    } on PlatformException catch (e) {
      print(e);
    }
    if (!mounted) return;
    setState(() {
      _availableBiometrics = availableBiometrics;
    });
  }

  Future<void> _authenticate() async {
    bool authenticated = false;
    try {
      authenticated = await authent.authenticate(
          localizedReason: "Scan your Fingerprint to authenticate",
          useErrorDialogs: true,
          stickyAuth: false,
          biometricOnly: true);
    } on PlatformException catch (e) {
      print(e);
    }
    if (!mounted) return;
    setState(() {
      _authorized = authenticated ? "Authorized" : "Not Authorized";
    });
  }

  String qrCode = 'Unknown';

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      key: _scaffoldKey,
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue[600], Colors.blueAccent],
                ),
              ),
              child: Container(
                child: Column(
                  children: [
                    Material(
                      elevation: 10,
                      borderRadius: BorderRadius.all(Radius.circular(50.0)),
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Image.asset(
                          'assets/images/default.jpg',
                          width: 100,
                          height: 100,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'Profile picture',
                        style: TextStyle(color: Colors.white, fontSize: 20.0),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            CustomListTile(Icons.person, 'Profile', () => {}),
            CustomListTile(Icons.notifications, 'Notification', () => {}),
            CustomListTile(Icons.settings, 'Settings', () => {}),
          ],
        ),
      ),
      appBar: AppBar(
        backgroundColor: Colors.blue[600],
        elevation: 0.0,
        leading: IconButton(
          icon: const Icon(Icons.menu),
          iconSize: 28.0,
          onPressed: () => _scaffoldKey.currentState.openDrawer(),
        ),
        title: Text('Total Fillup'),
        centerTitle: true,
        actions: [
          IconButton(
              icon: const Icon(Icons.attach_money),
              iconSize: 28.0,
              onPressed: () {
                //  _showLockScreen(context, opaque: false);
              }),
        ],
      ),
      body: CustomScrollView(
        physics: ClampingScrollPhysics(),
        slivers: [
          _buildHeader(screenHeight),
          _buildScan(),
          _buildResult(),

          //  _buildRegionTabBar(),
          //_buildRecentDetails(),
        ], // Slivers
      ),
    );
  }

  SliverToBoxAdapter _buildHeader(double screenHeight) {
    return SliverToBoxAdapter(
      child: Container(
        padding: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
            color: Colors.blue[600],
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(40.0),
              bottomRight: Radius.circular(40.0),
            )),
      ),
    );
  }

  SliverToBoxAdapter _buildScan() {
    return SliverToBoxAdapter(
      child: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 72),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _startFingerAuth();
                  });
                },
                child: Text('Scan to get amount'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  SliverToBoxAdapter _buildResult() {
    return SliverToBoxAdapter(
      child: Container(
        child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: FirebaseFirestore.instance.collection("Users").snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return CircularProgressIndicator();
            } else {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: Text(
                        qrCode,
                        style: TextStyle(
                            fontSize: 15,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(height: 150),
                    ElevatedButton(
                      onPressed: () async {
                        // await _getAvailableBiometrics();
                        _authenticate();
                        if (_authenticate != null) {
                          WriteBatch batch = db.batch();
                          var userDocId = await db
                              .collection('Users')
                              .where('uid', isEqualTo: user.uid)
                              .get()
                              .then((snapshot) {
                            return snapshot.docs[0].id;
                          }); // Read user ID of the account that you want to transfer
                          print("UserDocId: " + userDocId);
                          var paymentAmount =
                              db.collection('Users').doc(userDocId);
                          batch.update(paymentAmount, {
                            "money": FieldValue.increment(
                                int.parse(qrCode.toString()))
                          });
                          print("Current user ID: " + user.uid.toString());
                          var currentAccount =
                              db.collection('Users').doc(user.uid);
                          batch.update(currentAccount, {
                            "money": FieldValue.increment(
                                int.parse(qrCode.toString()) * -1) // 30 * -1
                          });
                          var messageSent = db
                              .collection('Users')
                              .doc(userDocId)
                              .get()
                              .then((doc) => doc.get('phoneNumber'));
                          print('PhoneNumber sent to' + messageSent.toString());
                          await sendSms();
                          print('sms has been sent');
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => HomeScreen()));
                        } else {
                          Toast.show('Please Scan Again', context,
                              duration: 7, gravity: Toast.CENTER);
                        }
                      },
                      child: Text('Make Payment'),
                    ),
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }

  Future<String> _startFingerAuth() async {
    bool _isAuthenticated = false;
    AndroidAuthMessages _androidMsg = AndroidAuthMessages(
      // signInTitle: 'Biometric authentication',
      biometricHint: 'To log in please authenticate',
      cancelButton: 'Close',
    );
    try {
      _isAuthenticated = await authent.authenticate(
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
