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
  List<UserInfo> friendsInfo = [];

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();

    await dbService.getUserInfo(uid).then((value) {
      setState(() {
        currentUser = value;
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
                  friendsList = user!.friends;
                  // tile for each friend
                  for (int i = 0; i < friendsList.length; i++) {
                    String ff = friendsList[i] as String;
                    dbService.getUserInfo(ff).then((result) {
                      friendInfo = result;
                      friendsInfo.add(result!);
                    });
                  }

                  // if no friend, show "You have no friend"
                  return ListView.builder(
                    itemCount: friendsInfo.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      if (friendsInfo.isEmpty)
                        return const Text("You have no friends");
                      else
                        return buildTile(friendsInfo[index]);
                    },
                  );
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
      subtitle: Text("@${user.username}"),
      onTap: () {
        Navigator.of(context).pushNamed(
          Routes.chatboxRoute,
          arguments: user,
        );
      });
}
