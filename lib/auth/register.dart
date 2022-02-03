import 'package:flutter/material.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';
import 'package:toast/toast.dart';
import 'package:total_load_up/auth/login.dart';
import 'package:total_load_up/colors/color.dart';
import 'package:total_load_up/global/loading.dart';
import '../classes/AuthService.dart';

const kTextFieldDecoration = InputDecoration(
  hintStyle: TextStyle(color: Colors.white, fontSize: 20.0),
  contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
  filled: true,
  fillColor: Color.fromRGBO(225, 0, 50, 1),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(10)),
    borderSide: BorderSide.none,
  ),
);

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  sendMail() async {
    String username = 'bonitokay@gmail.com';
    String password = '@Chriskay1@';

    final smtpServer = gmail(username, password);
    final message = Message()
      ..from = Address(username, 'Total Malawi')
      ..recipients.add(_emailController.text)
      ..subject = "Automated-Message"
      ..text = 'Dear ${_fullnameController.text}.\n'
      ..html =
          "<p>Dear ${_fullnameController.text}</p>\n<br>p>We are glad to have you register with Total Malawi, please enjoy the services we offer.\n<br>\nTotal Malawi Team<br><p>admin@total.com</p>";

    try {
      final sendReport = await send(message, smtpServer);
      print('message sent: ' + sendReport.toString());
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(
            'Email',
            style: TextStyle(color: Colors.black),
          ),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(context), child: Text('Ok')),
          ],
          content: Text('Email has been sent to you '),
        ),
      );
      // Toast.show('Please Check your email', context,
      //     duration: 15, gravity: Toast.CENTER);
    } on MailerException catch (e) {
      print(e);
      for (var p in e.problems) {
        print('problem: ${p.code}: ${p.msg}');
      }
    }
  }

  final _key = GlobalKey<FormState>();
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

  TextEditingController _emailController = TextEditingController();
  TextEditingController _fullnameController = TextEditingController();
  TextEditingController _phonenumberController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmpasswordController = TextEditingController();
  final AuthService _auth = AuthService();
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Scaffold(
            body: Container(
              child: SingleChildScrollView(
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
                                  controller: _fullnameController,
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return "Name can not be empty.";
                                    } else {
                                      return null;
                                    }
                                  },
                                  decoration: InputDecoration(
                                    prefixIcon: Icon(
                                      Icons.person,
                                      color: Colors.black,
                                      size: 20,
                                    ),
                                    labelText: 'FullName',
                                    enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                      color: Colors.black,
                                    )),
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 25, vertical: 15),
                                child: TextFormField(
                                  controller: _emailController,
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return "Email can not be empty.";
                                    } else {
                                      return null;
                                    }
                                  },
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
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 25, vertical: 5),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 25, vertical: 15),
                                child: TextFormField(
                                  controller: _phonenumberController,
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return "Number can not be empty.";
                                    } else {
                                      return null;
                                    }
                                  },
                                  keyboardType: TextInputType.phone,
                                  decoration: InputDecoration(
                                    prefixText: '+265',
                                    prefixIcon: Icon(
                                      Icons.phone,
                                      color: Colors.black,
                                      size: 20,
                                    ),
                                    labelText: 'Phone Number',
                                    enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                      color: Colors.black,
                                    )),
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 25, vertical: 15),
                                child: TextFormField(
                                  controller: _addressController,
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return "Address can not be empty.";
                                    } else {
                                      return null;
                                    }
                                  },
                                  keyboardType: TextInputType.streetAddress,
                                  decoration: InputDecoration(
                                    prefixIcon: Icon(
                                      Icons.location_on,
                                      color: Colors.black,
                                      size: 20,
                                    ),
                                    labelText: 'Address',
                                    enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                      color: Colors.black,
                                    )),
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 25, vertical: 15),
                                child: TextFormField(
                                  controller: _passwordController,
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return "Password can not be empty.";
                                    } else {
                                      return null;
                                    }
                                  },
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
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 25, vertical: 15),
                                child: TextFormField(
                                  controller: _confirmpasswordController,
                                  validator: (value) {
                                    if (_passwordController ==
                                        _confirmpasswordController) {
                                      return "password is correct";
                                    }
                                    if (value.isEmpty) {
                                      return "Please fill password can not be empty.";
                                    } else {
                                      return null;
                                    }
                                  },
                                  obscureText: true,
                                  decoration: InputDecoration(
                                    prefixIcon: Icon(
                                      Icons.lock,
                                      color: Colors.black,
                                      size: 20,
                                    ),
                                    labelText: 'Confirm Password',
                                    enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                      color: Colors.black,
                                    )),
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 25,
                              ),
                              Container(
                                height: 60,
                                width: MediaQuery.of(context).size.width / 1.2,
                                decoration: BoxDecoration(
                                  color: Color.fromARGB(255, 205, 53, 44),
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
                                            'Register',
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
                                              createUser();

                                              setState(() {
                                                loading = false;
                                              });
                                            }
                                          }),
                                      Icon(
                                        Icons.keyboard_arrow_right_sharp,
                                        color: Colors.white,
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 25,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 50),
                                child: TextButton(
                                  child: Text(
                                    'Already Have an account? Login',
                                    style: TextStyle(
                                      fontSize: 17,
                                      color: Colors.black,
                                    ),
                                  ),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => LoginPage()));
                                  },
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
  }

  void createUser() async {
    try {
      dynamic result = await _auth.createNewUser(
          _fullnameController.text,
          _emailController.text,
          _passwordController.text,
          _phonenumberController.text,
          _addressController.text,
          _confirmpasswordController.text);
      if (result != null) {
        await sendMail();
        print('Register');
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => LoginPage()));
        _fullnameController.clear();
        _addressController.clear();
        _passwordController.clear();
        _confirmpasswordController.clear();
        _emailController.clear();
        _phonenumberController.clear();
      } else {
        Toast.show('Please Check your internet connection', context,
            duration: 5, gravity: Toast.CENTER);
        print(result.toString());
        Navigator.pop(context);
      }
    } catch (e) {
      print(e);
    }
  }
}
