import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:total_load_up/CustomWidgets/CustomAppBar.dart';
import 'package:total_load_up/blocs/app_bloc.dart';
import 'package:total_load_up/classes/placeLocation.dart';
import 'package:total_load_up/global/loading.dart';
import 'package:total_load_up/screens/homeScreen.dart';

class Location extends StatefulWidget {
  const Location({Key key}) : super(key: key);

  @override
  _LocationState createState() => _LocationState();
}

class _LocationState extends State<Location> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  Completer<GoogleMapController> _mapController = Completer();
  final _locationController = TextEditingController();

  StreamSubscription locationSubscription;
  StreamSubscription boundsSubscription;

  void initState() {
    final applicationbloc =
        Provider.of<Applicationbloc>(context, listen: false);
    locationSubscription =
        applicationbloc.selectedLocation.stream.listen((place) {
      if (place != null) {
        _goToPlace(place);
      } else {
        _locationController.text = "";
      }
    });
    boundsSubscription = applicationbloc.bounds.stream.listen((bounds) async {
      final GoogleMapController controller = await _mapController.future;
      controller.animateCamera(CameraUpdate.newLatLngBounds(bounds, 50.0));
    });
    super.initState();
  }

  void dispose() {
    final applicationbloc =
        Provider.of<Applicationbloc>(context, listen: false);
    applicationbloc.dispose();
    boundsSubscription.cancel();
    locationSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final applicationbloc = Provider.of<Applicationbloc>(context);

    return Scaffold(
        key: _scaffoldKey,
        drawer: Drawer(
          child: ineyo(),
        ),
        appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.menu),
              iconSize: 28.0,
              onPressed: () => _scaffoldKey.currentState.openDrawer(),
            ),
            title: Text('Location'),
            centerTitle: true,
            actions: [
              IconButton(
                  icon: const Icon(Icons.attach_money),
                  iconSize: 28.0,
                  onPressed: () {
                    // _showLockScreen(context, opaque: false);
                  }),
            ]),
        // body: (applicationbloc.currentLocation == null)
        body: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _locationController,
                textCapitalization: TextCapitalization.words,
                decoration: InputDecoration(
                    hintText: "Search location",
                    suffixIcon: Icon(Icons.search)),
                onChanged: (value) => applicationbloc.searchPlaces(value),
                onTap: () => applicationbloc.clearSelectedLocation(),
              ),
            ),
            Stack(
              children: [
                Container(
                  height: 400,
                  child: GoogleMap(
                    mapType: MapType.normal,
                    markers: Set<Marker>.of(applicationbloc.markers),
                    myLocationEnabled: true,
                    onMapCreated: (GoogleMapController controller) {
                      _mapController.complete(controller);
                    },
                    initialCameraPosition: CameraPosition(
                      target: LatLng(41.8781, -87.6298),
                      zoom: 12,
                    ),
                  ),
                ),
                if (applicationbloc.searchResults != null &&
                    applicationbloc.searchResults.length != 0)
                  Container(
                    height: 300,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: Colors.black.withOpacity(.6),
                        backgroundBlendMode: BlendMode.darken),
                  ),
                if (applicationbloc.searchResults != null)
                  Container(
                    height: 300,
                    child: ListView.builder(
                        itemCount: applicationbloc.searchResults.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Text(
                              applicationbloc.searchResults[index].description,
                              style: TextStyle(color: Colors.white),
                            ),
                            onTap: () {
                              applicationbloc.setSelectedLocation(
                                  applicationbloc.searchResults[index].placeId);
                            },
                          );
                        }),
                  )
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Filter Results'),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Wrap(
                spacing: 8.0,
                children: [
                  FilterChip(
                    label: Text('Campground'),
                    onSelected: (val) =>
                        applicationbloc.togglePlaceType('campground', val),
                    selected: applicationbloc.placeType == 'campground',
                    selectedColor: Colors.blue,
                  ),
                  FilterChip(
                      label: Text('Locksmith'),
                      onSelected: (val) =>
                          applicationbloc.togglePlaceType('locksmith', val),
                      selected: applicationbloc.placeType == 'locksmith',
                      selectedColor: Colors.blue),
                  FilterChip(
                      label: Text('Pharmacy'),
                      onSelected: (val) =>
                          applicationbloc.togglePlaceType('pharmacy', val),
                      selected: applicationbloc.placeType == 'pharmacy',
                      selectedColor: Colors.blue),
                  FilterChip(
                      label: Text('Pet Store'),
                      onSelected: (val) =>
                          applicationbloc.togglePlaceType('pet_store', val),
                      selected: applicationbloc.placeType == 'pet_store',
                      selectedColor: Colors.blue),
                  FilterChip(
                      label: Text('Lawyer'),
                      onSelected: (val) =>
                          applicationbloc.togglePlaceType('lawyer', val),
                      selected: applicationbloc.placeType == 'lawyer',
                      selectedColor: Colors.blue),
                  FilterChip(
                      label: Text('Bank'),
                      onSelected: (val) =>
                          applicationbloc.togglePlaceType('bank', val),
                      selected: applicationbloc.placeType == 'bank',
                      selectedColor: Colors.blue),
                ],
              ),
            )
          ],
        )
        //  Center(
        //     child: Loading(),
        //   )
        );
  }

  Future<void> _goToPlace(Place place) async {
    final GoogleMapController controller = await _mapController.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target:
            LatLng(place.geometry.location.lat, place.geometry.location.lng),
        zoom: 14.1)));
  }
}
