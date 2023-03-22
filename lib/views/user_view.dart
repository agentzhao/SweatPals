import "package:flutter/material.dart";
import 'package:sweatpals/services/auth/auth_service.dart';
import 'package:sweatpals/services/db/db_service.dart';
import 'package:sweatpals/services/storage/storage_service.dart';
import 'package:sweatpals/components/profile_picture.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:sweatpals/constants/activities.dart';

class UserView extends StatefulWidget {
  final UserInfo user;

  const UserView({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  UserViewState createState() => UserViewState();
}

class UserViewState extends State<UserView> {
  final dbService = DbService();
  final storageService = StorageService();

  UserInfo? currentUser;
  bool isFriend = false;

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();

    dbService
        .getUserInfo(AuthService.firebase().currentUser!.uid)
        .then((value) {
      setState(() {
        currentUser = value;
        isFriend = currentUser!.friends.contains(widget.user.uid);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Profile'),
      ),
      floatingActionButton: Container(
        margin: const EdgeInsets.only(
          top: 60,
        ),
        height: 40,
        width: 40,
        child: FloatingActionButton(
          onPressed: () {
            if (isFriend) {
              dbService.removeFriend(
                AuthService.firebase().currentUser!.uid,
                widget.user.uid,
              );
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Friend removed'),
                  duration: Duration(seconds: 1),
                ),
              );
              setState(() {
                isFriend = false;
              });
            } else {
              dbService.addFriend(
                AuthService.firebase().currentUser!.uid,
                widget.user.uid,
              );
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Friend added'),
                  duration: Duration(seconds: 1),
                ),
              );
              setState(() {
                isFriend = true;
              });
            }
          },
          backgroundColor: Colors.transparent,
          tooltip: 'Friend',
          elevation: 0,
          splashColor: Colors.grey,
          child: isFriend
              ? const Icon(
                  Icons.person_remove,
                  color: Colors.red,
                  size: 25,
                )
              : const Icon(
                  Icons.person_add,
                  color: Colors.green,
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
            imagePath: widget.user.photoURL,
            onClicked: () => {},
            isEdit: false,
          ),
          // name and username
          Container(
            padding: const EdgeInsets.only(
              left: 20,
              right: 20,
            ),
            alignment: Alignment.center,
            child: buildUser(widget.user),
          ),
        ],
      ),
    );
  }
}

Widget buildUser(UserInfo user) => Column(
      children: [
        ListTile(
          title: Text(
            "${user.firstName} ${user.lastName}",
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 24),
          ),
          subtitle: Text(
            "@${user.username}",
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
