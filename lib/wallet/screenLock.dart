import 'dart:async';

import 'package:passcode_screen/circle.dart';
import 'package:passcode_screen/keyboard.dart';
import 'package:passcode_screen/passcode_screen.dart';
import 'package:flutter/material.dart';

class ScreenLock extends StatefulWidget {
  const ScreenLock({Key key}) : super(key: key);

  @override
  _ScreenLockState createState() => _ScreenLockState();
}

class _ScreenLockState extends State<ScreenLock> {
  final StreamController<bool> _verificationNotifier =
      StreamController<bool>.broadcast();

  bool isAuthenticated = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Your are ${isAuthenticated ? '' : 'NOT'} authenticated'),
            _defaultLockScreenButton(context),
            _customColorsLockScreenButton(context),
          ],
        ),
      ),
    );
  }

  _defaultLockScreenButton(BuildContext context) => MaterialButton(
      child: Text('Open Default Lock Screen'),
      color: Theme.of(context).primaryColor,
      onPressed: () {
        _showLockScreen(context, opaque: false);
      });
  _customColorsLockScreenButton(BuildContext context) => MaterialButton(
      child: Text('Open Default Lock Screen'),
      color: Theme.of(context).primaryColor,
      onPressed: () {
        _showLockScreen(context,
            opaque: false,
            circleUIConfig: CircleUIConfig(
                borderColor: Colors.blue,
                fillColor: Colors.blue,
                circleSize: 30),
            keyboardUIConfig: KeyboardUIConfig(
                digitBorderWidth: 2, primaryColor: Colors.blue));
      });

  _showLockScreen(BuildContext context,
      {bool opaque,
      CircleUIConfig circleUIConfig,
      KeyboardUIConfig keyboardUIConfig}) {
    Navigator.push(
        context,
        PageRouteBuilder(
          opaque: opaque,
          pageBuilder: (context, animation, secondaryAnimation) =>
              PasscodeScreen(
            title: Text('Enter App Code'),
            circleUIConfig: circleUIConfig,
            keyboardUIConfig: keyboardUIConfig,
            passwordEnteredCallback: _onPasscodeEntered,
            shouldTriggerVerification: _verificationNotifier.stream,
            backgroundColor: Colors.black.withOpacity(0.8),
            cancelCallback: _onPasscodeCancelled,
            cancelButton: Text('Cancel'),
            deleteButton: Text('Delete'),
          ),
        ));
  }

  _onPasscodeEntered(String enteredPasscode) {
    bool isValid = '123456' == enteredPasscode;
    _verificationNotifier.add(isValid);
    if (isValid) {
      setState(() {
        this.isAuthenticated = isValid;
      });
    }
  }

  _onPasscodeCancelled() {}
  void dispose() {
    _verificationNotifier.close();
    super.dispose();
  }
}
