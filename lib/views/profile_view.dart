/// Done by Chin poh, Jarrel , Cheng Feng , Hong Zhao , Ryan
/// Version 1.1.5
import 'package:flutter/material.dart';
import 'package:sweatpals/constants/UserInfo.dart';
import 'package:sweatpals/constants/routes.dart';
import 'package:sweatpals/services/auth/auth_service.dart';
import 'package:sweatpals/services/db/db_service.dart';
import 'package:sweatpals/services/storage/storage_service.dart';
import 'package:sweatpals/components/profile_picture.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:sweatpals/constants/activities.dart';
import 'package:sweatpals/utilities/toast.dart';

/// User Profile Page
class ProfileView extends StatefulWidget {
  const ProfileView({Key? key}) : super(key: key);

  @override
  ProfileViewState createState() => ProfileViewState();
}

/// User Profile Page Background
class ProfileViewState extends State<ProfileView> {
  ///initialise Firebase Database Class
  final dbService = DbService();

  ///initialise Storage Service Class
  final storageService = StorageService();

  /// Get Current User UID
  String get uid => AuthService.firebase().currentUser!.uid;

  /// Get Current User UserName
  String get username => AuthService.firebase().currentUser!.username!;

  /// Get the List of activites from Database
  List<int> get activities => dbService.getActivities(uid);

  /// Process for User Profile
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Container(
        margin: const EdgeInsets.only(top: 10),
        height: 40,
        width: 40,
        child: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).pushNamed(
              Routes.settingsRoute,
            );
          },
          backgroundColor: Colors.green,
          tooltip: 'Settings',
          elevation: 0,
          splashColor: Colors.grey,
          child: const Icon(
            Icons.settings,
            color: Colors.white,
            size: 25,
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndTop,
      body: ListView(
        children: <Widget>[
          const SizedBox(height: 24),
          // Profile Picture
          ProfilePicture(
            imagePath: AuthService.firebase().currentUser!.photoURL!,
            onClicked: editProfile,
            isEdit: true,
          ),
          // name and username
          Container(
            alignment: Alignment.center,
            child: FutureBuilder<UserInfo?>(
              future: dbService.getUserInfo(uid),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final user = snapshot.data;
                  return user == null
                      ? const Center(child: Text("No data"))
                      : buildUser(user);
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            ),
          ),

          // edit profile button
          Container(
            alignment: Alignment.center,
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushNamed(
                  Routes.editProfileRoute,
                );
              },
              child: const Text('Edit Profile'),
            ),
          ),
        ],
      ),
    );
  }

  /// To Edit User Profile
  Future<void> editProfile() async {
    String photoURL = await storageService.changeProfileImage(uid);

    if (photoURL != "") {
      await AuthService.firebase().updatePhotoURL(photoURL);
      setState(() {});
      showToast("Profile Picture Updated");
    }
  }

  Widget buildUser(UserInfo user) => Column(
        children: [
          ListTile(
            // leading: CircleAvatar(child: Text('1')),
            title: Text(
              "${user.firstName} ${user.lastName}",
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 24),
            ),
            subtitle: Text(
              "@$username",
              textAlign: TextAlign.center,
            ),
          ),
          const Text(
            "Favourite Activities",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 15),
          ),
          MultiSelectChipDisplay(
            items: intToString(user.activities)
                .map((e) => MultiSelectItem(e, e))
                .toList(),
          )
        ],
      );
}
