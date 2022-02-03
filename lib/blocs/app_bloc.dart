import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:total_load_up/classes/geolocator_service.dart';
import 'package:total_load_up/classes/markerService.dart';
import 'package:total_load_up/classes/placeLocation.dart';
import 'package:total_load_up/classes/placeSearch.dart';
import 'package:total_load_up/classes/placesService.dart';

class Applicationbloc with ChangeNotifier {
  final geolocatorService = GeolocatorService();
  final placesService = PlacesService();
  final markerService = MarkerService();

  Position currentLocation;
  StreamController<Place> selectedLocation =
      StreamController<Place>.broadcast();
  StreamController<LatLngBounds> bounds =
      StreamController<LatLngBounds>.broadcast();
  String placeType;
  Place selecetedLocationStatic;
  // ignore: deprecated_member_use
  List<Marker> markers = List<Marker>();
  List<PlaceSearch> searchResults;

  Applicationbloc() {
    setCurrentLocation();
  }

  setCurrentLocation() async {
    currentLocation = await geolocatorService.getCurrentLocation();
    selecetedLocationStatic = Place(
      name: null,
      geometry: Geometry(
        location: Location(
            lat: currentLocation.latitude, lng: currentLocation.longitude),
      ),
    );
    notifyListeners();
  }

  searchPlaces(String searchTerm) async {
    searchResults = await placesService.getAutocomplete(searchTerm);
    notifyListeners();
  }

  setSelectedLocation(String placeId) async {
    var sLocation = await placesService.getPlace(placeId);
    selectedLocation.add(sLocation);
    selecetedLocationStatic = sLocation;
    searchResults = null;
    notifyListeners();
  }

  clearSelectedLocation() {
    selectedLocation.add(null);
    selecetedLocationStatic = null;
    searchResults = null;
    placeType = null;
    notifyListeners();
  }

  togglePlaceType(String value, bool selected) async {
    if (selected) {
      placeType = value;
    } else {
      placeType = null;
    }
    if (placeType != null) {
      var places = await placesService.getPlaces(
          selecetedLocationStatic.geometry.location.lat,
          selecetedLocationStatic.geometry.location.lng,
          placeType);
      markers = [];

      if (places.length > 0) {
        var newMarker = markerService.createMarkerFromPlace(places[0]);
        markers.add(newMarker);
      }
      var locationMarker =
          markerService.createMarkerFromPlace(selecetedLocationStatic);
      markers.add(locationMarker);
      var _bounds = markerService.bounds(Set<Marker>.of(markers));
      bounds.add(_bounds);

      notifyListeners();
    }
  }

  @override
  void dispose() {
    selectedLocation.close();
    bounds.close();
    super.dispose();
  }
}
