import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler_platform_interface/permission_handler_platform_interface.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:total_load_up/classes/ScanCapture.dart';

class QrScan extends StatefulWidget {
  final ScanResult value;
  const QrScan({Key key, this.value}) : super(key: key);

  @override
  _QrScanState createState() => _QrScanState();
}

class _QrScanState extends State<QrScan> {
  final qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController controller;
  Barcode barcode;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  // void reassemble() async{
  //   super.reassemble();
  //   if(Platform.isAndroid){
  //     await controller.pauseCamera();
  //   }
  //   controller.resumeCamera();
  // }
  @override
  Widget build(BuildContext context) => SafeArea(
        child: Scaffold(
            body: Stack(
          alignment: Alignment.center,
          children: [
            buildQrView(context),
            Positioned(
              child: buildResult(),
              bottom: 10,
            ),
            Positioned(
              child: buildControlButtons(),
              top: 10,
            ),
          ],
        )),
      );
  Widget buildControlButtons() => Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white24,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            IconButton(
              icon: Icon(Icons.flash_off),
              onPressed: () async {
                await controller.toggleFlash();
                setState(() {});
              },
            ),
            IconButton(
              icon: Icon(Icons.switch_camera),
              onPressed: () async {
                setState(() {
                  controller.flipCamera();
                });
              },
            )
          ],
        ),
      );
  Widget buildResult() => Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white24,
        ),
        child: Text(
          barcode != null
              ? 'Result : ${barcode.code}, ${widget.value.location} for ${widget.value.amount}'
              : 'Scan a code! found at ${widget.value.location} not ${widget.value.amount}',
          maxLines: 3,
        ),
      );
  Widget buildQrView(BuildContext context) => QRView(
        key: qrKey,
        onQRViewCreated: onQRViewCreated,
        overlay: QrScannerOverlayShape(
            borderColor: Theme.of(context).accentColor,
            borderRadius: 10,
            borderLength: 20,
            borderWidth: 10,
            cutOutSize: MediaQuery.of(context).size.width * 0.8),
      );
  void onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream
        .listen((barcode) => setState(() => this.barcode = barcode));
  }
}
