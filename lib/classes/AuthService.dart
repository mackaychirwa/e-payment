import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:total_load_up/classes/DatabaseManager.dart';
import 'package:total_load_up/global/userDetails.dart';

final AuthService authService = AuthService();

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future createNewUser(
    String _fullname,
    String _email,
    String _password,
    String _confirmpassword,
    String _phonenumber,
    String _address,
  ) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: _email, password: _password);
      User user = result.user;
      await DatabaseManager().createUserData(
          _fullname, _confirmpassword, _phonenumber, _address, user.uid);
      await DatabaseManager().walletData(user.uid);

      return result.user;
    } catch (e) {
      print(e.toString());
    }
  }

  Future createAttendantUser(String _fullname, String _email, String _password,
      String _confirmpassword, String _phonenumber, String _address) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: _email, password: _password);

      await DatabaseAttendantManager().createUserData(
          _fullname, _confirmpassword, _phonenumber, _address, result.user.uid);

      return result.user;
    } catch (e) {
      print(e.toString());
    }
  }

  Future loginUser(String email, String password) async {
    try {
      // if user account number available login if not dialog boc wait for account number
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(result.user.uid)
          .get();
      UserDetails().uid = result.user.uid;
      return result.user;
    } catch (e) {
      print(e.toString());
    }
  }

  Future signOut() async {
    try {
      return _auth.signOut();
    } catch (error) {
      print(error.toString());
      return null;
    }
  }

  Future forgot(String email) async {
    try {
      return await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      print(e);
    }
  }

  Future<User> getUser() async {
    return _auth.currentUser;
  }

  Future<String> getUserID() async {
    final User u = _auth.currentUser;
    String uid = u.uid;
    print(uid);
    return uid;
  }

  Future<String> getCurrentUID() async {
    String uid = (await _auth.currentUser).uid;
    return uid;
  }
}
