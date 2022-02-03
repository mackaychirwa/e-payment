import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:total_load_up/colors/color.dart';
import 'package:total_load_up/CustomWidgets/CustomAppWallet.dart';
import 'package:total_load_up/wallet/AirtelTransfer.dart';

class AirtelMoney extends StatefulWidget {
  const AirtelMoney({Key key}) : super(key: key);

  @override
  _AirtelMoneyState createState() => _AirtelMoneyState();
}

class _AirtelMoneyState extends State<AirtelMoney> {
  final auth = FirebaseAuth.instance;
  final user = FirebaseAuth.instance.currentUser;
  final db = FirebaseFirestore.instance;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: CustomAppWallet(),
      body: CustomScrollView(
        physics: ClampingScrollPhysics(),
        slivers: [
          header(screenHeight),
          _imagebody(),
          _ibody(),
          _ilist(),
        ], // Slivers
      ),
    );
  }

  SliverToBoxAdapter header(double screenHeight) {
    return SliverToBoxAdapter(
      child: Container(
        padding: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
            color: red,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(40.0),
              bottomRight: Radius.circular(40.0),
            )),
      ),
    );
  }

  SliverToBoxAdapter _imagebody() {
    return SliverToBoxAdapter(
      child: Card(
        child: Column(
          children: [
            SizedBox(height: 1.0),
            Container(
              child: Stack(
                children: [
                  Positioned(
                    child: Image.asset(
                      'assets/images/banner.jpg',
                      scale: 1.0,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    bottom: 16.0,
                    left: 16.0,
                    right: 16.0,
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerLeft,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  SliverToBoxAdapter _ibody() {
    final screenHeight = MediaQuery.of(context).size.height;

    return SliverToBoxAdapter(
      child: Container(
        width: 200,
        height: 250,
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          color: Colors.white,
          elevation: 10,
          child: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
              stream: FirebaseFirestore.instance
                  .collection('wallet')
                  .doc(user.uid)
                  .snapshots(),
              builder: (context, snapshot) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ListTile(
                      leading: Icon(Icons.person, size: 50),
                      title: Text(
                        "Wallet: ${snapshot.data.data()['WalletName'].toString()}",
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 15),
                      ),
                      subtitle: Text(
                        'Available Balance',
                        style: TextStyle(color: Colors.black),
                      ),
                      trailing: Text(
                          'MWK: ${snapshot.data.data()['money'].toString()}'),
                    ),
                    Divider(height: 50),
                    ButtonBar(
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ReworkPayment()));
                          },
                          child: Text(
                            'Transfer Funds',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              }),
        ),
      ),
    );
  }

  SliverToBoxAdapter _ilist() {
    return SliverToBoxAdapter(
      child: Container(
        width: 200,
        height: 300,
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          color: Colors.white,
          elevation: 15,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              ListTile(
                leading: Text(
                  'Quick Actions',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
              ),
              Divider(),
              ListTile(
                  leading: Icon(
                    Icons.phone_android,
                  ),
                  title: Column(
                    children: [
                      Icon(
                        Icons.person,
                      ),
                    ],
                  ),
                  trailing: Icon(
                    Icons.wallet_travel_outlined,
                  )),
              ListTile(
                  leading: Icon(
                    Icons.receipt_outlined,
                  ),
                  title: Column(
                    children: [
                      Icon(Icons.account_balance_wallet),
                    ],
                  ),
                  trailing: Icon(
                    Icons.account_balance_wallet_outlined,
                  )),
              ListTile(
                  leading: Icon(Icons.shopping_cart_outlined),
                  title: Column(
                    children: [
                      Icon(Icons.atm_outlined),
                    ],
                  ),
                  trailing: Icon(
                    Icons.atm_rounded,
                  )),
              TextButton(
                onPressed: () {},
                child: Text(
                  'More',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
