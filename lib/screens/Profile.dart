import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:toast/toast.dart';
// import 'package:file_picker/file_picker.dart';
import 'package:total_load_up/CustomWidgets/Widgets.dart';
import 'package:total_load_up/screens/account.dart';
import 'package:path/path.dart' as Path;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:permission_handler/permission_handler.dart';
import 'package:total_load_up/screens/bottom_nav.dart';

class Profile extends StatefulWidget {
  const Profile({Key key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();
  final auth = FirebaseAuth.instance;
  final user = FirebaseAuth.instance.currentUser;
  final db = FirebaseFirestore.instance;
  bool loading = false;
  TextEditingController _name = TextEditingController();
  TextEditingController _email = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();
  var idListForSender = [];
  var idListForRecipient = [];
  final ImagePicker _picker = ImagePicker();
  File file;

  @override
  Widget build(BuildContext context) {
    final fileName =
        file != null ? Path.basename(file.path) : 'No File Selected';
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue[600],
          elevation: 0.0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            iconSize: 28.0,
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => BottomNavBar()));
            },
          ),
          title: Text('Edit Profile'),
          centerTitle: true,
        ),
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Container(
                child: Center(
                  child: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                      stream: FirebaseFirestore.instance
                          .collection('Users')
                          .doc(user.uid)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return CircularProgressIndicator();
                        } else {
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              SizedBox(height: 13),
                              Stack(children: <Widget>[
                                Align(
                                  alignment: Alignment.topCenter,
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 10),
                                  ),
                                ),
                              ]),
                              Container(
                                margin: EdgeInsets.symmetric(vertical: 10),
                                child: Row(
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.all(10),
                                    ),
                                    Expanded(child: Divider()),
                                  ],
                                ),
                              ),
                              SizedBox(height: 5),
                              Text(
                                'Current Avatar:',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.black54,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: 5),
                              StreamBuilder<
                                      DocumentSnapshot<Map<String, dynamic>>>(
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
                              SizedBox(height: 10),
                              ElevatedButton(
                                child: Text(
                                  'Change Avatar',
                                  style: TextStyle(color: Colors.white),
                                ),
                                onPressed: () => updateAvatar(context),
                              ),
                              Container(
                                margin: EdgeInsets.symmetric(vertical: 10),
                                child: Row(
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.all(10),
                                    ),
                                    Expanded(child: Divider()),
                                  ],
                                ),
                              ),
                              StreamBuilder<
                                      DocumentSnapshot<Map<String, dynamic>>>(
                                  stream: FirebaseFirestore.instance
                                      .collection('Users')
                                      .doc(user.uid)
                                      .snapshots(),
                                  builder: (context, snapshot) {
                                    if (!snapshot.hasData) {
                                      return CircularProgressIndicator();
                                    } else {
                                      return Text(
                                        'Current Name: ${snapshot.data.data()['fullname'].toString()}',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.black54,
                                        ),
                                        textAlign: TextAlign.center,
                                      );
                                    }
                                  }),
                              SizedBox(height: 5),
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 20, right: 20),
                                child: Form(
                                  key: _formKey,
                                  child: TextFormField(
                                    controller: _name,
                                    decoration: InputDecoration(
                                      enabledBorder: const OutlineInputBorder(
                                        // width: 0.0 produces a thin "hairline" border
                                        borderSide: const BorderSide(
                                            color: Colors.grey, width: 0.0),
                                      ),
                                      border: const OutlineInputBorder(),
                                      hintText: 'Name',
                                      helperText: 'Enter new name',
                                    ),
                                    validator: (value) => value.isEmpty
                                        ? 'New Name Cannot be blank'
                                        : null,
                                  ),
                                ),
                              ),
                              SizedBox(height: 15),
                              ElevatedButton(
                                child: Text(
                                  'Change Name',
                                  style: TextStyle(color: Colors.white),
                                ),
                                onPressed: () {
                                  if (_formKey.currentState.validate())
                                    return updateName();
                                },
                              ),
                              Container(
                                margin: EdgeInsets.symmetric(vertical: 10),
                                child: Row(
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.all(10),
                                    ),
                                    Expanded(child: Divider()),
                                  ],
                                ),
                              ),
                              Text(
                                'Email:',
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center,
                              ),
                              Text(
                                '${user.email}',
                                style: TextStyle(fontSize: 15),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: 15),
                              ElevatedButton(
                                child: Text(
                                  'Update Email',
                                  style: TextStyle(color: Colors.white),
                                ),
                                onPressed: () {
                                  updateEmailModal();
                                },
                              ),
                              Container(
                                margin: EdgeInsets.symmetric(vertical: 10),
                                child: Row(
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.all(10),
                                    ),
                                    Expanded(child: Divider()),
                                  ],
                                ),
                              ),
                              Text(
                                'User Id:',
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center,
                              ),
                              Text(
                                '${user.uid}',
                                style: TextStyle(fontSize: 15),
                                textAlign: TextAlign.center,
                              ),
                              Container(
                                margin: EdgeInsets.symmetric(vertical: 10),
                                child: Row(
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.all(10),
                                    ),
                                    Expanded(child: Divider()),
                                  ],
                                ),
                              ),
                            ],
                          );
                        }
                      }),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  updateName() async {
    await db.collection('Users').doc(user.uid).update({
      'fullname': _name.text,
    }).then((_) {
      Toast.show('Name Updated', context, duration: 5, gravity: Toast.CENTER);
      PushReplaceTo(context, Account());
    });
  }

  updateEmailModal() async {
    showModalBottomSheet(
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      context: context,
      builder: (builder) {
        return Container(
          height: MediaQuery.of(context).size.height / 1.6,
          decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
          child: Stack(
            children: <Widget>[
              Container(
                alignment: Alignment.topCenter,
                padding: EdgeInsets.all(10),
                child: Icon(Icons.drag_handle),
              ),
              Align(
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(height: 25),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 10),
                      child: Row(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(10),
                          ),
                          Expanded(child: Divider()),
                        ],
                      ),
                    ),
                    Text(
                      'Current Email: ${user.email}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.black54,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 5),
                    Padding(
                      padding: const EdgeInsets.only(left: 20, right: 20),
                      child: Form(
                        key: _formKey2,
                        child: TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          controller: _email,
                          decoration: InputDecoration(
                            enabledBorder: const OutlineInputBorder(
                              // width: 0.0 produces a thin "hairline" border
                              borderSide: const BorderSide(
                                  color: Colors.grey, width: 0.0),
                            ),
                            border: const OutlineInputBorder(),
                            hintText: 'Email',
                            helperText: 'Enter new email',
                          ),
                          validator: (value) =>
                              value.isEmpty ? 'Email Cannot be blank' : null,
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 10),
                      child: Row(
                        children: <Widget>[
                          Expanded(child: Divider()),
                          Padding(
                            padding: const EdgeInsets.all(10),
                          ),
                          Expanded(child: Divider()),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      child: Text(
                        'Update Email',
                        style: TextStyle(color: Colors.black),
                      ),
                      onPressed: () async {
                        if (_formKey2.currentState.validate())
                          return updateEmail();
                      },
                    ),
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }

  updateAvatar(BuildContext context) {
    showModalBottomSheet(
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      context: context,
      builder: (builder) {
        return Container(
          height: MediaQuery.of(context).size.height / 6.4,
          decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
          child: Stack(
            children: <Widget>[
              Container(
                alignment: Alignment.topCenter,
                padding: EdgeInsets.all(10),
                child: Icon(Icons.drag_handle),
              ),
              Align(
                alignment: Alignment.topCenter,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(height: 25),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 10),
                      child: Row(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(10),
                          ),
                          Expanded(child: Divider()),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 25),
              Align(
                child: Padding(
                  padding: const EdgeInsets.only(top: 30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      TextButton.icon(
                        icon: Icon(Icons.image),
                        label: Text('Gallery'),
                        onPressed: () {
                          getAvatar(ImageSource.gallery);
                          Toast.show('Please press save to continue', context,
                              duration: 15, gravity: Toast.CENTER);
                        },
                      ),
                      SizedBox(width: 45),
                      TextButton.icon(
                        icon: Icon(Icons.save),
                        label: Text('Save'),
                        onPressed: () async {
                          uploadAvatar();
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future getAvatar(ImageSource source) async {
    // var permissionStatus; = requestPermissions();
    var permissionStatus;

    // MOBILE
    if (!kIsWeb && await permissionStatus.isGranted) {
      final ImagePicker _picker = ImagePicker();
      XFile result = await _picker.pickImage(source: ImageSource.gallery);

      if (result == null) return;
      if (result != null) {
        var path = File(result.path);
        setState(() => file = path);
      }
    }
  }

  Future uploadAvatar() async {
    if (file == null) return;

    final fileName = Path.basename(file.path);
    final destination = 'assets/images/${user.uid}/$fileName';

    FirebaseApi.uploadFile(destination, file);
    String downloadUrl = await firebase_storage.FirebaseStorage.instance
        .ref(destination)
        .getDownloadURL();
    print(downloadUrl);
    await db.collection('Users').doc(user.uid).update({
      'avatar': downloadUrl,
    }).then((_) =>
        Toast.show('Uploaded', context, duration: 5, gravity: Toast.CENTER));
  }

  updateEmail() async {
    try {
      await user.updateEmail(_email.text).then((value) => print('Success'));
      await db.collection('Users').doc(user.uid).update({
        'email': _email.text,
      }).then((_) async {
        var senderEmailRef = await db
            .collection('Transactions')
            .where('SenderEmail', isEqualTo: user.email.toString())
            .get();
        senderEmailRef.docs.forEach((element) {
          idListForSender.add(element.id);
          print("ID SENDER: " + element.id.toString());
        });

        var recipientEmailRef = await db
            .collection('Transactions')
            .where('RecipientEmail', isEqualTo: user.email.toString())
            .get();
        recipientEmailRef.docs.forEach((element) {
          idListForRecipient.add(element.id);
          print("ID RECIPIENT: " + element.id.toString());
        });

        WriteBatch batch = db.batch();
        for (var i = 0; i < idListForSender.length; i++) {
          var senderAccouunt =
              db.collection('Transactions').doc(idListForSender[i].toString());
          batch.update(senderAccouunt, {"SenderEmail": _email.text.toString()});
          print(i.toString() +
              " IDLISTFORSENDER: " +
              idListForSender[i].toString());
        }

        for (var i = 0; i < idListForRecipient.length; i++) {
          var recipientAccount = db
              .collection('Transactions')
              .doc(idListForRecipient[i].toString());
          batch.update(
              recipientAccount, {"RecipientEmail": _email.text.toString()});
          print(i.toString() +
              " IDLISTFORRECIPIENT: " +
              idListForRecipient[i].toString());
        }

        await batch.commit();
        Toast.show('Email Updated', context,
            duration: 5, gravity: Toast.CENTER);
        // wPushReplaceTo(context, Account());
      });
    } on FirebaseAuthException catch (e) {
      return Toast.show(e.message.toString(), context,
          duration: 15, gravity: Toast.CENTER);
    }
  }
}

class FirebaseApi {
  static UploadTask uploadFile(String destination, file) {
    try {
      final ref = FirebaseStorage.instance.ref(destination);

      return ref.putFile(file);
    } on FirebaseException {
      return null;
    }
  }
}
