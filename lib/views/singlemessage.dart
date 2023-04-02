/// Done by Chin poh, Jarrel , Cheng Feng , Hong Zhao , Ryan
/// Version 1.1.5

import 'package:flutter/material.dart';

/// Single Message Widget
class SingleMessage extends StatelessWidget {
  /// Text of Message
  final String message;

  /// Check Status of Who is Sending
  final bool isMe;

  /// Contrustor
  const SingleMessage({super.key, required this.message, required this.isMe});

  /// Process of Single Message Widget
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Container(
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.all(16),
            constraints: const BoxConstraints(maxWidth: 200),
            decoration: BoxDecoration(
                color: isMe ? Colors.green : Colors.grey[700],
                borderRadius: const BorderRadius.all(Radius.circular(12))),
            child: Text(
              message,
              style: const TextStyle(color: Colors.white),
            )),
      ],
    );
  }
}
