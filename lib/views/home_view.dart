import 'package:flutter/material.dart';
import 'package:sweatpals/services/auth/auth_service.dart';
import 'package:sweatpals/services/db/db_service.dart';
import 'package:sweatpals/services/storage/storage_service.dart';
import 'package:geolocator/geolocator.dart';
import 'package:sweatpals/services/map/location.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final DbService dbService = DbService();
  final storageService = StorageService();

  String get uid => AuthService.firebase().currentUser!.uid;
  String get username => AuthService.firebase().currentUser!.username!;

  GeoPoint currentLocation = const GeoPoint(0, 0);
  UserInfo? currentUser;
  List<GymInfo> gymsList = [];

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
    await dbService.sortByDistance(currentLocation).then((value) {
      setState(() {
        gymsList = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: ListView(
          children: [
            const SizedBox(height: 24),
            Container(
              child: currentUser != null
                  ? welcomeText(currentUser!)
                  : const Center(
                      child: CircularProgressIndicator(),
                    ),
            ),
            const SizedBox(height: 24),
            Container(
              alignment: Alignment.centerLeft,
              child: const Text(
                "     Facilities Near You",
                style: TextStyle(
                  fontSize: 24,
                  // fontWeight: FontWeight.bold,
                ),
              ),
            ),
            // if no gyms, show no gyms
            // else show list of gyms
            ListView.builder(
              itemCount: gymsList.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                if (gymsList.isEmpty)
                  return const Text("No gyms near you");
                else
                  return buildTile(gymsList[index]);
              },
            ),

            // show current user location at bottom of screen
            Container(
              alignment: Alignment.bottomCenter,
              child: Text(
                "Current Location: ${currentLocation.latitude}, ${currentLocation.longitude}",
                style: const TextStyle(
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _refreshData() async {
    // Perform any asynchronous operation to refresh data.
    getCurrentLocation().then((value) {
      setState(() {
        currentLocation = value;
      });
    });
    await dbService.sortByDistance(currentLocation).then((value) {
      setState(() {
        gymsList = value;
      });
    });
  }

  Widget welcomeText(UserInfo user) {
    if (user == null) {
      return const Center(child: CircularProgressIndicator());
    }
    return Column(
      children: [
        Container(
            alignment: Alignment.centerLeft,
            child: Text("    Time to get sweaty, \n    ${user.firstName}",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                )))
      ],
    );
  }

  Widget buildTile(GymInfo gym) => Container(
        margin: const EdgeInsets.symmetric(
          vertical: 0,
          horizontal: 16,
        ),
        child: ListTile(
          leading: CircleAvatar(
            child: Text(gym.NAME[0]),
          ),
          title: Text(gym.NAME),
          subtitle: Text("Distance: ${dbService.distanceBetween(
            currentLocation,
            gym.coordinates,
          )} km"),
        ),
      );

  Future<GeoPoint> getCurrentLocation() async {
    await getLocationPermission();
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    return GeoPoint(position.latitude, position.longitude);
  }
}
