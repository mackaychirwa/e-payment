import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';

class FingerPrint extends StatefulWidget {
  FingerPrint({Key key}) : super(key: key);

  @override
  _FingerPrintState createState() => _FingerPrintState();
}

class _FingerPrintState extends State<FingerPrint> {
 
LocalAuthentication authent = LocalAuthentication();
  bool _canCheckBiometrics;
  List<BiometricType> _availableBiometrics;
  String _authorized = 'Not Authorized';

Future<String> _authenticate() async {
  bool _isAuthenticated = false;
  try {
    _isAuthenticated = await authent.authenticate(
      localizedReason: 'Please scan your biometric or use PIN to continue',
      useErrorDialogs: true,
      stickyAuth: true,
    );
  } on PlatformException catch (e) {
    print(e.message);
  }

  if (_isAuthenticated) {
    return "Authenticated";
  }
  return "Failed";
}

Future<void> _checkBiometrics() async {
  bool canCheckBiometrics;
  try {
    canCheckBiometrics = await authent.canCheckBiometrics;
  } on PlatformException catch (e) {
    print(e);
  }
  if (!mounted) return;
  setState(() {
    _canCheckBiometrics = canCheckBiometrics;
  });
}

Future<void> _getAvailableBiometrics() async {
  List<BiometricType> availableBiometrics;
  try {
    availableBiometrics = await authent.getAvailableBiometrics();
  } on PlatformException catch (e) {
    print(e);
  }
  if (!mounted) return;
  setState(() {
    _availableBiometrics = availableBiometrics;
  });
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('fingerprint'),),
      body: Container(
         child: Center(
           child: MaterialButton(
              onPressed: () async {
        
               await _getAvailableBiometrics();
                _authenticate();
              },
              child: Text('Daily Register ')
              ),
         ),
      ),
    );
  }
}