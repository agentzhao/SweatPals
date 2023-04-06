import 'package:cloud_firestore/cloud_firestore.dart';

/// Gym Info Class
class GymInfo {
  /// Text for address block House Number
  final String addressBlockHouseNumber;

  /// Text for address Building Name
  final String addressBuildingName;

  /// Text for address Floor Number
  final String addressFloorNumber;

  /// Text for address Postal Code
  final String addressPostalCode;

  /// Text for address Street Name
  final String addressStreetName;

  /// Text for address Unit Number
  final String addressUnitNumber;

  /// Text for Description
  final String description;

  /// Text for Weblink
  final String hyperlink;

  /// Text for Increment
  final String incCrc;

  /// Text for x Position
  final String landXAddressPoint;

  /// Text for Y Position
  final String landYAddressPoint;

  /// Text for Name
  final String name;

  /// Text for Photo URL
  final String photoURL;

  /// Gym Cordinates
  final GeoPoint coordinates;

  /// Gym Crowl Level Value
  final int crowdLevel;

  /// Contrustor
  GymInfo({
    required this.addressBlockHouseNumber,
    required this.addressBuildingName,
    required this.addressFloorNumber,
    required this.addressPostalCode,
    required this.addressStreetName,
    required this.addressUnitNumber,
    required this.description,
    required this.hyperlink,
    required this.incCrc,
    required this.landXAddressPoint,
    required this.landYAddressPoint,
    required this.name,
    required this.photoURL,
    required this.coordinates,
    required this.crowdLevel,
  });

  /// Create GymInfo Linked Hash Map
  factory GymInfo.fromMap(Map<String, dynamic> data) {
    return GymInfo(
      addressBlockHouseNumber: data['addressBlockHouseNumber'],
      addressBuildingName: data['addressBuildingName'],
      addressFloorNumber: data['addressFloorNumber'],
      addressPostalCode: data['addressPostalCode'],
      addressStreetName: data['addressStreetName'],
      addressUnitNumber: data['addressUnitNumber'],
      description: data['description'],
      hyperlink: data['hyperlink'],
      incCrc: data['incCrc'],
      landXAddressPoint: data['landXAddressPoint'],
      landYAddressPoint: data['landYAddressPoint'],
      name: data['name'],
      photoURL: data['photoURL'],
      coordinates: data['coordinates'],
      crowdLevel: data['crowdLevel'],
    );
  }
}
