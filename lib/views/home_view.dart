/// Done by Chin poh, Jarrel , Cheng Feng , Hong Zhao , Ryan
/// Version 1.1.5
import 'package:flutter/material.dart';
import 'package:sweatpals/services/auth/auth_service.dart';
import 'package:sweatpals/services/db/db_service.dart';
import 'package:sweatpals/services/storage/storage_service.dart';
import 'package:geolocator/geolocator.dart';
import 'package:sweatpals/services/map/location.dart';
import 'package:sweatpals/constants/routes.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// Home Page
class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  HomeViewState createState() => HomeViewState();
}
/// Home Page Background
class HomeViewState extends State<HomeView> {
  /// Intialise FireBase Database Class
  final DbService dbService = DbService();
  /// Initalise Storage Service Class
  final storageService = StorageService();
  /// Retrieve Current User UID
  String get uid => AuthService.firebase().currentUser!.uid;
  /// Retireve Current Username
  String get username => AuthService.firebase().currentUser!.username!;
  /// Initialise Geo Point
  GeoPoint? currentLocation;
  /// Initialise Current UserInfo
  UserInfo? currentUser;
  /// List of Gym Info
  List<GymInfo> gymsList = [];
  /// Check isitMounted Status
  bool _isMounted = true;

  /// Initial State
  @override
  void initState() {
    super.initState();
    _isMounted = true;
    // rest of initState code...
  }
  /// State Changes
  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();

    if (!_isMounted) return;
    await getCurrentLocation().then((value) {
      setState(() {
        currentLocation = value;
      });
    });
    if (!_isMounted) return;
    await dbService.getUserInfo(uid).then((value) {
      setState(() {
        currentUser = value;
      });
    });
    if (!_isMounted) return;
    await dbService.nearestGyms(currentLocation!).then((value) {
      setState(() {
        gymsList = value;
      });
    });
  }
  /// Exit State
  @override
  void dispose() {
    _isMounted = false;
    super.dispose();
  }
  /// Process for Home Page
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
            // if no gyms near you, show "No gyms near you"
            ListView.builder(
              itemCount: gymsList.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                if (gymsList.isEmpty) {
                  return const Text("No gyms near you");
                } else {
                  return buildTile(gymsList[index]);
                }
              },
            ),

            // show current user location at bottom of screen
            Container(
              alignment: Alignment.bottomCenter,
              child: currentLocation != null
                  ? Text(
                      "Current Location: ${currentLocation!.latitude}, ${currentLocation!.longitude}",
                      style: const TextStyle(
                        fontSize: 12,
                      ),
                    )
                  : const Center(
                      child: CircularProgressIndicator(),
                    ),
            ),

            const SizedBox(height: 10),

            // Workout and Route Track buttons
            Container(
              alignment: Alignment.bottomCenter,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(
                        context,
                        Routes.workoutRoute,
                      );
                    },
                    child: const Text("Workout"),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(
                        context,
                        Routes.routeTrackRoute,
                      );
                    },
                    child: const Text("Route Tracker"),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  /// Refresh Data 
  Future<void> _refreshData() async {
    // Perform any asynchronous operation to refresh data.
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
    await dbService.nearestGyms(currentLocation!).then((value) {
      setState(() {
        gymsList = value;
      });
    });
  }
  /// Display Welcome Text 
  Widget welcomeText(UserInfo user) {
    return Column(
      children: [
        Container(
            alignment: Alignment.centerLeft,
            child: Text("    Time to get sweaty, \n    ${user.firstName}",
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                )))
      ],
    );
  }
  /// Display Nearby Gym 
  Widget buildTile(GymInfo gym) => Container(
        margin: const EdgeInsets.symmetric(
          vertical: 0,
          horizontal: 16,
        ),
        child: ListTile(
            leading: CircleAvatar(
              child: Text(gym.name[0]),
            ),
            title: Text(gym.name),
            subtitle: Text("Distance: ${dbService.distanceBetween(
              currentLocation!,
              gym.coordinates,
            )} km"),
            onTap: () {
              Navigator.of(context).pushNamed(
                Routes.gymRoute,
                arguments: gym,
              );
            }),
      );
 /// Get Device Current Location
  Future<GeoPoint> getCurrentLocation() async {
    await getLocationPermission();
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    return GeoPoint(position.latitude, position.longitude);
  }
}
