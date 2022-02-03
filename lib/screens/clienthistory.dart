import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:total_load_up/screens/homeScreen.dart';

class ClientHistory extends StatefulWidget {
  const ClientHistory({Key key}) : super(key: key);

  @override
  _ClientHistoryState createState() => _ClientHistoryState();
}

class _ClientHistoryState extends State<ClientHistory> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final auth = FirebaseAuth.instance;
  final user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      key: _scaffoldKey,
      drawer: Drawer(
        child: ineyo(),
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
              onPressed: () {}),
        ],
      ),
      body: CustomScrollView(
        physics: ClampingScrollPhysics(),
        slivers: [
          _buildHead(screenHeight),
          _buildBal(),
          _buildButton(),
          _buildRe(),
        ], // Slivers
      ),
    );
  }

  SliverToBoxAdapter _buildHead(double screenHeight) {
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

  SliverToBoxAdapter _buildBal() {
    return SliverToBoxAdapter(
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.all(15),
            alignment: Alignment.center,
            child: Text(
              'History',
              style: TextStyle(
                fontSize: 20.0,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  SliverToBoxAdapter _buildButton() {
    return SliverToBoxAdapter(
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.all(15),
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    FirebaseFirestore.instance
                        .collection('Transactions')
                        // .where('SenderEmail', isEqualTo: user.email)
                        // .where('RecipientEmail', isEqualTo: user.email)
                        // .where(user.email.toString(), arrayContainsAny: ['SenderEmail', 'RecipientEmail'])
                        // .where(user.email.toString(), whereIn: ["SenderEmail","RecipientEmail"])
                        .orderBy('TimeDate', descending: true)
                        .snapshots();
                    return _buildRe();
                  },
                  child: Text(
                    'Monthly',
                    style: TextStyle(
                      fontSize: 20.0,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    FirebaseFirestore.instance
                        .collection('Transactions')
                        // .where('SenderEmail', isEqualTo: user.email)
                        .where('RecipientEmail', isEqualTo: user.email)
                        // .where(user.email.toString(), arrayContainsAny: ['SenderEmail', 'RecipientEmail'])
                        // .where(user.email.toString(), whereIn: ["SenderEmail","RecipientEmail"])
                        .orderBy('TimeDate', descending: false)
                        .snapshots();
                    return _buildMonth();
                  },
                  child: Text(
                    'Weekly',
                    style: TextStyle(
                      fontSize: 20.0,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  SliverToBoxAdapter _buildRe() {
    return SliverToBoxAdapter(
      child: SingleChildScrollView(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.only(),
                  ),
                  child: Stack(
                    children: [
                      SizedBox(height: 10),
                      StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                          stream: FirebaseFirestore.instance
                              .collection('Transactions')
                              // .where('SenderEmail', isEqualTo: user.email)
                              // .where('RecipientEmail', isEqualTo: user.email)
                              // .where(user.email.toString(), arrayContainsAny: ['SenderEmail', 'RecipientEmail'])
                              // .where(user.email.toString(), whereIn: ["SenderEmail","RecipientEmail"])
                              .orderBy('TimeDate', descending: true)
                              .snapshots(),
                          builder:
                              (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                            if (!snapshot.hasData) {
                              return Center(
                                child: Padding(
                                  padding: const EdgeInsets.only(bottom: 140),
                                  child: Text(
                                    'No Transaction\nData Found',
                                    style: TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              );
                            } else if (snapshot.data.docs.length < 1) {
                              return Container(
                                alignment: Alignment.center,
                                child: Text(
                                  'No Transaction\nData Found',
                                  style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black),
                                  textAlign: TextAlign.center,
                                ),
                              );
                            } else {
                              return Container(
                                child: ListView.builder(
                                  itemCount: snapshot.hasData
                                      ? snapshot.data.docs.length
                                      : 0,
                                  itemBuilder: (context, index) {
                                    if (snapshot.data.docs[index]
                                            .get('SenderEmail')
                                            .toString() ==
                                        user.uid) {
                                      return Card(
                                        child: ListTile(
                                          title: Text(
                                            '${snapshot.data.docs[index].get('SenderEmail').toString()}',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          subtitle: Text(
                                              'Date: ${snapshot.data.docs[index].get('DTime').toString()}'),
                                          leading: CircleAvatar(
                                            backgroundColor: Colors.white,
                                            child: Icon(
                                              Icons.add,
                                              color: Colors.green,
                                            ),
                                          ),
                                          trailing: Text(
                                            'RM ${snapshot.data.docs[index].get('AmountReceived').toString()}',
                                            style:
                                                TextStyle(color: Colors.green),
                                          ),
                                        ),
                                      );
                                    } else if (snapshot.data.docs[index]
                                            .get('SenderEmail')
                                            .toString() ==
                                        user.email) {
                                      return Card(
                                        child: ListTile(
                                          title: Text(
                                            '${snapshot.data.docs[index].get('SenderEmail').toString()}',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          subtitle: Text(
                                            'Date: ${snapshot.data.docs[index].get('DTime').toString()}',
                                            maxLines: 3,
                                          ),
                                          leading: CircleAvatar(
                                            backgroundColor: Colors.white,
                                            child: Icon(
                                              Icons.remove,
                                              color: Colors.red,
                                            ),
                                          ),
                                          trailing: Text(
                                            'MWK ${snapshot.data.docs[index].get('AmountReceived').toString()}',
                                            style: TextStyle(color: Colors.red),
                                          ),
                                        ),
                                      );
                                    } else {
                                      return Text('');
                                    }
                                  },
                                ),
                              );
                            }
                          })
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  SliverToBoxAdapter _buildMonth() {
    return SliverToBoxAdapter(
      child: SingleChildScrollView(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.only(),
                  ),
                  child: Stack(
                    children: [
                      SizedBox(height: 10),
                      StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                          stream: FirebaseFirestore.instance
                              .collection('Transactions')
                              // .where('SenderEmail', isEqualTo: user.email)
                              .where('RecipientEmail', isEqualTo: user.email)
                              // .where(user.email.toString(), arrayContainsAny: ['SenderEmail', 'RecipientEmail'])
                              // .where(user.email.toString(), whereIn: ["SenderEmail","RecipientEmail"])
                              .orderBy('TimeDate', descending: true)
                              .snapshots(),
                          builder:
                              (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                            if (!snapshot.hasData) {
                              return Center(
                                child: Padding(
                                  padding: const EdgeInsets.only(bottom: 140),
                                  child: Text(
                                    'No Transaction\nData Found',
                                    style: TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              );
                            } else if (snapshot.data.docs.length < 1) {
                              return Container(
                                alignment: Alignment.center,
                                child: Text(
                                  'No Transaction\nData Found',
                                  style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black),
                                  textAlign: TextAlign.center,
                                ),
                              );
                            } else {
                              return Container(
                                child: ListView.builder(
                                  itemCount: snapshot.hasData
                                      ? snapshot.data.docs.length
                                      : 0,
                                  itemBuilder: (context, index) {
                                    if (snapshot.data.docs[index]
                                            .get('SenderEmail')
                                            .toString() ==
                                        user.uid) {
                                      return Card(
                                        child: ListTile(
                                          title: Text(
                                            '${snapshot.data.docs[index].get('SenderEmail').toString()}',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          subtitle: Text(
                                              'Details: ${snapshot.data.docs[index].get('RecipientReference').toString()}\nDate: ${snapshot.data.docs[index].get('DTime').toString()}'),
                                          leading: CircleAvatar(
                                            backgroundColor: Colors.white,
                                            child: Icon(
                                              Icons.add,
                                              color: Colors.green,
                                            ),
                                          ),
                                          trailing: Text(
                                            'RM ${snapshot.data.docs[index].get('AmountReceived').toString()}',
                                            style:
                                                TextStyle(color: Colors.green),
                                          ),
                                        ),
                                      );
                                    } else if (snapshot.data.docs[index]
                                            .get('SenderEmail')
                                            .toString() ==
                                        user.email) {
                                      return Card(
                                        child: ListTile(
                                          title: Text(
                                            '${snapshot.data.docs[index].get('SenderEmail').toString()}',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          subtitle: Text(
                                            'Details: ${snapshot.data.docs[index].get('RecipientReference').toString()}\nDate: ${snapshot.data.docs[index].get('DTime').toString()}',
                                            maxLines: 3,
                                          ),
                                          leading: CircleAvatar(
                                            backgroundColor: Colors.white,
                                            child: Icon(
                                              Icons.remove,
                                              color: Colors.red,
                                            ),
                                          ),
                                          trailing: Text(
                                            'MWK ${snapshot.data.docs[index].get('AmountReceived').toString()}',
                                            style: TextStyle(color: Colors.red),
                                          ),
                                        ),
                                      );
                                    } else {
                                      return Text('');
                                    }
                                  },
                                ),
                              );
                            }
                          })
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
