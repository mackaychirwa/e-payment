import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';

import 'package:total_load_up/ServiceStation/serviceStationDash.dart';
import 'package:total_load_up/auth/register.dart';
import 'package:total_load_up/colors/color.dart';

import 'package:total_load_up/fuelattendant/attendant_dashboard.dart';
import 'package:total_load_up/global/loading.dart';
import 'package:total_load_up/screens/bottom_nav.dart';
import 'package:total_load_up/screens/forgotPassword.dart';

import '../classes/AuthService.dart';

const kTextFieldDecoration = InputDecoration(
  hintStyle: TextStyle(color: Colors.white, fontSize: 20.0),
  contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
  filled: true,
  fillColor: Colors.red,
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(10)),
    borderSide: BorderSide.none,
  ),
);

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
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

  final AuthService _auth = AuthService();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Scaffold(
            body: SingleChildScrollView(
              child: Container(
                child: Column(
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height * 0.4,
                      decoration: BoxDecoration(
                        color: greyColors,
                      ),
                      child: Center(
                        child: Image.asset("assets/images/logo.png"),
                      ),
                    ),
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
                                  controller: _emailController,
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
                                  validator: (value) => value.isEmpty
                                      ? 'Email Cannot be blank'
                                      : null,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 25, vertical: 15),
                                child: TextFormField(
                                  controller: _passwordController,
                                  obscureText: true,
                                  decoration: InputDecoration(
                                    prefixIcon: Icon(
                                      Icons.lock,
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
                                  validator: (value) => value.isEmpty
                                      ? 'Password Cannot be blank'
                                      : null,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextButton(
                                  child: Text(
                                    'Forgot Password',
                                    style: TextStyle(
                                        fontSize: 18, color: Colors.black),
                                  ),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => Forgot()));
                                  },
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
                                          'Sign In',
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
                                            loginUser();
                                            if (loginUser == null) {
                                              setState(() {
                                                loading = false;
                                              });
                                            }
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
                              Padding(
                                padding: const EdgeInsets.only(top: 50),
                                child: TextButton(
                                  child: Text(
                                    'Don\'t have an account? Sign UP',
                                    style: TextStyle(
                                      fontSize: 17,
                                      color: Colors.black,
                                    ),
                                  ),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                RegisterPage()));
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
  }

  void loginUser() async {
    if (validate()) {
      try {
        dynamic result = await _auth.loginUser(
            _emailController.text, _passwordController.text);
        if (result != null) {
          await FirebaseFirestore.instance
              .collection("Users")
              .doc(result.uid)
              .get()
              .then((doc) => {
                    if (doc.get("role") == "customer")
                      {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (BuildContext context) => BottomNavBar()))
                      }
                    else if (doc.get("role") == "attendant")
                      {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (BuildContext context) => AttendantDash()))
                      }
                    else if (doc.get("role") == "manager")
                      {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (BuildContext context) =>
                                ServiceDashBoard()))
                      }
                  });

          _emailController.clear();
          _passwordController.clear();
        } else {
          Error();
        }
      } catch (e) {
        print(e);
      }
    }
  }
}
