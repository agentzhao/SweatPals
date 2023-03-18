import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_database/firebase_database.dart';
import 'package:geoflutterfire2/geoflutterfire2.dart';

final geo = GeoFlutterFire();

class UserInfo {
  final String uid;
  final String username;
  final String firstName;
  final String lastName;
  final String photoURL;
  final List<dynamic> activities;
  final GeoPoint location;
  final Timestamp lastUpdated;
  final List<dynamic> friends;
  final List<dynamic> favourites;

  UserInfo({
    required this.uid,
    required this.username,
    required this.firstName,
    required this.lastName,
    required this.photoURL,
    required this.activities,
    required this.location,
    required this.lastUpdated,
    required this.friends,
    required this.favourites,
  });

  factory UserInfo.fromMap(Map<String, dynamic> data) {
    return UserInfo(
      uid: data['uid'],
      username: data['username'],
      firstName: data['firstName'],
      lastName: data['lastName'],
      photoURL: data['photoURL'],
      activities: data['activities'],
      location: data['location'],
      lastUpdated: data['lastUpdated'],
      friends: data['friends'],
      favourites: data['favourites'],
    );
  }
}

class GymInfo {
  final String ADDRESSBLOCKHOUSENUMBER;
  final String ADDRESSBUILDINGNAME;
  final String ADDRESSFLOORNUMBER;
  final String ADDRESSPOSTALCODE;
  final String ADDRESSSTREETNAME;
  final String ADDRESSUNITNUMBER;
  final String DESCRIPTION;
  final String HYPERLINK;
  final String INC_CRC;
  final String LANDXADDRESSPOINT;
  final String LANDYADDRESSPOINT;
  final String NAME;
  final String PHOTOURL;
  final GeoPoint coordinates;
  final int crowdlevel;

  GymInfo({
    required this.ADDRESSBLOCKHOUSENUMBER,
    required this.ADDRESSBUILDINGNAME,
    required this.ADDRESSFLOORNUMBER,
    required this.ADDRESSPOSTALCODE,
    required this.ADDRESSSTREETNAME,
    required this.ADDRESSUNITNUMBER,
    required this.DESCRIPTION,
    required this.HYPERLINK,
    required this.INC_CRC,
    required this.LANDXADDRESSPOINT,
    required this.LANDYADDRESSPOINT,
    required this.NAME,
    required this.PHOTOURL,
    required this.coordinates,
    required this.crowdlevel,
  });

  factory GymInfo.fromMap(Map<String, dynamic> data) {
    return GymInfo(
      ADDRESSBLOCKHOUSENUMBER: data['ADDRESSBLOCKHOUSENUMBER'],
      ADDRESSBUILDINGNAME: data['ADDRESSBUILDINGNAME'],
      ADDRESSFLOORNUMBER: data['ADDRESSFLOORNUMBER'],
      ADDRESSPOSTALCODE: data['ADDRESSPOSTALCODE'],
      ADDRESSSTREETNAME: data['ADDRESSSTREETNAME'],
      ADDRESSUNITNUMBER: data['ADDRESSUNITNUMBER'],
      DESCRIPTION: data['DESCRIPTION'],
      HYPERLINK: data['HYPERLINK'],
      INC_CRC: data['INC_CRC'],
      LANDXADDRESSPOINT: data['LANDXADDRESSPOINT'],
      LANDYADDRESSPOINT: data['LANDYADDRESSPOINT'],
      NAME: data['NAME'],
      PHOTOURL: data['PHOTOURL'],
      coordinates: data['coordinates'],
      crowdlevel: data['crowdlevel'],
    );
  }
}

class DbService {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  // create data for new user
  Future<void> generateNewUser(
    String uid,
    String username,
    String firstName,
    String lastName,
    List<int> activityIds,
  ) {
    final CollectionReference users = firestore.collection('users');

    return users.doc(uid).set({
      'uid': uid,
      'username': username,
      'firstName': firstName,
      'lastName': lastName,
      'photoURL': "https://pngimg.com/uploads/github/github_PNG80.png",
      'activities': activityIds,
      'location': const GeoPoint(0, 0),
      'lastUpdated': DateTime.now(),
      'friends': [],
      'favourites': [],
    });
  }

  Future<UserInfo?> getUserInfo(String uid) async {
    // List name = [];
    final docRef = firestore.collection("users").doc(uid);
    final snapshot = await docRef.get();

    if (snapshot.exists) {
      return UserInfo.fromMap(snapshot.data()!);
    } else {
      return null;
    }
  }

  Future<void> updateName(String uid, String firstName, String lastName) {
    final CollectionReference users = firestore.collection('users');

    return users.doc(uid).update({
      'firstName': firstName,
      'lastName': lastName,
    });
  }

  Future<void> updateActivities(
    String uid,
    List<int> favouriteActivities,
  ) {
    final CollectionReference users = firestore.collection('users');

    return users.doc(uid).update({
      'activities': favouriteActivities,
    });
  }

