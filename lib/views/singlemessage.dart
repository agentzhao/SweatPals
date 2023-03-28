/// Done by Chin poh, Jarrel , Cheng Feng , Hong Zhao , Ryan
/// Version 1.1.5

import 'package:flutter/material.dart';
/// Single Message Widget
class SingleMessage extends StatelessWidget {
  /// Text of Message
  final String Message;
  /// Check Status of Who is Sending 
  final bool isMe;

  /// Contrustor
  const SingleMessage({required this.Message, required this.isMe});
  
  /// Process of Single Message Widget
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Container(
            padding: EdgeInsets.all(16),
            margin: EdgeInsets.all(16),
            constraints: BoxConstraints(maxWidth: 200),
            decoration: BoxDecoration(
                color: isMe ? Colors.green : Colors.grey[700],
                borderRadius: BorderRadius.all(Radius.circular(12))),
            child: Text(
              Message,
              style: TextStyle(color: Colors.white),
            )),
      ],
    );
  }
}
