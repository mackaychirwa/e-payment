import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
class CurrentLocation extends StatefulWidget {
  const CurrentLocation({ Key key }) : super(key: key);

  @override
  _CurrentLocationState createState() => _CurrentLocationState();
}

class _CurrentLocationState extends State<CurrentLocation> {
  var locationMessage = "";
  void getCurrentLocation() async {
    var position = await Geolocator()
    .getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high
    );
    var lastPosition = await Geolocator()
    .getLastKnownPosition();
    print(lastPosition);
    var lat = position.latitude;
    var long = position.longitude;
    print("$lat, $long");
    setState(() {
          locationMessage ="Longitude: $long, Latitude: $lat";
        });
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      child: TextButton(
          onPressed: () {
            getCurrentLocation();
          }, 
          child: Text("$locationMessage"),)
    
      
      
    );
  }
}