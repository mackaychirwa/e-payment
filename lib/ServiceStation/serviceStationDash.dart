import 'package:flutter/material.dart';
import 'package:total_load_up/ServiceStation/report.dart';
import 'package:total_load_up/auth/RegisterAttendant.dart';
import 'package:total_load_up/classes/AuthService.dart';

import 'MonthlyReport.dart';
import 'WeeklyReport.dart';
import 'dailyReport.dart';

class ServiceDashBoard extends StatefulWidget {
  const ServiceDashBoard({Key key}) : super(key: key);

  @override
  _ServiceDashBoardState createState() => _ServiceDashBoardState();
}

class _ServiceDashBoardState extends State<ServiceDashBoard> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final AuthService _auth = AuthService();
  @override
  Widget build(BuildContext context) {
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
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Daily()));
                },
                splashColor: Colors.orange,
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.date_range,
                        size: 70.0,
                      ),
                      Text(
                        'Daily Sales',
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
                      MaterialPageRoute(builder: (context) => Weekly()));
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
                        'Weekly Sales',
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
                      MaterialPageRoute(builder: (context) => Monthly()));
                },
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
                        'Monthly Work',
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
                      MaterialPageRoute(builder: (context) => SalesHomePage()));
                },
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
                        'Year Report',
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
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => RegisterAttendantPage()));
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
                        'Create User',
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
