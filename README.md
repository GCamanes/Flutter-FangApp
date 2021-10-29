# FangApp

A flutter app to read mangas.
Back managed with Python3 and Firebase.

## Getting Started

### Flutter/ DART
1) add configuration for main.dart

2) Android Studio => preferences => Languages and Frameworks => Dart
   => specify Dart path (ex: /Users/you/development/flutter/bin/cache/dart-sdk)
   => enable it for the project
   
### Python3
1) Android Studio => Tools => Sync Python Requirements...

2) Select Python3 module

### Firebase

#### Install
1) Get the google-services.json from Firebase console and put it into
   'android/app/'

2) Get the GoogleService-Info.plist from Firebase console and put it into
   'ios/Runner/'
   
2.1) The one for prod should be renamed as GoogleService-Info-prod.plist
2.2) The one for dev should be renamed as GoogleService-Info-dev.plist
   
3) Open python file python/back_manager.py and follow SETUP instruction

#### Debug view android

1) Install homebrew if not already installed
```
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
```

2) Install android tools
```
brew install android-platform-tools
```

3) Connect real android device to mac and flutter run on it

4) Link with adb
```
adb -d shell setprop debug.firebase.analytics.app com.groupany.fangapp
```

### Android signing

```
/Applications/Android\ Studio.app/Contents/jre/Contents/Home/bin/keytool -genkeypair -v -keyalg RSA -keysize 2048 -validity 10000 -keystore YOUR_KS.keystore -storepass KS_PASSWORD -alias ALIAS
```

you can find your java path with the command

```
flutter doctor -v
```

### Flavors

The project has two flavors : dev and prod

Create two configurations in Android Studio
Select main.dart as entry endpoint and add
```
--flavor dev/prod
```
in additional run args