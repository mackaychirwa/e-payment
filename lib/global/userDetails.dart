import 'package:cloud_firestore/cloud_firestore.dart';

class UserDetails {
  String fullname;
  String phonenumber;
  String address;
  String uid;

  UserDetails({this.fullname, this.phonenumber, this.address, this.uid});

  UserDetails.fromDocumentSnapshot(DocumentSnapshot doc) {
    uid = doc.id;
    fullname = doc['fullname'];
    phonenumber = doc['phoneNumber'];
    address = doc['address'];
  }
}

class Details {
  String fullname;
  String phonenumber;
  String address;
  String uid;

  Details({this.fullname, this.phonenumber, this.address, this.uid});
  Details.fromMap(Map<String, dynamic> data) {
    uid = data['uid'];
    fullname = data['fullname'];
    phonenumber = data['phoneNumber'];
    address = data['address'];
  }
}
