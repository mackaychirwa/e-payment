import 'package:flutter/material.dart';
import 'package:total_load_up/CustomWidgets/CustomAppBar.dart';

class AlertBox extends StatefulWidget {
  AlertBox({Key key}) : super(key: key);

  @override
  _AlertBoxState createState() => _AlertBoxState();
}

class _AlertBoxState extends State<AlertBox> {
    final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
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
      body: Center(
        child: OutlinedButton(
          onPressed: () {
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
                content: Text('Total Fill up is an application that was made in 2021 as a school project with the view of the pandemic to help\n users not to get in direct contact with those providing the fuel service. '),
              ),
            );
          },
          child: Text('Body'),
        ),
      ),
    );
  }
}
