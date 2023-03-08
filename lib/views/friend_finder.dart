import "package:flutter/material.dart";
import 'package:sweatpals/services/auth/auth_service.dart';
import 'package:sweatpals/services/db/db_service.dart';
import 'package:sweatpals/services/storage/storage_service.dart';
import 'package:sweatpals/components/profile_picture.dart';
import 'package:sweatpals/constants/activities.dart';
import 'package:appinio_swiper/appinio_swiper.dart';
import 'package:flutter/cupertino.dart';
import 'package:sweatpals/components/swiper_buttons.dart';
import 'package:fluttertoast/fluttertoast.dart';

class FriendFinderView extends StatefulWidget {
  const FriendFinderView({Key? key}) : super(key: key);

  @override
  _FriendFinderViewState createState() => _FriendFinderViewState();
}

class _FriendFinderViewState extends State<FriendFinderView> {
  final AppinioSwiperController controller = AppinioSwiperController();
  final DbService dbService = DbService();

  UserInfo? currentUser;
  List<UserInfo> usersList = [];

  List<Container> cards = [];

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    await dbService.getUserInfo(AuthService.firebase().currentUser!.uid).then(
      (value) {
        setState(() {
          currentUser = value;
        });
      },
    );
    await dbService.getAllUsers(currentUser!.uid).then((value) {
      setState(() {
        usersList = value;
      });
    });

    // load cards
    cards = usersList
        .map(
          (user) => Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.white,
              ),
              borderRadius: const BorderRadius.all(Radius.circular(20)),
              color: Colors.white,
            ),
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                profileImage(user.photoURL),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  '${user.firstName} ${user.lastName}',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  alignment: Alignment.center,
                  child: Text(
                    intToString(user.activities).join(', '),
                    style: const TextStyle(
                      fontSize: 15,
                    ),
                  ),
                ),
              ],
            ),
          ),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: Column(
        children: [
          const SizedBox(
            height: 50,
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.82,
            child: AppinioSwiper(
              unlimitedUnswipe: true,
              controller: controller,
              cards: cards,
              unswipe: _unswipe,
              onSwipe: _swipe,
              padding: const EdgeInsets.only(
                left: 25,
                right: 25,
                top: 25,
                bottom: 40,
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                width: 80,
              ),
              swipeLeftButton(controller),
              const SizedBox(
                width: 20,
              ),
              swipeRightButton(controller),
              const SizedBox(
                width: 20,
              ),
              unswipeButton(controller),
            ],
          )
        ],
      ),
    );
  }

  void _swipe(int index, AppinioSwiperDirection direction) {
    print("the card was swiped to the: ${direction.name}");
    // swipe right
    if (direction.name == "right") {
      // add to friends
      dbService.addFriend(currentUser!.uid, usersList[index].uid);
      // Toast message
      Fluttertoast.showToast(
        msg: "Added ${usersList[index].firstName} to your friends list!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.grey,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    } else {
      // swipe left
      // add back to cards list
      cards.add(cards.removeAt(0));
    }
  }

  void _unswipe(bool unswiped) {
    if (unswiped) {
      print("SUCCESS: card was unswiped");
      // add back to cards
      cards.add(cards.removeAt(0));
    } else {
      print("FAIL: no card left to unswipe");
    }
  }

  Widget profileImage(String imagePath) {
    final image = NetworkImage(imagePath);

    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.white,
        ),
        borderRadius: const BorderRadius.all(
          Radius.circular(20),
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: Ink.image(
          image: image,
          fit: BoxFit.cover,
          width: 300,
          height: 300,
          child: InkWell(
            onTap: () {},
          ),
        ),
      ),
    );
  }
}
