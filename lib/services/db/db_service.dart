import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_database/firebase_database.dart';
import 'package:geoflutterfire2/geoflutterfire2.dart';

final geo = GeoFlutterFire();

final GeoPoint currentLocation = GeoPoint(0, 0);

class UserInfo {
  final String firstName;
  final String lastName;
  final List<dynamic> activities;
  final GeoPoint location;
  final List<dynamic> friends;

  UserInfo({
    required this.firstName,
    required this.lastName,
    required this.activities,
    required this.location,
    required this.friends,
  });

  factory UserInfo.fromMap(Map<String, dynamic> data) {
    return UserInfo(
      firstName: data['firstName'],
      lastName: data['lastName'],
      activities: data['activities'],
      location: data['location'],
      friends: data['friends'],
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
  final String crowdlevel;

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
}

class DbService {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  // create data for new user
  Future<void> generateNewUser(
    String uid,
    String firstName,
    String lastName,
    List<int> activityIds,
  ) {
    final CollectionReference users = firestore.collection('users');

    return users.doc(uid).set({
      'firstName': firstName,
      'lastName': lastName,
      'activities': activityIds,
      'location': const GeoPoint(0, 0),
      'friends': [],
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
    });
  }

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
      return data['friends'];
    } else {
      return [];
    }
  }

  // Gyms

  // query firestore for gyms near user
  Future<List<GymInfo>> gymsNearYou(GeoPoint point) async {
    final CollectionReference gyms = firestore.collection('gyms');
    // 10km radius around point
    double radius = 10 / 111.12;

    // get gyms within radius
    final query = gyms
        .where('coordinates',
            isGreaterThanOrEqualTo: GeoPoint(
              point.latitude - radius,
              point.longitude - radius,
            ))
        .where('coordinates',
            isLessThanOrEqualTo: GeoPoint(
              point.latitude + radius,
              point.longitude + radius,
            ));
    var gymsSnapshot = await query.get();

    // convert to GymInfo
    List<GymInfo> gymsList = [];
    gymsSnapshot.docs.forEach((doc) {
      final data = doc.data() as Map<String, dynamic>;
      gymsList.add(
        GymInfo(
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
        ),
      );
    });
    return gymsList;
  }
}
