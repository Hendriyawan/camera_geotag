#CAMERA GEOTAG

Flutter Camera Geotag, use RepaintBoundary to save Image file to storage


* setup camera, permission_handler, google_fonts, geolocator, geocoding  plugin to your project, ```flutter pub add camera permission_handler google_fonts geolocator geocoding```
## ANDROID SETUP
* change minSdkVersion to 21
*  add this permission to your AndroidManifest.xml
```dart
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION"/>
```
```dart
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" />
```

## iOS SETUP
* go to Info.plist
add this line
```dart
<key>NSCameraUsageDescription</key>
<string>Application need permission to camera</string>
```
```dart
<key>NSMicrophoneUsageDescription</key>
<string>Application need permission to microphone</string>
```
```dart
<key>NSLocationWhenInUseUsageDescription</key>
<string>Need location to camera location</string>
```

## CODE
* in main.dart
call this line before ```runApp(MyApp...)```
```dart
WidgetsFlutterBinding.ensureInitialized();
// Obtain a list of the available cameras on the device
  final cameras = await availableCameras();

  //Get a specific camera from the list of available cameras
  final firstCamera = cameras.first;
```

here is my complete code for main.dart
```dart
void main() async {
  ///Ensure that plugin services are initialized so that availableCameras()
  ///can be called before runApp()
  WidgetsFlutterBinding.ensureInitialized();

  // Obtain a list of the available cameras on the device
  final cameras = await availableCameras();

  //Get a specific camera from the list of available cameras
  final firstCamera = cameras.first;
  runApp(MyApp(firstCamera));
}

class MyApp extends StatelessWidget {
  final CameraDescription camera;
  const MyApp(this.camera, {super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Camera Location',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: CameraPage(camera: camera),
    );
  }
}
```

* You can see more implementation code examples in the lib folder of this project, good luck

<img src="https://raw.githubusercontent.com/Hendriyawan/camera_geotag/master/ss1.jpg" width="360"/>
<img src="https://raw.githubusercontent.com/Hendriyawan/camera_geotag/master/ss2.jpg" width="360"/>
