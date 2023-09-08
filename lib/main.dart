import 'package:camera/camera.dart';
import 'package:camera_locate/page/camera/camera_page.dart';
import 'package:flutter/material.dart';

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
