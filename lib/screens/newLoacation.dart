import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:async';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class NewLocation extends StatefulWidget {
  const NewLocation({Key key}) : super(key: key);

  @override
  _NewLocationState createState() => _NewLocationState();
}

class _NewLocationState extends State<NewLocation> {
  GoogleMapController googleMapController;
  final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
  Future<Position> _future;

  String addy;
  var textController = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _future = _getLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      child: FutureBuilder(
          future: _future,
          // ignore: missing_return
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (!snapshot.hasError) {
                print(snapshot.data.latitude);
                return Stack(children: <Widget>[
                  GoogleMap(
                    myLocationButtonEnabled: false,
                    myLocationEnabled: true,
                    mapType: MapType.normal,
                    initialCameraPosition: CameraPosition(
                        target: LatLng(
                            snapshot.data.latitude, snapshot.data.longitude),
                        zoom: 16.0),
                    onMapCreated: onMapCreated,
                  ),
                  Positioned(
                    top: 38.0,
                    left: 15.0,
                    right: 15.0,
                    child: Column(
                      children: <Widget>[
                        Container(
                          height: 50.0,
                          width: double.infinity,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              color: Colors.white),
                          child: TextField(
                            controller: textController,
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Enter Address',
                                contentPadding:
                                    EdgeInsets.only(top: 15.0, left: 15.0),
                                suffixIcon: IconButton(
                                  icon: Icon(Icons.search),
                                  iconSize: 30.0,
                                  onPressed: () {
                                    _searchandLocate();
                                  },
                                )),
                            onChanged: (value) => addy = value,
                            onSubmitted: (val) {
                              addy = val;
                              print(addy);
                              _searchandLocate();
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ]);
              }
            } else {
              return Center(child: CircularProgressIndicator());
            }
          }),
    ));
  }

  //Method to get latitude and longitude
  Future<Position> _getLocation() async {
    var per = await Geolocator().checkGeolocationPermissionStatus();
    if (per != null) {
      await Geolocator().checkGeolocationPermissionStatus();
    }
    var ans = await Geolocator().getCurrentPosition();
    return ans;
  }

  //Method to search locations
  _searchandLocate() {
    Geolocator().placemarkFromAddress(addy).then((result) {
      if (addy != null) {
        googleMapController.animateCamera(CameraUpdate.newCameraPosition(
            CameraPosition(
                target: LatLng(
                    result[0].position.latitude, result[0].position.longitude),
                zoom: 18.0)));
      } else if (result.isEmpty) {
        Scaffold.of(context).hideCurrentSnackBar();
        Scaffold.of(context).showSnackBar(SnackBar(
          content: Text('Location not found, Try again'),
          action: SnackBarAction(
            label: 'OK',
            onPressed: () {
              Scaffold.of(context).hideCurrentSnackBar();
            },
          ),
        ));
      }
    });
  }

  void onMapCreated(controller) {
    googleMapController = controller;
  }
}
