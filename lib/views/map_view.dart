import 'package:flutter/material.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geoflutterfire2/geoflutterfire2.dart';
import 'package:sweatpals/services/auth/auth_service.dart';
import 'package:sweatpals/services/db/db_service.dart';
import 'package:geolocator/geolocator.dart';
import 'package:sweatpals/services/map/location.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class MapView extends StatefulWidget {
  const MapView({Key? key}) : super(key: key);

  @override
  _MapViewState createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  late GoogleMapController mapController;
  final geo = GeoFlutterFire();
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};

  String get uid => AuthService.firebase().currentUser!.uid;
  final DbService dbService = DbService();

  GeoPoint currentLocation = const GeoPoint(0, 0);
  UserInfo? currentUser;
  List<GymInfo> gymsList = [];
  List<UserInfo> usersList = [];

  // Singapore
  static const _initialCameraPosition = CameraPosition(
    target: LatLng(1.3521, 103.8198),
    zoom: 10,
  );

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    getCurrentLocation().then((value) {
      setState(() {
        currentLocation = value;
      });
    });
    await dbService.getUserInfo(uid).then((value) {
      setState(() {
        currentUser = value;
      });
    });
    await dbService.getAllGyms().then((value) {
      setState(() {
        gymsList = value;
        loadMarkers();
      });
    });
    await dbService.getAllUsers(uid).then((value) {
      setState(() {
        usersList = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: <Widget>[
      GoogleMap(
        // set initial camera state to current user location
        initialCameraPosition: _initialCameraPosition,
        // lifecycle hook
        onMapCreated: _onMapCreated,
        myLocationEnabled: true,
        myLocationButtonEnabled: false,
        zoomControlsEnabled: false,
        mapType: MapType.normal,
        markers: Set<Marker>.of(markers.values),
        compassEnabled: true,
        onCameraMove: (CameraPosition position) {
          _updateBasedOnPosition(position);
        },
      ),
      Positioned(
        bottom: 10,
        right: 10,
        child: FloatingActionButton(
          backgroundColor: Colors.green,
          onPressed: getUserLocation,
          child: const Icon(
            Icons.location_searching,
            color: Colors.white,
          ),
        ),
      )
    ]);
  }

  // Getting the current user location
  _onMapCreated(GoogleMapController controller) {
    setState(() {
      mapController = controller;
      // move map to current user location
      getUserLocation();
    });
  }

  // Getting user location using geolocator
  getUserLocation() {
    getLocationPermission();

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
      // update user location in database
      dbService.updateUserLocation(uid, position.latitude, position.longitude);
    }).catchError((e) {
      print(e);
    });
  }

  // void _updateMarkers(List<DocumentSnapshot> documentList) {
  //   // mapController.clearMarkers();
  //
  //   documentList.forEach((DocumentSnapshot document) {
  //     var markerIdVal = "100";
  //     final MarkerId markerId = MarkerId(markerIdVal);
  //
  //     // todo:
  //     GeoPoint pos = document.data['position']['geopoint'];
  //     double distance = document.data()!['distance'];
  //     String name = document.data()!['name'];
  //     // String address = document.data()!['address'];
  //
  //     final Marker marker = Marker(
  //       markerId: markerId,
  //       position: LatLng(pos.latitude, pos.longitude),
  //       icon: BitmapDescriptor.defaultMarker,
  //       infoWindow: InfoWindow(title: name, snippet: '$distance km'),
  //       onTap: () {
  //         // todo: open marker details in new page
  //         // _onMarkerTapped(markerId);
  //       },
  //     );
  //
  //     setState(() {
  //       // adding a new marker to map
  //       markers[markerId] = marker;
  //     });
  //   });
  // }

  void _updateBasedOnPosition(CameraPosition position) async {
    // get the new position
    double lat = position.target.latitude;
    double lng = position.target.longitude;

    // dbService.usersLocationStream(lat, lng).listen((List<DocumentSnapshot> documentList) {
    //   // _updateMarkers(documentList);
    // });
  }

  Future<GeoPoint> getCurrentLocation() async {
    await getLocationPermission();
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    return GeoPoint(position.latitude, position.longitude);
  }

// convert gymsList to markers
  void loadMarkers() {
    for (int i = 0; i < gymsList.length; i++) {
      var markerIdVal = i.toString();
      final MarkerId markerId = MarkerId(markerIdVal);

      GeoPoint pos = gymsList[i].coordinates;
      double distance = double.parse(dbService.distanceBetween(
        currentLocation,
        pos,
      ));
      String name = gymsList[i].NAME;
      String address = gymsList[i].ADDRESSSTREETNAME;

      final Marker marker = Marker(
        markerId: markerId,
        position: LatLng(pos.latitude, pos.longitude),
        icon: BitmapDescriptor.defaultMarker,
        infoWindow: InfoWindow(title: name, snippet: '$distance km'),
      );
      markers[markerId] = marker;
    }
  }

  void loadUsers() {
    for (int i = 0; i < gymsList.length; i++) {
      var markerIdVal = i.toString();
      final MarkerId markerId = MarkerId(markerIdVal);

      GeoPoint pos = gymsList[i].coordinates;
      double distance = double.parse(dbService.distanceBetween(
        currentLocation,
        pos,
      ));
      String name = gymsList[i].NAME;
      String address = gymsList[i].ADDRESSSTREETNAME;

      final Marker marker = Marker(
        markerId: markerId,
        position: LatLng(pos.latitude, pos.longitude),
        icon: BitmapDescriptor.defaultMarker,
        infoWindow: InfoWindow(title: name, snippet: '$distance km'),
      );
      markers[markerId] = marker;
    }
  }
}
