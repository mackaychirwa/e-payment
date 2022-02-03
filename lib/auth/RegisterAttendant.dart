import 'package:flutter/material.dart';
import 'package:toast/toast.dart';
import 'package:total_load_up/auth/login.dart';
import 'package:total_load_up/colors/color.dart';
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

class RegisterAttendantPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterAttendantPage> {
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

  final AuthService _auth = AuthService();

  String _fullname;
  String _email;
  String _phonenumber;
  String _address;
  String _password;
  String _confirmpassword;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                            onSaved: (value) => _fullname = value,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 25, vertical: 15),
                          child: TextFormField(
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
                            onSaved: (value) => _email = value,
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
                            onSaved: (value) => _phonenumber = value,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 25, vertical: 15),
                          child: TextFormField(
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
                            onSaved: (value) => _address = value,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 25, vertical: 15),
                          child: TextFormField(
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
                            onSaved: (value) => _password = value,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 25, vertical: 15),
                          child: TextFormField(
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
                            onSaved: (value) => _confirmpassword = value,
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
                                      'Register',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    onPressed: () {
                                      createUser();
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
    if (validate()) {
      try {
        dynamic result = await _auth.createAttendantUser(_fullname, _email,
            _password, _phonenumber, _address, _confirmpassword);
        if (result != null) {
          print('Register');
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => LoginPage()));
        } else {
          Toast.show('Please Check your internet connection', context,
              duration: 15, gravity: Toast.CENTER);
          print(result.toString());
          Navigator.pop(context);
        }
      } catch (e) {
        print(e);
      }
    }
  }
}
