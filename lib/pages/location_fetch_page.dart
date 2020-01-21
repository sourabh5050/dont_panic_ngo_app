import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


//void main() => runApp(MyApp1());

//class MyApp1 extends StatelessWidget {
//  @override
//  Widget build(BuildContext context) {
//    return MaterialApp(
//      debugShowCheckedModeBanner: false,
//      home: mapss(),
//    );
//  }
//}

class mapss extends StatefulWidget {
  @override
  _mapssState createState() => _mapssState();
}

class _mapssState extends State<mapss> {
  Firestore firestore = Firestore.instance;
  List<Marker> allMarkers = [];
  double lat1 = 12.8248455, lon1 = 80.0468772;

  GoogleMapController _controller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    allMarkers.add(Marker(
        markerId: MarkerId('myMarker'),
        draggable: true,
        onTap: () {
          print('Marker Tapped');
        },
        position: LatLng(lat1, lon1)));
   // mark();
  }

  void mark() {
    allMarkers.add(Marker(
        markerId: MarkerId('myMarker'),
        draggable: true,
        onTap: () {
          print('Marker Tapped');
        },
        position: LatLng(lat1, lon1)));
    setState(() {
      lat1 = lat1 + 0.0001;
      //lon1 = lon1 + 0.0001;
    });
    movtoNew();
  }

  void recur() {
    Timer.periodic(new Duration(seconds: 5), (timer) {
      mark();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Maps'),
        ),
        body: Stack(children: [
          Container(
            height: double.infinity,
            width: double.infinity,
            child: GoogleMap(
              initialCameraPosition:
                  CameraPosition(target: LatLng(lat1, lon1), zoom: 12.0),
              markers: Set.from(allMarkers),
              onMapCreated: mapCreated,
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: InkWell(
              onTap: () {
                mark();
              },
              child: Container(
                height: 40.0,
                width: 40.0,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0),
                    color: Colors.green),
                child: Icon(Icons.forward, color: Colors.white),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: InkWell(
              onTap: () {},
              child: Container(
                height: 40.0,
                width: 40.0,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0),
                    color: Colors.red),
                child: Icon(Icons.backspace, color: Colors.white),
              ),
            ),
          )
        ]),
      ),
    );
  }

  void mapCreated(controller) {
    setState(() {
      _controller = controller;
    });
  }

  void movtoNew() {
    _controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
            target: LatLng(lat1, lon1),
            zoom: 19.0,
            bearing: 55.0,
            tilt: 45.0,
        ),
      ),
    );
    recur();
  }
}