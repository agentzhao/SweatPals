import 'package:flutter/material.dart';
import 'package:sweatpals/constants/routes.dart';
import 'package:sweatpals/services/auth/auth_exceptions.dart';
import 'package:sweatpals/services/auth/auth_service.dart';
import 'package:sweatpals/utilities/show_error_dialog.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:sweatpals/constants/activities.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({Key? key}) : super(key: key);

  @override
  _RegisterViewState createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  late final TextEditingController _username;
  late final TextEditingController _email;
  late final TextEditingController _password;

  final _activities =
      activities.map((a) => MultiSelectItem<Activity>(a, a.name)).toList();
  List<Activity> _selectedActivities = [];

  @override
  void initState() {
    _username = TextEditingController();
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _username.dispose();
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
      ),
      body: Column(
        children: [
          Container(
            decoration: BoxDecoration(
                // color: Theme.of(context).primaryColor.withOpacity(.4),
                // border: Border.all(
                //   color: Theme.of(context).primaryColor,
                //   width: 2,
                // ),
                ),
            child: Column(
              children: <Widget>[
                MultiSelectBottomSheetField(
                  initialChildSize: 0.4,
                  listType: MultiSelectListType.CHIP,
                  searchable: true,
                  buttonText: Text("Favorite Activities (Select at least 3)"),
                  title: Text("Activities"),
                  items: _activities,
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
                        padding: EdgeInsets.all(10),
                        alignment: Alignment.center,
                        child: Text(
                          "Please select at least 3 activities",
                          style: TextStyle(color: Colors.red),
                        ),
                      )
                    : Container(),
              ],
            ),
          ),
          SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.only(left: 12.0, right: 12.0),
            child: TextField(
              controller: _username,
              enableSuggestions: false,
              autocorrect: false,
              keyboardType: TextInputType.name,
              decoration: const InputDecoration(
                hintText: 'Username',
              ),
            ),
          ),
          TextButton(
            onPressed: () async {
              // new anon user
              if (_username.text.isEmpty) {
                await showErrorDialog(
                  context,
                  'Please enter a username',
                );
                return;
              }
              try {
                dynamic result = await AuthService.firebase().logInAnon(
                  username: _username.text,
                );
                if (result == null) {
                  print("Error signing in as guest");
                } else {
                  print("Signed in as guest");
                }
              } on GenericAuthException {
                await showErrorDialog(
                  context,
                  'Authentication error',
                );
              }
              Navigator.of(context).pushNamedAndRemoveUntil(
                naviBarRoute,
                (route) => false,
              );
            },
            child: const Text('Continue as guest'),
          ),
          Container(
            padding: const EdgeInsets.only(left: 12.0, right: 12.0),
            child: TextField(
              controller: _email,
              enableSuggestions: false,
              autocorrect: false,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                hintText: 'Email',
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.only(
              left: 12.0,
              right: 12.0,
              bottom: 12.0,
            ),
            child: TextField(
              controller: _password,
              obscureText: true,
              enableSuggestions: false,
              autocorrect: false,
              decoration: const InputDecoration(
                hintText: 'Password',
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              if (_username.text.isEmpty) {
                await showErrorDialog(
                  context,
                  'Username cannot be empty',
                );
                return;
              }
              try {
                await AuthService.firebase().createUser(
                  username: _username.text,
                  email: _email.text,
                  password: _password.text,
                );
                AuthService.firebase().sendEmailVerification();
                Navigator.of(context).pushNamed(verifyEmailRoute);
              } on WeakPasswordAuthException {
                await showErrorDialog(
                  context,
                  'Weak password',
                );
              } on EmailAlreadyInUseAuthException {
                await showErrorDialog(
                  context,
                  'Email is already in use',
                );
              } on InvalidEmailAuthException {
                await showErrorDialog(
                  context,
                  'This is an invalid email address',
                );
              } on GenericAuthException {
                await showErrorDialog(
                  context,
                  'Failed to register',
                );
              }
            },
            child: const Text('Register'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pushNamedAndRemoveUntil(
                loginRoute,
                (route) => false,
              );
            },
            child: const Text('Already registered? Login here!'),
          ),
        ],
      ),
    );
  }

  void _showMultiSelect(BuildContext context) async {
    await showModalBottomSheet(
      isScrollControlled: true, // required for min/max child size
      context: context,
      builder: (ctx) {
        return MultiSelectBottomSheet(
          items: activities.map((e) => MultiSelectItem(e, e.name)).toList(),
          initialValue: _selectedActivities,
          onConfirm: (values) {
            _selectedActivities = values;
          },
          maxChildSize: 0.8,
        );
      },
    );
  }
}
