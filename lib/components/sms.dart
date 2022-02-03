import 'package:flutter/material.dart';
import 'package:twilio_flutter/twilio_flutter.dart';


class SendSms extends StatefulWidget {
  const SendSms({Key key}) : super(key: key);

  @override
  _SendSmsState createState() => _SendSmsState();
}

class _SendSmsState extends State<SendSms> {
   TwilioFlutter twilioFlutter;
  @override
  void initState() {
    twilioFlutter = TwilioFlutter(
        accountSid: 'ACe09887bf28e6cf32bc48bcdfb91b1f39',
        authToken: 'ebc6c3ff6aa4fa1b3911d6a07fd1aaf4',
        twilioNumber: '+17085016720');
    super.initState();
  }
  void sendSms() async {
    twilioFlutter.sendSMS(
        toNumber: ' +265998242877', messageBody: 'Hi.\n Your Next.');
        print('Sent Succesful');
  }
  void getSms() async {
    var data = await twilioFlutter.getSmsList();
    print(data);
    await twilioFlutter.getSMS('***************************');
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('hello'),
        centerTitle: true,
      ),
      body: Center(
        child: Text(
          'Press the button to send SMS.',
          style: TextStyle(
              color: Colors.black,
              fontSize: 16
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: sendSms,
        tooltip: 'Send Sms',
        child: Icon(Icons.send),
      ),
    );
  }
}
