import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:total_load_up/CustomWidgets/CustomAppBar.dart';
import 'package:total_load_up/classes/AuthService.dart';
import 'package:total_load_up/global/card_model.dart';
import 'package:total_load_up/screens/account.dart';
import 'package:total_load_up/wallet/airtelMoney_Dashboard.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  String balance = '170000';
  bool isAuthenticated = false;
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
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => AirtelMoney()));
                // _showLockScreen(context, opaque: false);
              }),
        ],
      ),
      body: CustomScrollView(
        physics: ClampingScrollPhysics(),
        slivers: [
          _buildHeader(screenHeight),
          _buildBalance(),
          _buildBody(screenHeight),
          _buildRecent(),
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

  SliverToBoxAdapter _buildBalance() {
    return SliverToBoxAdapter(
      child: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
          stream: FirebaseFirestore.instance
              .collection('Users')
              .doc(user.uid)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Text(0.toString());
            } else {
              return Column(
                children: [
                  Container(
                    margin: EdgeInsets.all(15),
                    alignment: Alignment.center,
                    child: Text(
                      'Total Balance\n'
                      'MWK: '
                      '${snapshot.data.data()['money'].toString()}',
                      style: TextStyle(
                        fontSize: 20.0,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              );
            }
          }),
    );
  }

  SliverToBoxAdapter _buildBody(double screenHeight) {
    final screenWidth = MediaQuery.of(context).size.width;
    return SliverToBoxAdapter(
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10.0),
        height: 300,
        child: ListView.builder(
          padding: EdgeInsets.only(
            left: 16,
            right: 6,
          ),
          itemCount: cards.length,
          itemBuilder: (context, index) {
            return Container(
              margin: EdgeInsets.only(right: 10),
              // height: 199,
              width:
                  screenWidth, // can change to a fixed size but need it to be responsive remember that
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: Colors.red[600],
              ),
              child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      // account
                      .collection('Users')
                      .doc(user.uid)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Text('Sorry we can seem to get your data');
                    } else {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CircleAvatar(
                                radius: 10,
                                backgroundColor:
                                    Color.fromRGBO(50, 172, 121, 1),
                                child: Icon(
                                  Icons.check,
                                  color: Colors.white,
                                  size: 14,
                                ),
                              ),
                              Text(
                                "Total ",
                                style: TextStyle(
                                    fontStyle: FontStyle.italic,
                                    fontSize: 24,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w900),
                              )
                            ],
                          ),
                          SizedBox(height: 100),
                          Text(
                            cards[index].cardNumber,
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w900,
                                color: Colors.white,
                                letterSpacing: 2.0),
                          ),
                          SizedBox(height: 35),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    " Card Holder",
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.black,
                                        letterSpacing: 2.0),
                                  ),
                                  Text(
                                    '${snapshot.data.data()['fullname']}',
                                    style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.grey,
                                        letterSpacing: 2.0),
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "EXPIRES",
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.black,
                                        letterSpacing: 2.0),
                                  ),
                                  Text(
                                    "05/22",
                                    style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.grey,
                                        letterSpacing: 2.0),
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "CVV",
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.black,
                                        letterSpacing: 2.0),
                                  ),
                                  Text(
                                    "564 ",
                                    style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.grey,
                                        letterSpacing: 2.0),
                                  ),
                                ],
                              ),
                            ],
                          )
                        ],
                      );
                    }
                  }),
            );
          }, // itemBuilder
        ),
      ),
    );
  }

  //list builder
  SliverToBoxAdapter _buildRecent() {
    return SliverToBoxAdapter(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    'Recent Transactions',
                    style: TextStyle(
                      fontSize: 20.0,
                    ),
                  ),
                  Icon(Icons.arrow_right),
                ],
              ),
              Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.only(),
                  ),
                  child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                      stream: FirebaseFirestore.instance
                          .collection('Transactions')
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
                                  ? 2
                                  // ? snapshot.data.docs.length
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
                                          'Details:  ${snapshot.data.docs[index].get('DTime').toString()}'),
                                      leading: CircleAvatar(
                                        backgroundColor: Colors.white,
                                        child: Icon(
                                          Icons.add,
                                          color: Colors.green,
                                        ),
                                      ),
                                      trailing: Text(
                                        'MWK ${snapshot.data.docs[index].get('AmountReceived').toString()}',
                                        style: TextStyle(color: Colors.green),
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
                                        'Date And Time: ${snapshot.data.docs[index].get('DTime').toString()}',
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
                                        ' MWK ${snapshot.data.docs[index].get('AmountReceived').toString()}\n ${snapshot.data.docs[index].get('Location').toString()}',
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
                  // child:
                  ),
            ],
          ),
        ],
      ),
    );
  }
}

class ineyo extends StatelessWidget {
  const ineyo({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return ListView(
      children: [
        DrawerHeader(
          decoration: BoxDecoration(color: Colors.blue[600]),
          child: Container(
            child: Column(
              children: [
                Material(
                    elevation: 1,
                    borderRadius: BorderRadius.all(Radius.circular(50.0)),
                    child: Padding(
                      padding: EdgeInsets.all(0),
                      child:
                          StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                              stream: FirebaseFirestore.instance
                                  .collection('Users')
                                  .doc(user.uid)
                                  .snapshots(),
                              builder: (context, snapshot) {
                                if (!snapshot.hasData) {
                                  return CircularProgressIndicator();
                                } else {
                                  return ClipOval(
                                    child: Image.network(
                                      '${snapshot.data.data()['avatar'].toString()}',
                                      width: 90,
                                      height: 90,
                                      fit: BoxFit.cover,
                                    ),
                                  );
                                }
                              }),
                    )),
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
        CustomListTile(
            Icons.person,
            'Profile',
            () => {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Account()))
                }),
        CustomListTile(
          Icons.help,
          'Help',
          () => {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: Text(
                  'Help Page',
                  style: TextStyle(color: Colors.black),
                ),
                actions: [
                  TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('Ok')),
                ],
                content: Text(
                    'Hello User.\n the following will help you to navigate within the application with ease once you have created an account a an Ewallet account will be allocated to you where you can transfer funds from. on the top right corner you will find a dollar sign which will take you to the Ewallet there you will find find the balance that is available and you can press transfer and add the amount. when you go back to the home screen top left you will find the menu icon which you will get to see your profile. below we have 5 bottom navigation the first icon will diplay things on the dashboard, the second icon will show all transaction made the third icon will show map and the last icon will let you logout of the system'),
              ),
            )
          },
        ),
      ],
    );
  }
}
