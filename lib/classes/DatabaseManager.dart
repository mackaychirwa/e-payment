import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:total_load_up/animations/BouncyPageRoute.dart';
import 'package:total_load_up/screens/screens.dart';

class DatabaseManager {
  final user = FirebaseAuth.instance.currentUser;
  final db = FirebaseFirestore.instance;
  final history = FirebaseFirestore.instance.collection('Transactions');

  // ignore: non_constant_identifier_names
  final CollectionReference UsersList =
      FirebaseFirestore.instance.collection("Users");
  Future<void> createUserData(
    String _fullname,
    String _phonenumber,
    String _address,
    String _confirmpassword,
    String uid,
  ) async {
    return await UsersList.doc(uid).set({
      'uid': uid,
      'fullname': _fullname,
      'phoneNumber': _phonenumber,
      'address': _address,
      'confirmPassword': _confirmpassword,
      'accountNumber': '',
      'money': 0,
      'role': 'customer',
      'avatar': ''
    });
  }

  final CollectionReference walletList =
      FirebaseFirestore.instance.collection("wallet");

  Future<void> walletData(
    String uid,
  ) async {
    return await walletList.doc(uid).set({
      'Reason for Transfer': 'none',
      'WalletName': 'Airtel Money',
      'money': 200000,
      'uid': uid,
      'username': user.displayName,
    });
  }

  Future getUsers() async {
    List itemsList = [];
    try {
      await UsersList.get().then((querySnapshot) {
        querySnapshot.docs.forEach((element) {
          itemsList.add(element.data);
        });
      });
      return itemsList;
    } catch (e) {
      print.toString();
      return null;
    }
  }

  Future getTransactionHistory() async {
    List historyList = [];

    try {
      await history.get().then((querySnapshot) {
        querySnapshot.docs.forEach((element) {
          historyList.add(element.data);
        });
      });
      return historyList;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}

class DatabaseAttendantManager {
  // ignore: non_constant_identifier_names
  final CollectionReference UsersList =
      FirebaseFirestore.instance.collection("Users");
  Future<void> createUserData(String _fullname, String _phonenumber,
      String _address, String _confirmpassword, String uid) async {
    return await UsersList.doc(uid).set({
      'fullname': _fullname,
      'phoneNumber': _phonenumber,
      'address': _address,
      'confirmPassword': _confirmpassword,
      'role': 'attendant'
    });
  }
}

class Role {
  String role;
  Role({this.role});
  Role.fromMap(Map<String, dynamic> data) {
    role = data['role'];
  }
}

class UserManagement {
  Widget handleAuth() {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (BuildContext context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return SplashScreen();
        }
        if (snapshot.hasData) {
          return BottomNavBar();
        }
        return SplashScreen();
      },
    );
  }
}

class QrData {
  final String locationMessage;
  final int controller;

  const QrData({this.locationMessage, this.controller});
}

class PassreceiptQR {
  final String transactionid,
      timedate,
      recipientemail,
      recipientuid,
      recipientreference;
  final int amount;

  const PassreceiptQR({
    this.transactionid,
    this.timedate,
    this.recipientemail,
    this.recipientuid,
    this.recipientreference,
    this.amount,
  });
}

class PassdataQR {
  final String email;
  const PassdataQR({
    this.email,
  });
}
