import 'package:cloud_firestore/cloud_firestore.dart';

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
