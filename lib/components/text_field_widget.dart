  /// Done by Chin poh, Jarrel , Cheng Feng , Hong Zhao , Ryan
  /// Version 1.1.5
import 'package:flutter/material.dart';
/// Text Field Widget
class TextFieldWidget extends StatefulWidget {
  /// Number of Maximum Lines
  final int maxLines;
  /// Label Text
  final String label;
  /// Label Message
  final String text;
  /// Detect Value Changes
  final ValueChanged<String> onChanged;
  /// Constructor
  const TextFieldWidget({
    Key? key,
    this.maxLines = 1,
    required this.label,
    required this.text,
    required this.onChanged,
  }) : super(key: key);

  @override
  TextFieldWidgetState createState() => TextFieldWidgetState();
}
/// Text Field Widget Background
class TextFieldWidgetState extends State<TextFieldWidget> {
  /// TextBox Controller
  late final TextEditingController controller;
  /// Initial State
  @override
  void initState() {
    super.initState();
    controller = TextEditingController(text: widget.text);
  }
  /// Exit State
  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }
  /// Process for Text Field Widget
  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.label,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: controller,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            maxLines: widget.maxLines,
          ),
        ],
      );
}
