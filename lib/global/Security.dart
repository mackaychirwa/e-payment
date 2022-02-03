import 'package:flutter/material.dart';
import 'package:total_load_up/screens/PaymentDetails.dart';

class Security extends StatefulWidget {
  @override
  _SecurityState createState() => _SecurityState();
}

class _SecurityState extends State<Security> {
  final _key = GlobalKey<FormState>();

  TextEditingController _passController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Center(
        child: AlertDialog(
          title: Text(
            'Please Enter Your pin',
            style: TextStyle(color: Colors.black),
          ),
          actions: [
            TextButton(
                onPressed: () async {
                  if (_passController.text == '12345') {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PaymentDetails()));
                  } else {
                    return AlertDialog(title: Text('Wrong Password'));
                  }
                },
                child: Text('Ok')),
          ],
          content: Form(
            key: _key,
            child: Column(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                  child: TextFormField(
                    controller: _passController,
                    obscureText: true,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.mail,
                        color: Colors.black,
                        size: 20,
                      ),
                      labelText: 'Password',
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                        color: Colors.black,
                      )),
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) =>
                        value.isEmpty ? 'Passoword Cannot be blank' : null,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
