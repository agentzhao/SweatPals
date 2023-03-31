/// Done by Chin poh, Jarrel , Cheng Feng , Hong Zhao , Ryan
/// Version 1.1.5
import 'package:flutter/material.dart';
/// Profile Picture widget
class ProfilePicture extends StatelessWidget {
  /// Text for Image Path 
  final String imagePath;
  /// Check Edit Status
  final bool isEdit;
  /// Check Callback from click Status
  final VoidCallback onClicked;

  const ProfilePicture({
    Key? key,
    required this.imagePath,
    required this.onClicked,
    required this.isEdit,
  }) : super(key: key);
  /// Process for Profile Picture widget
  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.primary;

    return Center(
      child: Stack(
        children: [
          buildImage(),
          Positioned(
            bottom: 0,
            right: 2,
            child: isEdit ? buildEditIcon(color) : Container(),
          )
        ],
      ),
    );
  }
/// Build Images
  Widget buildImage() {
    final image = NetworkImage(imagePath);

    return ClipOval(
      child: Material(
        color: Colors.transparent,
        child: Ink.image(
          image: image,
          fit: BoxFit.cover,
          width: 128,
          height: 128,
          child: InkWell(onTap: onClicked),
        ),
      ),
    );
  }
/// Build Edit Icon
  Widget buildEditIcon(Color color) => buildCircle(
        color: Colors.white,
        all: 1,
        child: buildCircle(
          color: color,
          all: 0,
          child: IconButton(
            iconSize: 0,
            icon: const Icon(
              Icons.add_a_photo,
              color: Colors.white,
              size: 25,
            ),
            onPressed: onClicked,
          ),
        ),
      );
/// Build Circle
  Widget buildCircle({
    required Widget child,
    required double all,
    required Color color,
  }) =>
      ClipOval(
        child: Container(
          padding: EdgeInsets.all(all),
          color: color,
          child: child,
        ),
      );
}
