import 'package:flutter/material.dart';
import 'package:flutter_achitecture/Bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import 'detail_page.dart';

class MapView extends StatefulWidget {
  MapView({Key key}) : super(key: key);

  @override
  _MapViewState createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  bool searchTextIsEmpty = true;

  GoogleMapController mapController;
  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var bloc = Provider.of<BlocManager>(context);
    return bloc.mPosition!=null?Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            GoogleMap(
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(
                target: LatLng(bloc.mPosition.latitude, bloc.mPosition.longitude),//mPosition,
                zoom: 15.0,
              ),
              markers: bloc.mMarkers,
            ),
            Container(
              margin: EdgeInsets.only(right: 20, left: 20, top: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Container(
                    color: Colors.white,
                    child: TextField(
                      decoration: InputDecoration(
                        labelText: "Search for a restaurant",
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.blue,
                            width: 2.0,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.black54,
                            width: 2.0,
                          ),
                        ),
                      ),
                      onChanged: (value) {
                        if(value.trim()==""){
                          setState(() {
                            searchTextIsEmpty=true;
                          });
                        }else{
                          setState(() {
                            searchTextIsEmpty=false;
                            bloc.autoCompleteSearch(value);
                          });
                        }
                      },
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  !searchTextIsEmpty?Expanded(
                    child: ListView.builder(
                      itemCount: bloc.mPredictions.length,
                      itemBuilder: (context, index) {
                        return Container(
                          color: Colors.white,
                          child: ListTile(
                            leading: CircleAvatar(
                              child: Icon(
                                Icons.pin_drop,
                                color: Colors.white,
                              ),
                            ),
                            title: Text(bloc.mPredictions[index].description),
                            onTap: () {
                              debugPrint(bloc.mPredictions[index].placeId);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => DetailPage(
                                    placeId: bloc.mPredictions[index].placeId,
                                    googlePlace: bloc.googlePlace,
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ):Container(),
                ],
              ),
            )
          ],
        ),
      ),
    ):Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(Color.fromRGBO(128, 0, 128, 1)),),
            SizedBox(height: 20,),
            Text("Loading, Please wait", style: TextStyle(fontSize: 20,),),
          ],
        ),
      ),
    );
  }
}