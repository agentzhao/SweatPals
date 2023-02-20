# SweatPals

### Setup Environment

- Make sure you have [flutter](https://docs.flutter.dev/get-started/install) installed
- Use an [emulator](https://developer.android.com/studio/index.html#command-tools) or mirror your android phone using [scrcpy](https://github.com/Genymobile/scrcpy)

```
git clone https://github.com/agentzhao/SweatPals.git
flutter pub get
```

Create project on firebase and use [flutterfire](https://firebase.flutter.dev/docs/cli/) to generate `firebase_options.dart`

### Todo

- [ ] Favicons and splash screen

### Building for production

```
flutter build web
firebase deploy
```

### Research

- https://pub.dev/packages/location/
- https://pub.dev/packages/geolocator/
- https://pub.dev/packages/swipeable_card_stack

### Resources

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)
- [Flutter Docs](https://docs.flutter.dev/)
