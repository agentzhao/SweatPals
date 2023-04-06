import 'package:cloud_firestore/cloud_firestore.dart';

class GymInfo {
  final String addressBlockHouseNumber;
  final String addressBuildingName;
  final String addressFloorNumber;
  final String addressPostalCode;
  final String addressStreetName;
  final String addressUnitNumber;
  final String description;
  final String hyperlink;
  final String incCrc;
  final String landXAddressPoint;
  final String landYAddressPoint;
  final String name;
  final String photoURL;
  final GeoPoint coordinates;
  final int crowdLevel;

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
