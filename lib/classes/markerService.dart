import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:total_load_up/classes/placeLocation.dart';

class MarkerService{
  LatLngBounds bounds(Set<Marker> markers){
    if(markers == null || markers.isEmpty)
    return null;
    return createBounds(markers.map((m) => m.position).toList());
  }

  LatLngBounds createBounds(List<LatLng> positions){
    final southwestLat = positions.map((p) => p.latitude).reduce((value, element) => value < element ? value : element);
    final southwestLon = positions.map((p) => p.longitude).reduce((value, element) => value < element ? value : element);
    final nouthwestLat = positions.map((p) => p.latitude).reduce((value, element) => value < element ? value : element);
    final nouthwestLon = positions.map((p) => p.longitude).reduce((value, element) => value < element ? value : element);
  return LatLngBounds(
    southwest: LatLng(southwestLat, southwestLon),
    northeast: LatLng(nouthwestLat, nouthwestLon)
    );
  }

  
  Marker createMarkerFromPlace(Place place){
    var markerId = place.name;

    return Marker(
      markerId: MarkerId(markerId),
      draggable: false,
      infoWindow: InfoWindow(
        title: place.name, snippet: place.vicinity
      ),position: LatLng(place.geometry.location.lat, place.geometry.location.lng));
  }
}