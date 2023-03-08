import "package:flutter/material.dart";
import 'package:sweatpals/constants/routes.dart';
import 'package:sweatpals/services/auth/auth_service.dart';
import 'package:sweatpals/services/db/db_service.dart';
import 'package:sweatpals/services/storage/storage_service.dart';
import 'package:sweatpals/components/profile_picture.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:sweatpals/constants/activities.dart';

class GymView extends StatefulWidget {
  final GymInfo gym;

  const GymView({
    Key? key,
    required this.gym,
  }) : super(key: key);

  @override
  _GymViewState createState() => _GymViewState();
}

class _GymViewState extends State<GymView> {
  final dbService = DbService();
  final storageService = StorageService();
  UserInfo? currentUser;
  bool isFavourite = false;

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    dbService
        .getUserInfo(AuthService.firebase().currentUser!.uid)
        .then((value) {
      setState(() {
        currentUser = value;
        isFavourite = currentUser!.favourites.contains(widget.gym.INC_CRC);
      });
    });

    // if no gym photo
    // if (widget.gym.PHOTOURL == "") {
    //   widget.gym.PHOTOURL = 'assets/images/gym.png';
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gym Info'),
      ),
      floatingActionButton: Container(
        margin: const EdgeInsets.only(top: 60),
        height: 40,
        width: 40,
        child: FloatingActionButton(
          onPressed: () {
            if (isFavourite) {
              dbService.removeFavourite(
                AuthService.firebase().currentUser!.uid,
                widget.gym.INC_CRC,
              );
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Gym removed from favourites'),
                  duration: Duration(seconds: 1),
                ),
              );
              setState(() {
                isFavourite = false;
              });
            } else {
              dbService.addFavourite(
                AuthService.firebase().currentUser!.uid,
                widget.gym.INC_CRC,
              );
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Gym added to favourites'),
                  duration: Duration(seconds: 1),
                ),
              );
              setState(() {
                isFavourite = true;
              });
            }
          },
          backgroundColor: Colors.transparent,
          tooltip: 'Friend',
          elevation: 0,
          splashColor: Colors.grey,
          child: isFavourite
              ? const Icon(
                  Icons.favorite,
                  color: Colors.red,
                  size: 25,
                )
              : const Icon(
                  Icons.favorite_outline_rounded,
                  color: Colors.white,
                  size: 25,
                ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndTop,
      body: ListView(
        children: <Widget>[
          const SizedBox(height: 24),
          // Profile Picture
          ProfilePicture(
            imagePath: widget.gym.PHOTOURL.isNotEmpty
                ? widget.gym.PHOTOURL
                : 'https://i.pinimg.com/originals/6a/87/b0/6a87b06ee4f2c9ff739f1a4eaa901785.jpg',
            onClicked: () => {},
            isEdit: false,
          ),
          // name and username
          Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.only(
              left: 20,
              right: 20,
            ),
            child: buildGym(widget.gym),
          ),
        ],
      ),
    );
  }
}

Widget buildGym(GymInfo gym) => Column(
      children: [
        ListTile(
          title: Text(
            gym.NAME,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 24),
          ),
          subtitle: Text(
            gym.DESCRIPTION,
            textAlign: TextAlign.center,
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 20.0),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Crowd Level: ",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 15),
            ),
            const Icon(Icons.people),
            const SizedBox(width: 5),
            Text(
              "${gym.crowdlevel}",
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 15),
            ),
          ],
        ),
      ],
    );
