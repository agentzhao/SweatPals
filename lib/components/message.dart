import 'package:flutter/material.dart';

class MessageWidget extends StatefulWidget {
  final String username;
  final String message;

  const MessageWidget({
    Key? key,
    required this.username,
    required this.message,
  }) : super(key: key);

  @override
  _MessageWidgetState createState() => _MessageWidgetState();
}

class _MessageWidgetState extends State<MessageWidget> {
  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.username,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              widget.message,
              style: TextStyle(
                fontSize: 16,
              ),
            ),
          ],
        ),
      );
}
