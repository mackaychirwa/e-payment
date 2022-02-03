import 'package:flutter/material.dart';
import 'package:total_load_up/auth/login.dart';
import 'package:total_load_up/classes/AuthService.dart';
import 'package:total_load_up/global/loading.dart';

class Logout extends StatefulWidget {
  Logout({Key key}) : super(key: key);

  @override
  _LogoutState createState() => _LogoutState();
}

class _LogoutState extends State<Logout> {
  final AuthService _auth = AuthService();
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Center(
            child: OutlinedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text(
                      'Logout',
                      style: TextStyle(color: Colors.black),
                    ),
                    actions: [
                      TextButton(
                          onPressed: () async {
                            setState(() {
                              loading = true;
                            });
                            await _auth.signOut().then((result) {
                              setState(() {
                                loading = false;
                              });
                              Navigator.of(context).pop(true);
                            });
                          },
                          child: Text('Yes')),
                      TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text('No')),
                    ],
                    content: Text('Are you sure you want to Logout'),
                  ),
                );
              },
              child: Text('Tap to Logout'),
            ),
          );
  }
}
