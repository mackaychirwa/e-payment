import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:total_load_up/auth/login.dart';
import 'package:total_load_up/classes/AuthService.dart';
import 'package:total_load_up/global/loading.dart';

class Forgot extends StatefulWidget {
  const Forgot({Key key}) : super(key: key);

  @override
  _ForgotState createState() => _ForgotState();
}

class _ForgotState extends State<Forgot> {
  final _key = GlobalKey<FormState>();
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

  final FirebaseAuth _auth = FirebaseAuth.instance;

  // final AuthService _auth = AuthService();

  TextEditingController _emailResetController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: true,
            ),
            body: SingleChildScrollView(
              child: Form(
                key: _key,
                child: Container(
                  child: Column(
                    children: [
                      Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 25, vertical: 15),
                        child: TextFormField(
                          controller: _emailResetController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            prefixIcon: Icon(
                              Icons.mail,
                              color: Colors.black,
                              size: 20,
                            ),
                            labelText: 'Email',
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                              color: Colors.black,
                            )),
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) =>
                              value.isEmpty ? 'Email Cannot be blank' : null,
                        ),
                      ),
                      SizedBox(height: 25),
                      Container(
                        height: 60,
                        width: MediaQuery.of(context).size.width / 1.2,
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 0, horizontal: 15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              TextButton(
                                child: Text(
                                  'Reset Password',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                onPressed: () {
                                  if (_key.currentState.validate()) {
                                    setState(() {
                                      loading = true;
                                    });
                                    _auth.sendPasswordResetEmail(
                                        email: _emailResetController.text);

                                    setState(() {
                                      loading = false;
                                    });
                                    Navigator.of(context).pop(true);
                                  }
                                },
                              ),
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
            ),
          );
  }
}
