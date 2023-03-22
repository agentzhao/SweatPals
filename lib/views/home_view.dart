import 'package:flutter/material.dart';
import 'package:sweatpals/services/auth/auth_service.dart';
import 'package:sweatpals/services/db/db_service.dart';
import 'package:sweatpals/services/storage/storage_service.dart';
import 'package:geolocator/geolocator.dart';
import 'package:sweatpals/services/map/location.dart';
import 'package:sweatpals/constants/routes.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  HomeViewState createState() => HomeViewState();
}

class HomeViewState extends State<HomeView> {
  final DbService dbService = DbService();
  final storageService = StorageService();

  String get uid => AuthService.firebase().currentUser!.uid;
  String get username => AuthService.firebase().currentUser!.username!;

  GeoPoint? currentLocation;
  UserInfo? currentUser;
  List<GymInfo> gymsList = [];
  bool _isMounted = true;

  @override
  void initState() {
    super.initState();
    _isMounted = true;
    // rest of initState code...
  }

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

  @override
  void dispose() {
    _isMounted = false;
    super.dispose();
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

  Future<GeoPoint> getCurrentLocation() async {
    await getLocationPermission();
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    return GeoPoint(position.latitude, position.longitude);
  }
}
