import 'package:cloud_firestore/cloud_firestore.dart';
import "package:flutter/material.dart";
import 'package:sweatpals/services/auth/auth_service.dart';
import 'package:sweatpals/services/db/db_service.dart';
import 'package:sweatpals/services/storage/storage_service.dart';
import 'package:sweatpals/views/singlemessage.dart';
import 'package:sweatpals/views/message_textfield.dart';



class ChatBoxView extends StatefulWidget {
  final UserInfo otherUser;
  const ChatBoxView({
    Key? key,
    required this.otherUser,
  }) : super(key: key);

  @override
  ChatBoxViewState createState() => ChatBoxViewState();
}

class ChatBoxViewState extends State<ChatBoxView> {
  final DbService dbService = DbService();
  final storageService = StorageService();

  String get uid => AuthService.firebase().currentUser!.uid;
  UserInfo? currentUser;
  UserInfo get otherUser => widget.otherUser;


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
      appBar: AppBar(
        title: Text(
            "${otherUser.firstName} ${otherUser.lastName} @${otherUser.username}"),
      ),
      body: Column(
        children: [
          // Show chat Message list
          Expanded(
              child: Container(
            padding: EdgeInsets.all(10),
            color: Colors.grey.shade800,
            child: StreamBuilder(
            
              stream: FirebaseFirestore.instance
                  .collection("users")
                  .doc(currentUser!.uid)
                  .collection('messages')
                  .doc(otherUser.uid)
                  .collection('chats')
                  .orderBy("date", descending: false)
                  .snapshots()
                  .asBroadcastStream(),
              builder: (context, AsyncSnapshot snapshot) {
                if (!snapshot.hasData) {
                  return CircularProgressIndicator();
                }
                if (snapshot.hasData) {
                  if (snapshot.data.docs.length < 1) {
                    return const Center(
                      child: Text("Say Hi"),
                    );
                  }
                  ScrollController sc = ScrollController();
                  return ListView.builder(
                    itemCount: snapshot.data.docs.length,
                    itemBuilder: (context, index) {
                      bool isMe = snapshot.data.docs[index]['senderId'] ==
                          currentUser!.uid;
                      return SingleMessage(
                          Message: snapshot.data.docs[index]['message'],
                          isMe: isMe);
                    },
                  );
                }
                return Center(child: CircularProgressIndicator());
              },
            ),
          )),
          // Message button
          MessageTextField(currentUser!.uid, otherUser.uid),
        ],
      ),
    );
  }
}
