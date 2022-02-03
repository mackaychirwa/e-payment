import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:local_auth/local_auth.dart';
import 'package:toast/toast.dart';
import 'package:total_load_up/CustomWidgets/Widgets.dart';
import 'package:total_load_up/classes/DatabaseManager.dart';
import 'package:total_load_up/screens/fingerPrint.dart';
import 'package:total_load_up/screens/homeScreen.dart';
import 'package:total_load_up/wallet/receipt.dart';
import 'package:uuid/uuid.dart';

class Transfer extends StatefulWidget {
  final PassdataQR value;

  const Transfer({Key key, this.value}) : super(key: key);

  @override
  _TransferState createState() => _TransferState();
}

class _TransferState extends State<Transfer> {
  TextEditingController _transferController = TextEditingController();
  TextEditingController _referenceController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  final auth = FirebaseAuth.instance;
  final user = FirebaseAuth.instance.currentUser;
  final db = FirebaseFirestore.instance;
  var transferAccountId = "";
  var data;

  LocalAuthentication authent = LocalAuthentication();
  // var fingerAuthentication = FingerAuth();
  bool _canCheckBiometrics;
  List<BiometricType> _availableBiometrics;

  @override
  // void initState() async {
  //   super.initState();

  //   await _checkBiometrics();
  //   _getAvailableBiometrics();
  // }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.red[600],
          shadowColor: Colors.black,
          centerTitle: true,
          title: Text(
            'Transfer Menu',
            style: TextStyle(
                fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black),
          ),
        ),
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: [
            Center(
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    _textDividerTransfer(),
                    EnterAmount(context),
                    _textDividerTransfer(),
                    EnterReference(context),
                    _textDividerTransfer(),
                    Text('Transferring to: '),
                    SizedBox(height: 20),
                    SendButton(context),
                    _cancelButton(context),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget SendButton(BuildContext context) {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance.collection("Users").snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return CircularProgressIndicator();
          } else {
            return Container(
              child: ElevatedButton(
                child: Text("Transfer", style: TextStyle(color: Colors.black)),
                onPressed: () async {
                  if (_formKey.currentState.validate()) {
                    var validatedAmount = false;
                    var transferDocId = await db
                        .collection('Users')
                        .where('uid', isEqualTo: user.uid)
                        .get()
                        .then((snapshot) {
                      return snapshot.docs[0].id;
                    }); // Read user ID of the account that you want to transfer
                    print("transferDocId: " + transferDocId);
                    await FirebaseFirestore.instance
                        .collection('Wallet')
                        .doc(user.uid)
                        .get()
                        .then((DocumentSnapshot documentSnapshot) {
                      if (documentSnapshot.exists) {
                        data = documentSnapshot;
                        print('Document data: ${documentSnapshot.data()}');
                        if (int.parse(_transferController.text.toString()) >=
                            data.get("money")) {
                          print("Don't have enough money");
                          Toast.show(
                              "You don't not have enough Funds, Please Add",
                              context,
                              duration: 7,
                              gravity: Toast.CENTER);
                        } else {
                          print("Amount is enough");
                          validatedAmount = true;
                        }
                      } else {
                        print('Document does not exist on the database');
                      }
                    });
                    if (validatedAmount) {
                      if (await _authenticate() != "Failed") {
                        WriteBatch batch = db.batch();
                        var transferAccount =
                            db.collection('Users').doc(transferDocId);
                        batch.update(transferAccount, {
                          "money": FieldValue.increment(
                              int.parse(_transferController.text.toString()))
                        });
                        print("Current user ID: " + user.uid.toString());
                        var currentAccount =
                            db.collection('Wallet').doc(user.uid);
                        batch.update(currentAccount, {
                          "money": FieldValue.increment(
                              int.parse(_transferController.text.toString()) *
                                  (-1)) // 30 * -1
                        });
                        CollectionReference transactionHistoryRef =
                            FirebaseFirestore.instance
                                .collection('Transactions');
                        var uuid = Uuid();
                        var transactionId = uuid.v1().toString();
                        var transactionHistory =
                            db.collection('Transactions').doc(transactionId);
                        print("ID Transaction: " + transactionId);
                        var dateTime = DateFormat('EEE d MMM yyyy kk:mm:ss')
                            .format(DateTime.now());
                        batch.set(transactionHistory, {
                          "TimeDate": FieldValue.serverTimestamp(),
                          "DTime": dateTime.toString(),
                          "AmountReceived":
                              int.parse((_transferController.text.toString())),
                          "RecipientEmail": widget.value.email.toString(),
                          "RecipientReference":
                              _referenceController.text.toString(),
                          "RecipientUID": transferDocId.toString(),
                          "SenderEmail": user.email,
                          "uid": user.uid
                        });
                        await batch.commit();
                        var route = MaterialPageRoute(
                            builder: (BuildContext context) => ReceiptScreenQR(
                                    value: PassreceiptQR(
                                  transactionid: transactionId.toString(),
                                  timedate: dateTime.toString(),
                                  recipientemail: widget.value.email,
                                  recipientuid: transferDocId.toString(),
                                  recipientreference:
                                      _referenceController.text.toString(),
                                  amount: int.parse(
                                      (_transferController.text.toString())),
                                )));
                        Navigator.of(context).pushReplacement(route);
                      } else {
                        Toast.show(
                            "Failed to Authenticate, Please Contact the Administrator",
                            context,
                            duration: 7,
                            gravity: Toast.CENTER);
                      }
                    }
                  }
                },
              ),
            );
          }
        });
  }

  Widget _cancelButton(BuildContext context) {
    return Container(
      child: ElevatedButton(
        child: Text(
          'Cancel',
          style: TextStyle(color: Colors.black),
        ),
        onPressed: () async {
          await Future.delayed(const Duration(milliseconds: 100));
          PushReplaceTo(context, HomeScreen());
        },
      ),
    );
  }

  Widget EnterAmount(BuildContext context) {
    return Container(
      width: 355,
      padding: EdgeInsets.only(bottom: 20),
      child: TextFormField(
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        controller: _transferController,
        decoration: InputDecoration(
            enabledBorder: const OutlineInputBorder(
              // width: 0.0 produces a thin "hairline" border
              borderSide: const BorderSide(color: Colors.grey, width: 0.0),
            ),
            border: const OutlineInputBorder(),
            labelStyle: new TextStyle(color: Colors.green),
            hintText: 'Amount',
            helperText: 'Enter the amount you would like to transfer'),
        validator: (value) => value.isEmpty ? 'Amount Cannot be blank' : null,
      ),
    );
  }

  Widget EnterReference(BuildContext context) {
    return Container(
      width: 355,
      padding: EdgeInsets.only(bottom: 20),
      child: TextFormField(
        controller: _referenceController,
        decoration: InputDecoration(
            enabledBorder: const OutlineInputBorder(
              // width: 0.0 produces a thin "hairline" border
              borderSide: const BorderSide(color: Colors.grey, width: 0.0),
            ),
            border: const OutlineInputBorder(),
            labelStyle: new TextStyle(color: Colors.green),
            hintText: 'Transfer Details',
            helperText: 'Enter a recipient Reference'),
        validator: (value) => value.isEmpty ? 'Transfer Cannot be blank' : null,
      ),
    );
  }

  Widget _textDividerTransfer() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(10),
          ),
          Expanded(child: Divider()),
        ],
      ),
    );
  }

  Future<String> _authenticate() async {
    bool _isAuthenticated = false;
    try {
      _isAuthenticated = await authent.authenticate(
        localizedReason: 'Please scan your biometric or use PIN to continue',
        useErrorDialogs: true,
        stickyAuth: true,
      );
    } on PlatformException catch (e) {
      print(e.message);
    }

    if (_isAuthenticated) {
      return "Authenticated";
    }
    return "Failed";
  }

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
      availableBiometrics = await authent.getAvailableBiometrics();
    } on PlatformException catch (e) {
      print(e);
    }
    if (!mounted) return;
    setState(() {
      _availableBiometrics = availableBiometrics;
    });
  }
}
