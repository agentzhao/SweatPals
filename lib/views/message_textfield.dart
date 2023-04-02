/// Done by Chin poh, Jarrel , Cheng Feng , Hong Zhao , Ryan
/// Version 1.1.5
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

/// Message Text Field Widget
class MessageTextField extends StatefulWidget {
  /// Current User UID
  final String currentId;

  /// Friend User UID
  final String friendId;

  /// Contrustor
  const MessageTextField(this.currentId, this.friendId, {super.key});

  @override
  MessageTextFieldState createState() => MessageTextFieldState();
}

/// Message TextField Background Task
class MessageTextFieldState extends State<MessageTextField> {
  /// Message TextBox Controller
  final TextEditingController _controller = TextEditingController();

  /// Process for Message Text Field
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey.shade800,
      padding: const EdgeInsetsDirectional.all(8),
      child: Row(
        children: [
          Expanded(
              child: TextField(
            controller: _controller,
            decoration: InputDecoration(
                labelText: "Type your Message",
                fillColor: Colors.grey.shade800,
                filled: true,
                border: OutlineInputBorder(
                    borderSide: const BorderSide(width: 0),
                    gapPadding: 10,
                    borderRadius: BorderRadius.circular(25))),
          )),
          const SizedBox(
            width: 20,
          ),
          GestureDetector(
            onTap: () async {
              String message = _controller.text;
              _controller.clear();
              await FirebaseFirestore.instance
                  .collection('users')
                  .doc(widget.currentId)
                  .collection('messages')
                  .doc(widget.friendId)
                  .collection('chats')
                  .add({
                "senderId": widget.currentId,
                "receiverId": widget.friendId,
                "message": message,
                "type": "text",
                "date": DateTime.now(),
              }).then((value) {
                FirebaseFirestore.instance
                    .collection('users')
                    .doc(widget.currentId)
                    .collection('messages')
                    .doc(widget.friendId)
                    .set({
                  'last_msg': message,
                });
              });

              await FirebaseFirestore.instance
                  .collection('users')
                  .doc(widget.friendId)
                  .collection('messages')
                  .doc(widget.currentId)
                  .collection("chats")
                  .add({
                "senderId": widget.currentId,
                "receiverId": widget.friendId,
                "message": message,
                "type": "text",
                "date": DateTime.now(),
              }).then((value) {
                FirebaseFirestore.instance
                    .collection('users')
                    .doc(widget.friendId)
                    .collection('messages')
                    .doc(widget.currentId)
                    .set({"last_msg": message});
              });
            },
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.green,
              ),
              child: const Icon(
                Icons.send,
                color: Colors.white,
              ),
            ),
          )
        ],
      ),
    );
  }
}
