import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:toast/toast.dart';
import 'package:total_load_up/classes/DatabaseManager.dart';
import 'package:total_load_up/global/Security.dart';
import 'package:total_load_up/screens/homeScreen.dart';
import 'package:twilio_flutter/twilio_flutter.dart';
import 'package:total_load_up/global/loading.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

import 'bottom_nav.dart';

class PaymentDetails extends StatefulWidget {
  final QrData value;
  const PaymentDetails({Key key, this.value}) : super(key: key);

  @override
  _PaymentDetailsState createState() => _PaymentDetailsState();
}

class _PaymentDetailsState extends State<PaymentDetails> {
  final _key = GlobalKey<FormState>();

  bool loading = false;

  int myNumber = 0881315201;
  bool validate() {
    final form = _key.currentState;
    form.save();
    if (form.validate()) {
      form.save();
      return true;
    } else {
      return false;
    }
  }
  //vinjeru copy from here  going down

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
        toNumber: '+265881315201',
        messageBody:
            'Thank you For using total malawi services, You have made a purchase of ${_amountController.text} at $valueChoose.\n ref: ${transactionId.toString()}');
    print('Sent Successful');
  }

  Future<void> sendAnotherSms() async {
    twilioFlutter.sendSMS(
        toNumber: '+265884800252',
        messageBody:
            'Amount of of ${_amountController.text} has been paid for.\n Ref: $transactionId');
    print('Sent Successfully to the service station');
  }

  void getSms() async {
    var data = await twilioFlutter.getSmsList();
    print(data);
    await twilioFlutter.getSMS('***************************');
  }

  // end here copying....
  //end twillio
  final auth = FirebaseAuth.instance;
  final user = FirebaseAuth.instance.currentUser;
  final db = FirebaseFirestore.instance;
  var data;

  TextEditingController _amountController = TextEditingController();
  var transactionId;
  String valueChoose;
  List listItem = ['Chitawira', 'Mount Pleasant', 'Limbe', 'Mulanje'];

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Scaffold(
            drawer: Drawer(
              child: ineyo(),
            ),
            appBar: AppBar(
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back),
                  iconSize: 28.0,
                  onPressed: () => {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => BottomNavBar()))
                  },
                ),
                title: Text('Payment'),
                centerTitle: true,
                actions: [
                  IconButton(
                      icon: const Icon(Icons.attach_money),
                      iconSize: 28.0,
                      onPressed: () {
                        // _showLockScreen(context, opaque: false);
                      }),
                ]),
            body: SingleChildScrollView(
              child: Container(
                child: Column(
                  children: [
                    SizedBox(height: 15),
                    Container(
                      child: Form(
                        key: _key,
                        child: Container(
                          margin: EdgeInsets.only(left: 20, right: 10, top: 20),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 25, vertical: 15),
                                child: DropdownButton(
                                  hint: Text('Select Service Station'),
                                  icon: Icon(
                                      Icons.arrow_drop_down_circle_outlined),
                                  iconSize: 36,
                                  isExpanded: true,
                                  underline: SizedBox(),
                                  value: valueChoose,
                                  onChanged: (newValue) {
                                    setState(() {
                                      valueChoose = newValue;
                                    });
                                  },
                                  items: listItem.map((valueChoose) {
                                    return DropdownMenuItem(
                                        value: valueChoose,
                                        child: Text(valueChoose));
                                  }).toList(),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 25, vertical: 15),
                                child: TextFormField(
                                  controller: _amountController,
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    prefixIcon: Icon(
                                      Icons.mail,
                                      color: Colors.black,
                                      size: 20,
                                    ),
                                    labelText: 'Amount to be paid',
                                    enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                      color: Colors.black,
                                    )),
                                    border: OutlineInputBorder(),
                                  ),
                                  validator: (value) => value.isEmpty
                                      ? 'Please add amount'
                                      : null,
                                ),
                              ),
                              SizedBox(height: 25),
                              Container(
                                height: 60,
                                width: MediaQuery.of(context).size.width / 1.2,
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 0, horizontal: 15),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      TextButton(
                                          child: Text(
                                            'Make payment',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 25,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          onPressed: () async {
                                            if (_key.currentState.validate()) {
                                              setState(() {
                                                loading = true;
                                              });
                                              var validateAmount = false;
                                              var customerID = await db
                                                  .collection('Users')
                                                  .where('uid',
                                                      isEqualTo: user.uid)
                                                  .get()
                                                  .then((snapshot) {
                                                return snapshot.docs[0].id;
                                              }); // getting current user id
                                              print('Current user is: ' +
                                                  customerID);
                                              await FirebaseFirestore.instance
                                                  .collection('wallet')
                                                  .doc(user.uid)
                                                  .get()
                                                  .then((DocumentSnapshot
                                                      documentSnapshot) {
                                                if (documentSnapshot.exists) {
                                                  data = documentSnapshot;
                                                  print(
                                                      'Data found in wallet for the current user is: ${documentSnapshot.data()}');
                                                  if (int.parse(
                                                          _amountController.text
                                                              .toString()) >=
                                                      data.get('money')) {
                                                    print(
                                                        'Current user does not have enough money is his account');
                                                  } else {
                                                    setState(() {
                                                      loading = false;
                                                    });
                                                    showDialog(
                                                      context: context,
                                                      builder: (context) =>
                                                          AlertDialog(
                                                        title: Text(
                                                          'Payment Failed',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.black),
                                                        ),
                                                        actions: [
                                                          TextButton(
                                                              onPressed: () =>
                                                                  Navigator.pop(
                                                                      context),
                                                              child:
                                                                  Text('Ok')),
                                                        ],
                                                        content: Text(
                                                            'Payment has failed due to insuffient amount. '),
                                                      ),
                                                    );
                                                    print(
                                                        'current user has funds');
                                                    validateAmount = true;
                                                  }
                                                } else {
                                                  setState(() {
                                                    loading = false;
                                                  });
                                                  showDialog(
                                                    context: context,
                                                    builder: (context) =>
                                                        AlertDialog(
                                                      title: Text(
                                                        'User Data Not found',
                                                        style: TextStyle(
                                                            color:
                                                                Colors.black),
                                                      ),
                                                      actions: [
                                                        TextButton(
                                                            onPressed: () =>
                                                                Navigator.pop(
                                                                    context),
                                                            child: Text('Ok')),
                                                      ],
                                                      content: Text(
                                                          'User Data does not exists. '),
                                                    ),
                                                  );
                                                  print(
                                                      'Users document does not exist on the database please check');
                                                }
                                              });
                                              // if amount is available do the following
                                              if (validateAmount) {
                                                WriteBatch batch = db.batch();
                                                var day = DateFormat('EEE')
                                                    .format(DateTime.now());

                                                var updateDaily = db
                                                    .collection('Reports')
                                                    .doc(day);
                                                batch.update(updateDaily, {
                                                  'colorVal': "0xff109613",
                                                  'saleDay': day.toString(),
                                                  'money': FieldValue.increment(
                                                      int.parse(
                                                          _amountController.text
                                                              .toString()))
                                                });
                                                print(
                                                    'update made to DailySales');

                                                var removeFromUser = db
                                                    .collection('Users')
                                                    .doc(customerID);
                                                batch.update(removeFromUser, {
                                                  "money": FieldValue.increment(
                                                      int.parse(
                                                              _amountController
                                                                  .text
                                                                  .toString()) *
                                                          (-1))
                                                });
                                                print('update made to Users');
                                                var uuid = Uuid();
                                                var transactionId =
                                                    uuid.v1().toString();

                                                //unique ID
                                                var transactionHistory = db
                                                    .collection('Transactions')
                                                    .doc(transactionId);
                                                print("ID Transaction: " +
                                                    transactionId);
                                                var dateTime = DateFormat(
                                                        'EEE d MMM yyyy kk:mm:ss')
                                                    .format(DateTime.now());

                                                batch.set(transactionHistory, {
                                                  'Location':
                                                      valueChoose.toString(),
                                                  "TransactionID":
                                                      transactionId.toString(),
                                                  "TimeDate": FieldValue
                                                      .serverTimestamp(),
                                                  "DTime": dateTime.toString(),
                                                  "AmountReceived": int.parse(
                                                      (_amountController.text
                                                          .toString())),
                                                  "RecipientUID":
                                                      customerID.toString(),
                                                  "SenderEmail": user.email,
                                                  "uid": user.uid
                                                });

                                                await batch.commit();
                                                await sendSms();
                                                await sendAnotherSms();
                                                setState(() {
                                                  loading = false;
                                                });
                                                Toast.show(
                                                    'You have made a Purchase of ${_amountController.text}',
                                                    context,
                                                    duration: 7,
                                                    gravity: Toast.CENTER);
                                                print('commit made');
                                                if (validateAmount == null) {
                                                  setState(() {
                                                    loading = false;
                                                  });
                                                }
                                                _amountController.clear();
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            BottomNavBar()));
                                              }
                                            }
                                          }),
                                      Icon(
                                        Icons.keyboard_arrow_right_sharp,
                                        color: Colors.white,
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
  }
  // Create a CollectionReference called users that references the firestore collection

  Future<void> updateAccount(
      String _amountController, String uid, String listItem) async {
    final CollectionReference serviceAccount =
        FirebaseFirestore.instance.collection("ServiceStation");

    return await serviceAccount
        .doc()
        .set({'uid': uid, 'Location': listItem, 'money': _amountController})
        .then((value) => print('Amount Added'))
        .catchError((error) => print('Failed to add amount: $error'));
  }
}
