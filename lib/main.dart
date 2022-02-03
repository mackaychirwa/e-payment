import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:total_load_up/blocs/app_bloc.dart';
import 'package:total_load_up/classes/DatabaseManager.dart';
// import 'animations/BouncyPageRoute.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(ChangeNotifierProvider(
    create: (context) => Applicationbloc(),
    child: MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Total FillUp',
      theme: ThemeData(
          primarySwatch: Colors.blue,
          accentColor: Colors.red,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          fontFamily: 'Montserrat'),
      home: UserManagement().handleAuth(),
    ),
  ));
}
