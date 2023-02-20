import 'package:flutter/material.dart';
import 'package:sweatpals/services/auth/auth_service.dart';
import 'package:sweatpals/components/text_field_widget.dart';
import 'package:sweatpals/services/db/db_service.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:sweatpals/constants/activities.dart';
import 'package:sweatpals/constants/routes.dart';

class EditProfileView extends StatefulWidget {
  const EditProfileView({Key? key}) : super(key: key);

  @override
  _EditProfileViewState createState() => _EditProfileViewState();
}

// todo: _selectedActivities keeps getting resetted

class _EditProfileViewState extends State<EditProfileView> {
  late final String _uid;
  late final TextEditingController _firstName;
  late final TextEditingController _lastName;
  late final TextEditingController _username;
  late final bool _isUserVerified;

  final dbService = DbService();
  List<Activity> _selectedActivities = [];

  String get uid => AuthService.firebase().currentUser!.uid;
  String get username => AuthService.firebase().currentUser!.username!;
  bool get isUserVerified =>
      AuthService.firebase().currentUser!.isEmailVerified;

  @override
  void initState() {
    _uid = uid;
    _firstName = TextEditingController();
    _lastName = TextEditingController();
    _username = TextEditingController(text: username);
    _isUserVerified = isUserVerified;
    // _selectedActivities = [];
    super.initState();
  }

  @override
  void dispose() {
    _firstName.dispose();
    _lastName.dispose();
    _username.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 32),
        children: [
          const SizedBox(height: 24),
          TextFormField(
            controller: _username,
            enableSuggestions: false,
            autocorrect: false,
            keyboardType: TextInputType.name,
            decoration: const InputDecoration(
              labelText: 'Username',
            ),
          ),
          const SizedBox(height: 24),
          Container(
            alignment: Alignment.center,
            child: FutureBuilder<UserInfo?>(
              future: dbService.getUserInfo(uid),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final user = snapshot.data;
                  _selectedActivities = idsToActivity(user!.activities);
                  _firstName.text = user.firstName;
                  _lastName.text = user.lastName;
                  return buildActivity(user);
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () async {
              try {
                await AuthService.firebase().updateDisplayName(
                  _username.text,
                );
                await dbService.updateName(
                  uid,
                  _firstName.text,
                  _lastName.text,
                );
                await dbService.updateActivities(
                  uid,
                  activityToIds(_selectedActivities),
                );
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Profile updated'),
                  ),
                );
                Navigator.of(context).pushNamedAndRemoveUntil(
                  Routes.profileRoute,
                  (route) => false,
                );
              } catch (e) {
                print(e);
              }
            },
            child: const Text('Update'),
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.only(
              left: 12.0,
              right: 12.0,
              bottom: 12.0,
            ),
            child: Text(
              _isUserVerified ? 'Email Verified' : 'Email Not Verified',
            ),
          ),
          Container(
            padding: const EdgeInsets.only(
              left: 12.0,
              right: 12.0,
              bottom: 12.0,
            ),
            child: Text(
              'UID: $_uid',
            ),
          ),
        ],
      ),
    );
  }

  Widget buildActivity(UserInfo user) => Column(
        children: <Widget>[
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'First Name',
                  ),
                  enableSuggestions: false,
                  autocorrect: false,
                  keyboardType: TextInputType.name,
                  controller: _firstName,
                  onChanged: (name) {},
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Last Name',
                  ),
                  enableSuggestions: false,
                  autocorrect: false,
                  keyboardType: TextInputType.name,
                  controller: _lastName,
                  onChanged: (name) {},
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Text(
            'Favourite Activity Types',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          MultiSelectBottomSheetField(
            initialChildSize: 0.4,
            listType: MultiSelectListType.CHIP,
            searchable: true,
            buttonText: const Text(
              "Favorite Activities (Select at least 3)",
            ),
            title: const Text("Activities"),
            items: activities
                .map((a) => MultiSelectItem<Activity>(a, a.name))
                .toList(),
            initialValue: _selectedActivities,
            onConfirm: (values) {
              setState(() {
                _selectedActivities = values.cast<Activity>();
                printActivities(_selectedActivities);
              });
            },
            chipDisplay: MultiSelectChipDisplay(
              onTap: (value) {
                setState(() {
                  _selectedActivities.remove(value);
                  printActivities(_selectedActivities);
                });
              },
            ),
          ),
          _selectedActivities.length < 3
              ? Container(
                  padding: const EdgeInsets.all(10),
                  alignment: Alignment.center,
                  child: const Text(
                    "Please select at least 3 activities",
                    style: TextStyle(color: Colors.red),
                  ),
                )
              : Container(),
        ],
      );
}
