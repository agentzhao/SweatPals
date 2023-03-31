/// Done by Chin poh, Jarrel , Cheng Feng , Hong Zhao , Ryan
/// Version 1.1.5
import 'package:flutter/material.dart';
import 'package:sweatpals/services/auth/auth_service.dart';
import 'package:sweatpals/services/db/db_service.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:sweatpals/constants/activities.dart';
import 'package:sweatpals/utilities/toast.dart';

/// Edit Profile Page 
class EditProfileView extends StatefulWidget {
  const EditProfileView({Key? key}) : super(key: key);

  @override
  EditProfileViewState createState() => EditProfileViewState();
}

// todo: _selectedActivities keeps getting resetted
/// Edit Profile Background
class EditProfileViewState extends State<EditProfileView> {
  /// Text for User UID
  late final String _uid;
  /// Text Box Controller for FirstName
  late final TextEditingController _firstName;
  /// Text Box Controller for LastName
  late final TextEditingController _lastName;
  /// Text Box Controller for UserName
  late final TextEditingController _username;
  /// Check User Verify Status
  late final bool _isUserVerified;
  /// Initliase Firebase DataBase Class
  final dbService = DbService();
  /// List of Activities
  List<Activity> _selectedActivities = [];
  /// Initialise User Info Class
  UserInfo? user;
  // late UserInfo user;
  /// Retrieve Current User UID
  String get uid => AuthService.firebase().currentUser!.uid;
  /// Retrieve Current User UserName
  String get username => AuthService.firebase().currentUser!.username!;
  /// Retrive User Verify Status from Firebase
  bool get isUserVerified =>
      AuthService.firebase().currentUser!.isEmailVerified;
  /// Check Mounted Status
  bool _isMounted = false;
  /// Initial State
  @override
  void initState() {
    super.initState();
    _isMounted = true;
    _uid = uid;
    _firstName = TextEditingController();
    _lastName = TextEditingController();
    _username = TextEditingController(text: username);
    _isUserVerified = isUserVerified;
  }
  ///State Changes
  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    if (_isMounted == false) return;
    await dbService.getUserInfo(uid).then((value) {
      setState(() {
        user = value;
        _firstName.text = user!.firstName;
        _lastName.text = user!.lastName;
        _selectedActivities = idsToActivity(user!.activities);
      });
    });
  }
  /// Exit State
  @override
  void dispose() {
    super.dispose();
    _firstName.dispose();
    _lastName.dispose();
    _username.dispose();
  }
  ///Process For Edit Profile page
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
          // todo: fix activity not being removed
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
              });
            },
            chipDisplay: MultiSelectChipDisplay(
              onTap: (value) {
                setState(() {
                  _selectedActivities.remove(value);
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
                // ScaffoldMessenger.of(context).showSnackBar(
                //   const SnackBar(
                //     content: Text('Profile updated'),
                //   ),
                // );
                showToast("Profile updated!");
                // Back to profile page
                if (context.mounted) {
                  Navigator.of(context).pop('/edit-profile');
                }
              } catch (e) {
                // catch e
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
}
