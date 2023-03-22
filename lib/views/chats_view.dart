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
  UserInfo? friendInfo;
  UserInfo? currentUser;
  List<dynamic> friendsList = [];
  List<UserInfo>? friendsInfo = [];

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();

    await dbService.getUserInfo(uid).then((value) {
      setState(() {
        currentUser = value;
        friendsList = value!.friends;
      });
    });
  }

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
      body: RefreshIndicator(
        onRefresh: () async {
          friendsList = currentUser!.friends;
        },
        child: ListView(
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
              child: Builder(
                builder: (BuildContext builder) {
                  // tile for each friend
                  return ListView.builder(
                    itemCount: friendsList.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      if (friendsList.isEmpty) {
                        return const Text("You have no friends at the moment\n"
                            "Click the button on the top right to find friends");
                      } else {
                        return FutureBuilder(
                          future: dbService.getUserInfo(friendsList[index]),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return buildTile(snapshot.data as UserInfo);
                            } else {
                              return const Text("Loading...");
                            }
                          },
                        );
                      }
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTile(UserInfo user) => ListTile(
      leading: GestureDetector(
        onTap: () {
          Navigator.of(context).pushNamed(
            Routes.userRoute,
            arguments: user,
          );
        },
        child: CircleAvatar(
          // child: Text(user.firstName[0]),
          backgroundImage: NetworkImage(user.photoURL),
        ),
      ),
      title: Text("${user.firstName} ${user.lastName}"),
      subtitle: Text("@${user.username}"),
      onTap: () {
        Navigator.of(context).pushNamed(
          Routes.chatboxRoute,
          arguments: user,
        );
      });
}
