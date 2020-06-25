import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_place/google_place.dart';

import 'api_keys.dart';

class BlocManager with ChangeNotifier {
  BlocManager(){
    get_current_location();
  }

  Position _position;
  final Set<Marker> _markers = {};

  Position get mPosition => _position;
  Set<Marker> get mMarkers => _markers;

  List<AutocompletePrediction> mPredictions = [];


  GooglePlace googlePlace = GooglePlace(apiKey);

  void get_current_location()async{
    var geolocator = Geolocator();
    var locationOptions = LocationOptions(accuracy: LocationAccuracy.high, distanceFilter: 10);
    geolocator.getPositionStream(locationOptions).listen(
        (Position position)async{
          //mLatLng = LatLng(position.latitude, position.longitude);
          _position = position;
          await searchByRadius();
          notifyListeners();
        });
  }

  void autoCompleteSearch(String value) async {

    var result = await googlePlace.autocomplete.get(
        value,
        location: LatLon(mPosition.longitude, mPosition.latitude)
    );
    var result3 = await googlePlace.search.getNearBySearch(
      Location(lat: mPosition.latitude, lng: mPosition.longitude), 15000,
      type: "restaurant", keyword: value,
    );
    //result.results result.predictions
    if (result != null && result.predictions != null) {
      if(value.trim()!=""){
        mPredictions = result.predictions;
      }else{
        mPredictions = [];
      }
      //searchResults = result.results;
      print(result.status);
      print(mPredictions);
      notifyListeners();
    }

  }

  void searchByRadius()async{
    if(mPosition!=null){
      final location =  Location(lat: mPosition.latitude, lng: mPosition.longitude);
      final result2 = await googlePlace.search.getNearBySearch(location, 5500, type: "restaurant");
      print("000000000000000000000");
      print(result2.status);
      print(result2.results.length);
      for (var i = 0; i < result2.results.length; i++) {
        print(result2.results[i].name);
        mMarkers.add(Marker(
          // This marker id can be anything that uniquely identifies each marker.
          markerId: MarkerId(result2.results[i].geometry.location.toString()),
          position: LatLng(result2.results[i].geometry.location.lat, result2.results[i].geometry.location.lng),
          infoWindow: InfoWindow(
            title: result2.results[i].name,
            snippet: '${result2.results[i].rating!=null?result2.results[i].rating:'No'} Star Rating',
          ),
          icon: BitmapDescriptor.defaultMarker,
        ));
      }
    }
  }

}