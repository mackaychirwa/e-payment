import 'package:http/http.dart' as http;
import 'package:total_load_up/classes/placeLocation.dart';
import 'dart:convert' as convert;

import 'package:total_load_up/classes/placeSearch.dart';

class PlacesService {
  // final apikey = 'AIzaSyCo_mwB62_uTYBvyjVGuhYcMkgHIAurZmc';
  final apikey = 'AIzaSyD6gJtDeZ7cmZijojrWCxSa_jbxZsnfafw';
  Future<List<PlaceSearch>> getAutocomplete(String search) async {
    var url =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$search&types=(cities)&key=$apikey';
    var response = await http.get(Uri.parse(url));
    var json = convert.jsonDecode(response.body);
    var jsonResults = json['predictions'] as List;
    return jsonResults.map((place) => PlaceSearch.fromJson(place)).toList();
  }

  Future<Place> getPlace(String placeId) async {
    var url =
        'https://maps.googleapis.com/maps/api/place/details/json?key=$apikey&place_id=$placeId';
    var response = await http.get(Uri.parse(url));
    var json = convert.jsonDecode(response.body);
    var jsonResult = json['result'] as Map<String, dynamic>;
    return Place.fromJson(jsonResult);
  }

  Future<List<Place>> getPlaces(
      double lat, double lng, String placeType) async {
    var url =
        'https://maps.googleapis.com/maps/api/place/textsearch/json?type=$placeType&location=$lat,$lng&rankby=distance&key=$apikey';
    var response = await http.get(Uri.parse(url));
    var json = convert.jsonDecode(response.body);
    var jsonResults = json['results'] as List;
    return jsonResults.map((place) => Place.fromJson(place)).toList();
  }
}