  List<int> getActivities(String uid) {
    final docRef = firestore.collection("users").doc(uid);
    docRef.get().then(
      (DocumentSnapshot doc) {
        final data = doc.data() as Map<String, dynamic>;
        return data['activities'];
      },
    );
    return [];
  }

  Future<void> updateUserLocation(
    String uid,
    double lat,
    double lng,
  ) {
    final CollectionReference users = firestore.collection('users');
    return users.doc(uid).update({
      'location': GeoPoint(lat, lng),
      'lastUpdated': DateTime.now(),
    });
  }

  // Users
  Stream<QuerySnapshot> usersLocationStream(double lat, double lng) {
    final Stream<QuerySnapshot> users =
        firestore.collection('users').snapshots();

    // todo: update only users in radius
    // double radius = 10;
    // GeoPoint center = GeoPoint(latitude, longitude);
    // Stream<List<DocumentSnapshot>> stream = geo
    //     .collection(collectionRef: firestore.collection('users'))
    //     .within(center: center, radius: radius, field: 'position');
    // stream.listen((List<DocumentSnapshot> documentList) {
    //   // _updateMarkers(documentList);
    // });

    return users;
  }

  Future<void> addFriend(String uid, String friendUid) {
    final CollectionReference users = firestore.collection('users');

    return users.doc(uid).update({
      'friends': FieldValue.arrayUnion([friendUid]),
    });
  }

  Future<void> removeFriend(String uid, String friendUid) {
    final CollectionReference users = firestore.collection('users');

    return users.doc(uid).update({
      'friends': FieldValue.arrayRemove([friendUid]),
    });
  }

  Future<List<String>> getFriends(String uid) async {
    final docRef = firestore.collection("users").doc(uid);
    final snapshot = await docRef.get();
    if (snapshot.exists) {
      final data = snapshot.data() as Map<String, dynamic>;
      return List<String>.from(data['friends']);
    } else {
      return [];
    }
  }

  Future<void> addFavourite(String uid, String favouriteUid) {
    final CollectionReference users = firestore.collection('users');

    return users.doc(uid).update({
      'favourites': FieldValue.arrayUnion([favouriteUid]),
    });
  }

  Future<void> removeFavourite(String uid, String favouriteUid) {
    final CollectionReference users = firestore.collection('users');

    return users.doc(uid).update({
      'favourites': FieldValue.arrayRemove([favouriteUid]),
    });
  }

  // get stream of users in List<UserInfo> except current user
  Stream<List<UserInfo>> usersStream() {
    final Stream<QuerySnapshot> users =
        firestore.collection('users').snapshots();

    return users.map((QuerySnapshot querySnapshot) {
      List<UserInfo> usersList = [];
      querySnapshot.docs.forEach((doc) {
        final data = doc.data() as Map<String, dynamic>;
        usersList.add(UserInfo.fromMap(data));
      });

      // remove current user
      // usersList.removeWhere((element) => element.uid == uid);
      return usersList;
    });
  }

  Future<List<UserInfo>> getAllUsers(uid) async {
    final CollectionReference users = firestore.collection('users');
    return users.get().then((QuerySnapshot querySnapshot) {
      List<UserInfo> usersList = [];
      for (var doc in querySnapshot.docs) {
        if (doc.id == uid) continue;
        final data = doc.data() as Map<String, dynamic>;
        usersList.add(UserInfo.fromMap(data));
      }

      // remove current user
      usersList.removeWhere((element) => element.uid == uid);
      return usersList;
    });
  }

  // Gyms
  Future<List<GymInfo>> getAllGyms() async {
    final CollectionReference gyms = firestore.collection('gyms');
    return gyms.get().then((QuerySnapshot querySnapshot) {
      List<GymInfo> gymsList = [];
      for (var doc in querySnapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;
        gymsList.add(GymInfo.fromMap(data));
      }
      return gymsList;
    });
  }

  Future<List<GymInfo>> nearestGyms(GeoPoint point) async {
    List<GymInfo> gymsList = await getAllGyms();

    gymsList.sort((a, b) {
      double distanceToA = double.parse(
        distanceBetween(point, a.coordinates),
      );
      double distanceToB = double.parse(
        distanceBetween(point, b.coordinates),
      );
      return distanceToA.compareTo(distanceToB);
    });

    return gymsList.take(6).toList();
  }

  String distanceBetween(GeoPoint point1, GeoPoint point2) {
    int decimalPlaces = 2;
    double lat1 = point1.latitude;
    double lon1 = point1.longitude;
    double lat2 = point2.latitude;
    double lon2 = point2.longitude;

    double p = 0.017453292519943295; // Math.PI / 180
    double a = 0.5 -
        cos((lat2 - lat1) * p) / 2 +
        cos(lat1 * p) * cos(lat2 * p) * (1 - cos((lon2 - lon1) * p)) / 2;
    double result = 12742 * asin(sqrt(a)); // 2 * R; R = 6371 km
    return result.toStringAsFixed(decimalPlaces);
  }
}
