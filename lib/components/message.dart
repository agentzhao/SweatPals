/// Done by Chin poh, Jarrel , Cheng Feng , Hong Zhao , Ryan
/// Version 1.1.5
import 'package:flutter/material.dart';
/// Message Widget
class MessageWidget extends StatefulWidget {
  /// Text for Username
  final String username;
  /// Text for Messages
  final String message;

  const MessageWidget({
    Key? key,
    required this.username,
    required this.message,
  }) : super(key: key);

  @override
  MessageWidgetState createState() => MessageWidgetState();
}
/// Message Widget background
class MessageWidgetState extends State<MessageWidget> {
  /// Process for Message widget
  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.username,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              widget.message,
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
          ],
        ),
      );
}
