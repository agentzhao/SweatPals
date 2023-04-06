/// Done by Chin poh, Jarrel , Cheng Feng , Hong Zhao , Ryan
/// Version 1.1.5
import "package:flutter/material.dart";
import 'package:sweatpals/constants/GymInfo.dart';
import 'package:sweatpals/constants/UserInfo.dart';
import 'package:sweatpals/services/auth/auth_service.dart';
import 'package:sweatpals/services/db/db_service.dart';
import 'package:sweatpals/services/storage/storage_service.dart';
import 'package:sweatpals/components/profile_picture.dart';
import 'package:url_launcher/url_launcher.dart';

/// Gym Info Page
class GymView extends StatefulWidget {
  /// Initialise GymInfo Class
  final GymInfo gym;

  /// Constructor
  const GymView({
    Key? key,
    required this.gym,
  }) : super(key: key);

  @override
  GymViewState createState() => GymViewState();
}

/// Gym Info Page Background
class GymViewState extends State<GymView> {
  /// Initialise Firebase Database Class
  final dbService = DbService();

  /// Initialise Storage Service Class
  final storageService = StorageService();

  /// Initliase User Info Class
  UserInfo? currentUser;

  /// Check Favourite Status
  bool isFavourite = false;

  late Uri _url;

  /// State Changes
  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    dbService
        .getUserInfo(AuthService.firebase().currentUser!.uid)
        .then((value) {
      setState(() {
        currentUser = value;
        isFavourite = currentUser!.favourites.contains(widget.gym.incCrc);
        _url = Uri.parse(
            'https://www.google.com/maps/search/?api=1&query=${widget.gym.name}');
      });
    });
  }

  /// Process for Gym Info Page
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
                widget.gym.incCrc,
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
                widget.gym.incCrc,
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
            imagePath: widget.gym.photoURL.isNotEmpty
                ? widget.gym.photoURL
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

  Future<void> _launchUrl() async {
    if (!await launchUrl(_url)) {
      throw Exception('Could not launch $_url');
    }
  }

  /// Display Gym info
  Widget buildGym(GymInfo gym) => Column(
        children: [
          ListTile(
            title: Text(
              gym.name,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 24),
            ),
            subtitle: Text(
              gym.description,
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
                "${gym.crowdLevel}",
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 15),
              ),
            ],
          ),
          const SizedBox(height: 10),
          // link to google maps
          ElevatedButton(
            onPressed: _launchUrl,
            child: const Text('View on Google Maps'),
          ),
        ],
      );
}
