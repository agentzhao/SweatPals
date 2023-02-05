import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geoflutterfire2/geoflutterfire2.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';

class MapView extends StatefulWidget {
  const MapView({Key? key}) : super(key: key);

  @override
  _MapViewState createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  late GoogleMapController mapController;

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  final geo = GeoFlutterFire();
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};

  static const _initialCameraPosition = CameraPosition(
    // singapore
    target: LatLng(1.3521, 103.8198),
    zoom: 10,
  );

  @override
  Widget build(BuildContext context) {
    return Stack(children: <Widget>[
      GoogleMap(
        // set initial camera state to current user location
        initialCameraPosition: _initialCameraPosition,
        onMapCreated: _onMapCreated,
        myLocationEnabled: true,
        myLocationButtonEnabled: false,
        zoomControlsEnabled: false,
        mapType: MapType.normal,
        compassEnabled: true,
        onCameraMove: (CameraPosition position) {
          _updateBasedOnPosition(position);
        },
      ),
      Positioned(
        bottom: 10,
        right: 10,
        child: FloatingActionButton(
          child: Icon(
            Icons.location_searching,
            color: Colors.white,
          ),
          backgroundColor: Colors.green,
          onPressed: _getUserLocation,
        ),
      )
    ]);
  }

  // Getting the current user location
  _onMapCreated(GoogleMapController controller) {
    setState(() {
      mapController = controller;
      // move map to current user location
      _getUserLocation();
    });
  }

  // Getting user location using geolocator
  _getUserLocation() {
    Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) {
      setState(() {
        // Updating the camera position to the user position
        mapController.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target: LatLng(position.latitude, position.longitude),
              zoom: 15,
            ),
          ),
        );
      });
    }).catchError((e) {
      print(e);
    });
  }

  void _updateMarkers(List<DocumentSnapshot> documentList) {
    // mapController.clearMarkers();

    documentList.forEach((DocumentSnapshot document) {
      var markerIdVal = "100";
      final MarkerId markerId = MarkerId(markerIdVal);

      // todo:
      GeoPoint pos = document.data['position']['geopoint'];
      double distance = document.data()!['distance'];
      String name = document.data()!['name'];
      // String address = document.data()!['address'];

      final Marker marker = Marker(
        markerId: markerId,
        position: LatLng(pos.latitude, pos.longitude),
        icon: BitmapDescriptor.defaultMarker,
        infoWindow: InfoWindow(title: name, snippet: '$distance km'),
        onTap: () {
          // todo: open marker details in new page
          // _onMarkerTapped(markerId);
        },
      );

      setState(() {
        // adding a new marker to map
        markers[markerId] = marker;
      });
    });
  }

  void _updateBasedOnPosition(CameraPosition position) async {
    // get the new position
    GeoFirePoint center = geo.point(
        latitude: position.target.latitude,
        longitude: position.target.longitude);

    // 10km radius
    double radius = 10;

    // get the new query
    Stream<List<DocumentSnapshot>> stream = geo
        .collection(collectionRef: firestore.collection('users'))
        .within(center: center, radius: radius, field: 'position');

    // update the markers
    stream.listen((List<DocumentSnapshot> documentList) {
      _updateMarkers(documentList);
    });
  }
}
