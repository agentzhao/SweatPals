import 'package:sweatpals/constants/routes.dart';
import 'package:flutter/material.dart';
import 'package:sweatpals/services/auth/auth_service.dart';
import 'package:sweatpals/services/db/db_service.dart';
import 'package:sweatpals/services/storage/storage_service.dart';

class ChatsView extends StatefulWidget {
  const ChatsView({Key? key}) : super(key: key);

  @override
  _ChatsViewState createState() => _ChatsViewState();
}

class _ChatsViewState extends State<ChatsView> {
  final DbService dbService = DbService();
  final storageService = StorageService();

  String get uid => AuthService.firebase().currentUser!.uid;
  String get username => AuthService.firebase().currentUser!.username!;

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
              Routes.friendFinderRoute,
            );
          },
          backgroundColor: Colors.green,
          tooltip: 'Find Friends',
          elevation: 0,
          splashColor: Colors.grey,
          child: const Icon(
            Icons.person_add,
            color: Colors.white,
            size: 25,
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndTop,
      body: ListView(
        children: [
          const SizedBox(height: 24),
          const Text(
            "   Messages",
            style: TextStyle(
              fontSize: 24,
              // fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Container(
            alignment: Alignment.center,
            child: FutureBuilder<UserInfo?>(
              future: dbService.getUserInfo(uid),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final user = snapshot.data;
                  List<dynamic> friendsList = user!.friends;

                  // tile for each friend
                  for (int i = 0; i < friendsList.length; i++) {
                    print(friendsList[i]);
                  }
                  return buildTile(user);
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget buildTile(UserInfo user) => ListTile(
        leading: CircleAvatar(
          child: Text(user.firstName[0]),
        ),
        title: Text("${user.firstName} ${user.lastName}"),
        subtitle: Text("@$username"),
      );
}
