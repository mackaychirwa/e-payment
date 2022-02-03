import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:total_load_up/global/loading.dart';

import '../screens/homeScreen.dart';
import 'airtelMoney_Dashboard.dart';

class ReworkPayment extends StatefulWidget {
  const ReworkPayment({Key key}) : super(key: key);

  @override
  _ReworkPaymentState createState() => _ReworkPaymentState();
}

class _ReworkPaymentState extends State<ReworkPayment> {
  final _key = GlobalKey<FormState>();
  // final GlobalKey<ScaffoldState> _scaffoldKeys = new GlobalKey<ScaffoldState>();

  bool loading = false;

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

  final auth = FirebaseAuth.instance;
  final user = FirebaseAuth.instance.currentUser;
  final db = FirebaseFirestore.instance;
  var data;
  TextEditingController _amountController = TextEditingController();
  TextEditingController _referenceController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Scaffold(
            drawer: Drawer(
              child: ineyo(),
            ),
            appBar: AppBar(
              backgroundColor: Colors.red[600],
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                iconSize: 28.0,
                onPressed: () => {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => AirtelMoney()))
                },
              ),
              title: Text('Transfer'),
              centerTitle: true,
            ),
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
                                child: TextFormField(
                                  controller: _amountController,
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    prefixIcon: Icon(
                                      Icons.mail,
                                      color: Colors.black,
                                      size: 20,
                                    ),
                                    labelText: 'Amount to be Transfered',
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
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 25, vertical: 15),
                                child: TextFormField(
                                  controller: _referenceController,
                                  keyboardType: TextInputType.name,
                                  decoration: InputDecoration(
                                    prefixIcon: Icon(
                                      Icons.lock,
                                      color: Colors.black,
                                      size: 20,
                                    ),
                                    labelText: 'Reason of Transfer',
                                    enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                      color: Colors.black,
                                    )),
                                    border: OutlineInputBorder(),
                                  ),
                                  validator: (value) => value.isEmpty
                                      ? 'Password Cannot be blank'
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
                                                    print(
                                                        'current user has funds');
                                                    validateAmount = true;
                                                  }
                                                } else {
                                                  print(
                                                      'Users document does not exist on the database please check');
                                                }
                                              });
                                              if (validateAmount) {
                                                WriteBatch batch = db.batch();
                                                var transferAccount = db
                                                    .collection('Users')
                                                    .doc(customerID);
                                                batch.update(transferAccount, {
                                                  'money': FieldValue.increment(
                                                      int.parse(
                                                          _amountController.text
                                                              .toString()))
                                                });
                                                print(
                                                    'Current User ID Transfer:' +
                                                        user.uid.toString());
                                                var removeFromUser = db
                                                    .collection('wallet')
                                                    .doc(customerID);
                                                batch.update(removeFromUser, {
                                                  'Reason for Transfer':
                                                      _referenceController.text,
                                                  "money": FieldValue.increment(
                                                      int.parse(
                                                              _amountController
                                                                  .text
                                                                  .toString()) *
                                                          (-1))
                                                });
                                                print(
                                                    'Amount removed from wallet');

                                                await batch.commit();
                                                _amountController.clear();
                                                _referenceController.clear();
                                                setState(() {
                                                  loading = false;
                                                });
                                              }
                                            }
                                          }),
                                      //Icon
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
}
