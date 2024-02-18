# Grocery Scanner

![](assets/svg/logo-white.svg)

Mobile app written in Flutter for scanning groceries in order to get detailed info about them.

App created as a part of engineering thesis at [Faculty of Mathematics and Computer Science](https://mat.umk.pl) in [Nicolaus Copernicus University in Toruń](https://www.umk.pl).

## Features

* 🍗 Product Barcode Scanner
* 📃 Displaying detailed info about scanned product
* 📌 Product Pinning
* ✏️ Product Creator & Editor
* 🥚 Personalizing your allergens & food preferences 
* 🌿 Getting info whether scanned product is good for you or not
* 🌐 Offline Mode

## Tech Stack

* [Flutter](https://flutter.dev) + [Dart](https://dart.dev)
* [Firebase](https://firebase.google.com)
  * *Authentication*
  * *Cloud Firestore*
  * *Storage*
* [Open Food Facts API](https://world.openfoodfacts.org)
* [DeepL API](https://www.deepl.com)
* [Hive Database for Flutter](https://github.com/isar/hive)

## Prerequisites

### Emulator
1. [Visual Studio Code](https://code.visualstudio.com)
2. [Android Debug Bridge (ADB)](https://developer.android.com/tools/adb) or [Android Studio](https://developer.android.com/studio)
3. Emulator Device with Android 13+

### Physical Device
1. Device with Android 13+
2. Enabled USB Debugging

### DeepL API Key

DeepL API Key is **required** for using the feature of product ingredients translation. In order to set this:

1. Create file `secrets.dart` in `/lib/auth` directory.
2. Add the following line in `secrets.dart` file:
```dart
var deepL_apiKey = <ENTER_YOUR_DEEPL_API_KEY_HERE>;
```

## Running Instruction

### Emulator / Physical Device
1. Open Project in VS Code
2. In the bottom right corner, click `No device` and select emulated / physical device
3. In `/lib/main.dart` file, press `F5` key or select `Run`.