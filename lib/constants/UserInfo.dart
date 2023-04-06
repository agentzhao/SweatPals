import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geoflutterfire2/geoflutterfire2.dart';

/// UserInfo Class
class UserInfo {
  /// Text for UID
  final String uid;

  /// Text for Username
  final String username;

  /// Text for Firstname
  final String firstName;

  /// Text for Lastname
  final String lastName;

  /// Text for PhotoURL
  final String photoURL;

  /// List of Activities
  final List<dynamic> activities;

  /// User Cordinates
  final GeoPoint location;

  /// Time Update
  final Timestamp lastUpdated;

  /// List of Firends
  final List<dynamic> friends;

  /// List of Favourites
  final List<dynamic> favourites;

  /// Contrustor
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

  /// Create Userinfo Linked Hash Map
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
