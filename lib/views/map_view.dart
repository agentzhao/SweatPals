import 'package:flutter/material.dart';

import 'package:sweatpals/constants/routes.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geoflutterfire2/geoflutterfire2.dart';
import 'package:sweatpals/services/auth/auth_service.dart';
import 'package:sweatpals/services/db/db_service.dart';
import 'package:geolocator/geolocator.dart';
import 'package:sweatpals/services/map/location.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// import 'package:sweatpals/views/user_view.dart';
// import 'package:sweatpals/views/gym_view.dart';

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

  final List<bool> _selected = <bool>[true, false];
  List<GymInfo> gymsList = [];
  Map<MarkerId, Marker> gymMarkers = <MarkerId, Marker>{};
  List<UserInfo> usersList = [];
  Map<MarkerId, Marker> userMarkers = <MarkerId, Marker>{};

  Stream<List<UserInfo>> usersStream = const Stream.empty();

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
        loadGyms();
      });
    });
    await dbService.getAllUsers(uid).then((value) {
      setState(() {
        usersList = value;
        loadUsers();
      });
    });
    markers.addAll(gymMarkers);
    // todo: userstream
    // usersStream = dbService.usersStream();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(children: <Widget>[
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
        ),
        Positioned(
          top: 10,
          right: 10,
          child: ToggleButtons(
            onPressed: (int index) {
              setState(() {
                // _selected[index] = !_selected[index];
                // The button that is tapped is set to true, and the others to false.
                for (int i = 0; i < _selected.length; i++) {
                  _selected[i] = i == index;
                }
                if (_selected[0]) {
                  markers = gymMarkers;
                } else if (_selected[1]) {
                  markers = userMarkers;
                } else if (_selected[0] && _selected[1]) {
                  // both user and gym
                  markers = {};
                  markers.addAll(gymMarkers);
                  markers.addAll(userMarkers);
                } else {
                  markers = {};
                }
              });
            },
            borderRadius: const BorderRadius.all(
              Radius.circular(8),
            ),
            selectedBorderColor: Colors.green[700],
            selectedColor: Colors.white,
            fillColor: Colors.green[400],
            borderColor: Colors.green[700],
            color: Colors.green[700],
            isSelected: _selected,
            children: const <Widget>[
              Icon(Icons.fitness_center),
              Icon(Icons.person),
            ],
          ),
        ),
      ]),
    );
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
  getUserLocation() async {
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

    // refresh markers
    await dbService.getAllGyms().then((value) {
      setState(() {
        gymsList = value;
        loadGyms();
      });
    });
    await dbService.getAllUsers(uid).then((value) {
      setState(() {
        usersList = value;
        loadUsers();
      });
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
  void loadGyms() {
    for (int i = 0; i < gymsList.length; i++) {
      var markerIdVal = i.toString();
      final MarkerId markerId = MarkerId(markerIdVal);

      GeoPoint pos = gymsList[i].coordinates;
      // double distance = double.parse(dbService.distanceBetween(
      //   currentLocation,
      //   pos,
      // ));
      String name = gymsList[i].NAME;
      int crowdlevel = gymsList[i].crowdlevel;

      final Marker marker = Marker(
        markerId: markerId,
        position: LatLng(pos.latitude, pos.longitude),
        icon: BitmapDescriptor.defaultMarkerWithHue(
          BitmapDescriptor.hueGreen,
        ),
        infoWindow: InfoWindow(
          title: name,
          snippet: 'Crowd Level: $crowdlevel',
          onTap: () {
            Navigator.of(context).pushNamed(
              Routes.gymRoute,
              arguments: gymsList[i],
            );
          },
        ),
      );
      gymMarkers[markerId] = marker;
    }
  }

  void loadUsers() async {
    for (int i = 0; i < usersList.length; i++) {
      var markerIdVal = usersList[i].uid;
      final MarkerId markerId = MarkerId(markerIdVal);

      GeoPoint pos = usersList[i].location;
      double distance = double.parse(dbService.distanceBetween(
        currentLocation,
        pos,
      ));
      String name = '${usersList[i].firstName} ${usersList[i].lastName}';
      bool isFriend = currentUser!.friends.contains(usersList[i].uid);

      // users are azure, friends are yellow
      final Marker marker = Marker(
        markerId: markerId,
        position: LatLng(pos.latitude, pos.longitude),
        icon: BitmapDescriptor.defaultMarkerWithHue(
          isFriend ? BitmapDescriptor.hueYellow : BitmapDescriptor.hueAzure,
        ),
        infoWindow: InfoWindow(
          title: name,
          snippet: '$distance km',
          onTap: () {
            Navigator.of(context).pushNamed(
              Routes.userRoute,
              arguments: usersList[i],
            );
          },
        ),
      );
      userMarkers[markerId] = marker;
    }
  }
}
