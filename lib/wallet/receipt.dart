import 'package:flutter/material.dart';
import 'package:total_load_up/CustomWidgets/Widgets.dart';
import 'package:total_load_up/classes/DatabaseManager.dart';
import 'package:total_load_up/screens/homeScreen.dart';

class ReceiptScreenQR extends StatefulWidget {
  final PassreceiptQR value;

  ReceiptScreenQR({Key key, this.value}) : super(key: key);

  @override
  _ReceiptScreenQRState createState() => _ReceiptScreenQRState();
}

class _ReceiptScreenQRState extends State<ReceiptScreenQR> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red[600],
        shadowColor: Colors.black,
        centerTitle: true,
        title: Text(
          'Transaction Receipt',
          style: TextStyle(
              fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        leading: new Container(),
      ),
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: 25),
                Text(
                  'Transaction ID;',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                Text(
                  '${widget.value.transactionid}',
                  style: TextStyle(
                    fontSize: 15,
                  ),
                  textAlign: TextAlign.center,
                ),
                _textDividerReceipt(),
                Text(
                  'Date and Time:',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                Text(
                  '${widget.value.timedate}',
                  style: TextStyle(
                    fontSize: 15,
                  ),
                  textAlign: TextAlign.center,
                ),
                _textDividerReceipt(),
                Text(
                  'Recipient Email:',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                Text(
                  '${widget.value.recipientemail}',
                  style: TextStyle(
                    fontSize: 15,
                  ),
                  textAlign: TextAlign.center,
                ),
                _textDividerReceipt(),
                Text(
                  'Recipient UID:',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                Text(
                  '${widget.value.recipientuid}',
                  style: TextStyle(
                    fontSize: 15,
                  ),
                  textAlign: TextAlign.center,
                ),
                _textDividerReceipt(),
                Text(
                  'Recipient Reference:',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                Text(
                  '${widget.value.recipientreference}',
                  style: TextStyle(
                    fontSize: 15,
                  ),
                  textAlign: TextAlign.center,
                ),
                _textDividerReceipt(),
                Text(
                  'Amount:',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                Text(
                  'MWK ${widget.value.amount}',
                  style: TextStyle(
                    fontSize: 15,
                  ),
                  textAlign: TextAlign.center,
                ),
                _textDividerReceipt(),
                SizedBox(height: 230),
                Align(
                  child: _finishButton(context),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _textDividerReceipt() {
    return Container(
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
    );
  }
}

Widget _finishButton(BuildContext context) {
  return Container(
    child: RaisedButton(
      splashColor: Colors.grey,
      color: Colors.white,
      shape: StadiumBorder(),
      child: Text(
        'Back to Homepage',
        style: TextStyle(color: Colors.black),
      ),
      onPressed: () => PushReplaceTo(context, HomeScreen()),
    ),
  );
}
