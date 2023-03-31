  /// Done by Chin poh, Jarrel , Cheng Feng , Hong Zhao , Ryan
  /// Version 1.1.5
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:appinio_swiper/appinio_swiper.dart';
/// Example button widget
class ExampleButton extends StatelessWidget {
  /// Function On Tap
  final Function onTap;
  /// Widget child
  final Widget child;

  const ExampleButton({
    required this.onTap,
    required this.child,
    Key? key,
  }) : super(key: key);
  ///Process for Example button
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(),
      child: child,
    );
  }
}

/// Swipe card to the right side
Widget swipeRightButton(AppinioSwiperController controller) {
  return ExampleButton(
    onTap: () => controller.swipeRight(),
    child: Container(
      height: 60,
      width: 60,
      decoration: BoxDecoration(
        color: CupertinoColors.activeGreen,
        borderRadius: BorderRadius.circular(50),
        boxShadow: [
          BoxShadow(
            color: CupertinoColors.activeGreen.withOpacity(0.9),
            spreadRadius: -10,
            blurRadius: 20,
            offset: const Offset(0, 20), // changes position of shadow
          ),
        ],
      ),
      alignment: Alignment.center,
      child: const Icon(
        Icons.check,
        color: CupertinoColors.white,
        size: 40,
      ),
    ),
  );
}

/// Swipe card to the left side
Widget swipeLeftButton(AppinioSwiperController controller) {
  return ExampleButton(
    onTap: () => controller.swipeLeft(),
    child: Container(
      height: 60,
      width: 60,
      decoration: BoxDecoration(
        color: const Color(0xFFFF3868),
        borderRadius: BorderRadius.circular(50),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFF3868).withOpacity(0.9),
            spreadRadius: -10,
            blurRadius: 20,
            offset: const Offset(0, 20), // changes position of shadow
          ),
        ],
      ),
      alignment: Alignment.center,
      child: const Icon(
        Icons.close,
        color: CupertinoColors.white,
        size: 40,
      ),
    ),
  );
}

///Unswipe card
Widget unswipeButton(AppinioSwiperController controller) {
  return ExampleButton(
    onTap: () => controller.unswipe(),
    child: Container(
      height: 60,
      width: 60,
      alignment: Alignment.center,
      child: const Icon(
        Icons.rotate_left_rounded,
        color: CupertinoColors.systemGrey2,
        size: 40,
      ),
    ),
  );
}
