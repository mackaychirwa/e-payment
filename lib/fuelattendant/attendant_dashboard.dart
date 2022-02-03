import 'package:flutter/material.dart';
import 'package:total_load_up/classes/AuthService.dart';
import 'package:total_load_up/fuelattendant/generateQr.dart';
import 'package:total_load_up/fuelattendant/history.dart';

class AttendantDash extends StatefulWidget {
  const AttendantDash({Key key}) : super(key: key);

  @override
  _AttendantDashState createState() => _AttendantDashState();
}

class _AttendantDashState extends State<AttendantDash> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    //final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      key: _scaffoldKey,
      drawer: Drawer(),
      appBar: AppBar(
        backgroundColor: Colors.blue[600],
        elevation: 0.0,
        leading: IconButton(
          icon: const Icon(Icons.menu),
          iconSize: 28.0,
          onPressed: () => _scaffoldKey.currentState.openDrawer(),
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(30.0),
        child: GridView.count(
          crossAxisCount: 2,
          children: [
            Card(
              margin: EdgeInsets.all(8.0),
              child: InkWell(
                onTap: () {},
                splashColor: Colors.orange,
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.home_outlined,
                        size: 70.0,
                      ),
                      Text(
                        'Home',
                        style: TextStyle(fontSize: 17.0),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Card(
              margin: EdgeInsets.all(8.0),
              child: InkWell(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Generateqr()));
                },
                splashColor: Colors.orange,
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.money,
                        size: 70.0,
                      ),
                      Text(
                        'Payment',
                        style: TextStyle(fontSize: 17.0),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Card(
              margin: EdgeInsets.all(8.0),
              child: InkWell(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Listview()));
                },
                splashColor: Colors.orange,
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.history_rounded,
                        size: 70.0,
                      ),
                      Text(
                        'Previous',
                        style: TextStyle(fontSize: 17.0),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Card(
              margin: EdgeInsets.all(8.0),
              child: InkWell(
                onTap: () {},
                splashColor: Colors.orange,
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.report_outlined,
                        size: 70.0,
                      ),
                      Text(
                        'Reports',
                        style: TextStyle(fontSize: 17.0),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Card(
              margin: EdgeInsets.all(8.0),
              child: InkWell(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text(
                        'About Us',
                        style: TextStyle(color: Colors.black),
                      ),
                      actions: [
                        TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text('Ok')),
                      ],
                      content: Text(
                          'Total Fill up is an application that was made in 2021 as a school project with the view of the pandemic to help users not to get in direct contact with those providing the fuel service. '),
                    ),
                  );
                },
                splashColor: Colors.orange,
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.question_answer_outlined,
                        size: 70.0,
                      ),
                      Text(
                        'About Us',
                        style: TextStyle(fontSize: 17.0),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Card(
              margin: EdgeInsets.all(8.0),
              child: InkWell(
                onTap: () async {
                  await _auth.signOut().then((result) {
                    Navigator.of(context).pop(true);
                  });
                },
                splashColor: Colors.orange,
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.verified_user_rounded,
                        size: 70.0,
                      ),
                      Text(
                        'Logout',
                        style: TextStyle(fontSize: 17.0),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
