import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class Generateqr extends StatefulWidget {
  Generateqr({Key key}) : super(key: key);

  @override
  _GenerateqrState createState() => _GenerateqrState();
}

class _GenerateqrState extends State<Generateqr> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  final _key = GlobalKey<FormState>();

// the text controller
  final controller = TextEditingController();
  // getting current location
  var locationMessage = "";
  void getCurrentLocation() async {
    var position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    var lastPosition = await Geolocator().getLastKnownPosition();
    print(lastPosition);
    var lat = position.latitude;
    var long = position.longitude;
    print("$lat, $long");
    setState(() {
      locationMessage = "Longitude: $long, Latitude: $lat";
    });
  }

  double petrol = 890.20;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: Drawer(),
      appBar: AppBar(
        backgroundColor: Colors.blue[600],
        elevation: 0.0,
        leading: IconButton(
          icon: const Icon(Icons.menu),
          iconSize: 28.0,
          onPressed: () => _scaffoldKey.currentState.openDrawer(),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Form(
            key: _key,
            child: Container(
              margin: EdgeInsets.only(left: 20, right: 10, top: 20),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 25, vertical: 15),
                    child: TextFormField(
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        prefixText: 'MWK ',
                        prefixIcon: Icon(
                          Icons.money,
                          color: Colors.black,
                          size: 20,
                        ),
                        labelText: 'Amount',
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                          color: Colors.black,
                        )),
                        border: OutlineInputBorder(),
                      ),
                      controller: controller,
                      // onChanged: (),
                      // onSaved: (value) => _amount = value,
                    ),
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  Container(
                    height: 60,
                    width: MediaQuery.of(context).size.width / 1.2,
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 205, 53, 44),
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 0, horizontal: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          TextButton(
                            child: Text(
                              'Generate QRcode',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            onPressed: () => setState(() {
                              getCurrentLocation();
                            })
                            //loginUser (){
/*
                                      Navigator.push(context, MaterialPageRoute(
                                        builder: (context) => AttendantDash()));*/
                            ,
                          ),
                          //Icon
                          Icon(Icons.qr_code)
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 60.0),
                  BarcodeWidget(
                    barcode: Barcode.qrCode(),
                    data: controller.text + locationMessage ?? '0',
                    width: 300,
                    height: 300,
                    color: Colors.black,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
