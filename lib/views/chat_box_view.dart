import "package:flutter/material.dart";
import 'package:sweatpals/constants/routes.dart';
import 'package:sweatpals/services/auth/auth_service.dart';
import 'package:sweatpals/services/db/db_service.dart';
import 'package:sweatpals/services/storage/storage_service.dart';
import 'package:sweatpals/components/profile_picture.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:sweatpals/constants/activities.dart';

class ChatBoxView extends StatefulWidget {

 const ChatBoxView({Key? key}) : super(key: key);

  //@override
  _ChatBoxViewState createState() => _ChatBoxViewState();
}

class _ChatBoxViewState extends State<ChatBoxView> {
  final DbService dbService = DbService();
  final storageService = StorageService();
  UserInfo? currentUser;
  bool isFavourite = false;

  final TextEditingController _textController = TextEditingController();
  List<ChatMessage> _messages = [];

  void _handleSubmitted(String text) {
    _textController.clear();
    ChatMessage message = ChatMessage(text: text);
    setState(() {
      _messages.insert(0, message);
    });
  }

Widget _buildTextComposer() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _textController,
              onSubmitted: _handleSubmitted,
              decoration: InputDecoration.collapsed(hintText: "Send a message"),
            ),
          ),
          FloatingActionButton(
            onPressed: () => _handleSubmitted(_textController.text),
            child: Icon(Icons.send),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chat with <@UserName2>"),
      ),
      body: Column(
        children: [
          Flexible(
            child: ListView.builder(
              padding: EdgeInsets.all(8.0),
              reverse: true,
              itemBuilder: (_, int index) => _messages[index],
              itemCount: _messages.length,
            ),
          ),
          Divider(height: 1.0),
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
            ),
            child: _buildTextComposer(),
          ),
        ],
      ),
    );
  }
}
  
class ChatMessage extends StatelessWidget {
  final String text;

  ChatMessage({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(right: 16.0),
            child: CircleAvatar(
              child: Text("JD"),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("<@UserName>", style: Theme.of(context).textTheme.headline6),
                Container(
                  margin: EdgeInsets.only(top: 5.0),
                  child: Text(text),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
  



