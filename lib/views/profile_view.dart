import 'package:flutter/material.dart';
import 'package:sweatpals/constants/routes.dart';
import 'package:sweatpals/services/auth/auth_service.dart';
import 'package:sweatpals/components/profile_picture.dart';

import 'package:image_picker/image_picker.dart';

// import 'package:sweatpals/enums/menu_action.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({Key? key}) : super(key: key);

  @override
  _ProfileViewState createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  String get username => AuthService.firebase().currentUser!.username!;
  String get userEmail =>
      AuthService.firebase().currentUser?.email ?? "no email (guest)";
  String get photoUrl =>
      AuthService.firebase().currentUser?.photoUrl ??
      "https://pngimg.com/uploads/github/github_PNG80.png";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            Positioned(
              top: 10,
              right: 10,
              child: Container(
                height: 40,
                width: 40,
                child: FloatingActionButton(
                  heroTag: "settings",
                  child: Icon(
                    size: 25,
                    Icons.settings,
                    color: Colors.white,
                  ),
                  backgroundColor: Colors.green,
                  onPressed: () {
                    Navigator.of(context).pushNamed(
                      settingsRoute,
                    );
                  },
                ),
              ),
            ),
            //position in the center
            Positioned(
              top: 10,
              right: 60,
              child: Container(
                height: 40,
                width: 40,
                child: FloatingActionButton(
                  heroTag: "edit_profile",
                  child: Icon(
                    size: 25,
                    Icons.edit,
                    color: Colors.white,
                  ),
                  backgroundColor: Colors.green,
                  onPressed: () {
                    Navigator.of(context).pushNamed(
                      editProfileRoute,
                    );
                  },
                ),
              ),
            ),
            // Profile Picture
            Positioned(
              top: 50,
              left: 10,
              right: 10,
              child: ProfilePicture(
                imagePath: photoUrl,
                isEdit: true,
                onClicked: () => selectImage(),
              ),
            ),

            // Username
            Positioned(
              top: 180,
              left: 10,
              right: 10,
              child: Text(
                username,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
            ),
            // Email
            Positioned(
              top: 200,
              left: 10,
              right: 10,
              child: Text(
                userEmail,
                style: TextStyle(
                  color: Colors.grey,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Future selectImage() async {
  final image = await ImagePicker().pickImage(source: ImageSource.gallery);
  if (image == null) {
    return;
  } else {
    // todo: update image on storage
    print(image.path);
  }
}



  // appBar: AppBar(
      //   title: const Text('Profile'),
      //   actions: [
      //     PopupMenuButton<MenuAction>(
      //       onSelected: (value) async {
      //         switch (value) {
      //           case MenuAction.logout:
      //             final shouldLogout = await showLogOutDialog(context);
      //             if (shouldLogout) {
      //               await AuthService.firebase().logOut();
      //               Navigator.of(context).pushNamedAndRemoveUntil(
      //                 loginRoute,
      //                 (_) => false,
      //               );
      //             }
      //         }
      //       },
      //       itemBuilder: (context) {
      //         return const [
      //           PopupMenuItem<MenuAction>(
      //             value: MenuAction.logout,
      //             child: Text('Log out'),
      //           ),
      //         ];
      //       },
      //     )
      //   ],
      // ),

// Future<bool> showLogOutDialog(BuildContext context) {
//   return showDialog<bool>(
//     context: context,
//     builder: (context) {
//       return AlertDialog(
//         title: const Text('Sign out'),
//         content: const Text('Are you sure you want to sign out?'),
//         actions: [
//           TextButton(
//             onPressed: () {
//               Navigator.of(context).pop(false);
//             },
//             child: const Text('Cancel'),
//           ),
//           TextButton(
//             onPressed: () {
//               Navigator.of(context).pop(true);
//             },
//             child: const Text('Log out'),
//           ),
//         ],
//       );
//     },
//   ).then((value) => value ?? false);
// }
