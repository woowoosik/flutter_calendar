import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:schedule_calendar/google_map/google_map_model.dart';

class GoogleMapPage extends StatefulWidget{

  var lat;
  var lng;

  GoogleMapPage({ required this.lat, required this.lng, super.key});

  @override
  State<StatefulWidget> createState() {

    return _GoogleMapPage();
  }
}

class _GoogleMapPage extends State<GoogleMapPage>{


  GoogleMapController? _googleMapController;

  @override
  Widget build(BuildContext context) {

    Marker marker = Marker(
      markerId: MarkerId('위치'),
      position: LatLng(widget.lat, widget.lng),
    );

    CameraPosition cameraPosition = CameraPosition(
        target: LatLng(widget.lat, widget.lng),
        zoom: 16,

    );
    if(_googleMapController != null){
      _googleMapController!.moveCamera(CameraUpdate.newCameraPosition(cameraPosition));
    }

    return Scaffold(

     body: GoogleMap(
       onMapCreated: (controller) {
         setState(() {
           _googleMapController = controller;
         });
       },
       initialCameraPosition: CameraPosition(
       target: LatLng(widget.lat, widget.lng),
       zoom: 16.0,
      ),
       markers: Set.from([marker]),
     ),
    );
  }



}
