// ignore_for_file: use_build_context_synchronously
import 'package:camera/camera.dart';
import 'package:camera_locate/page/camera/circular_progress_dialog.dart';
import 'package:camera_locate/page/camera/display_result_page.dart';
import 'package:camera_locate/util/utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

class CameraPage extends StatefulWidget {
  const CameraPage({super.key, required this.camera});
  final CameraDescription camera;
  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  CameraController? _controller;
  Future<void>? _initializeControllerFuture;
  String _watermarkText = '';
  double _lat = 0.0;
  double _long = 0.0;

  ///This function to get location from the devices
  ///latitude, longitude, from this data we can extract the address information
  Future<void> getLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      List<Placemark> placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);

      if (placemarks.isNotEmpty) {
        Placemark placemark = placemarks[0];
        String fullAddress = placemark.street ?? '';
        String postalCode = placemark.postalCode ?? '';
        String city = placemark.locality ?? '';
        String subAdministrativeArea = placemark.subAdministrativeArea ?? '';
        String administrativeArea = placemark.administrativeArea ?? '';
        String country = placemark.country ?? '';
        setState(
          () {
            _watermarkText =
                '$fullAddress, $postalCode, $city, $subAdministrativeArea, $administrativeArea, $country';
            _lat = position.latitude;
            _long = position.longitude;
          },
        );
      }
    } catch (e) {
      ///DEBUG ERROR
      if (kDebugMode) {
        print(e);
      }
    }
  }

  ///
  /// START : UNUSED FUNCTION
  ///
  // Future<File> copyAssetToFile(String assetPath) async {
  //   final ByteData data = await rootBundle.load(assetPath);
  //   final List<int> bytes = data.buffer.asUint8List();
  //   final Directory tempDir = await getTemporaryDirectory();
  //   final File tempFile = File('${tempDir.path}/temp_image.png');
  //   await tempFile.writeAsBytes(bytes, flush: true);
  //   return tempFile;
  // }

  // Future<void> addWaterMark(String imagePath) async {
  //   try {
  //     final File imageFile = File(imagePath);
  //     if (!imageFile.existsSync()) {
  //       // Handle if the image file doesn't exist
  //       return;
  //     }
  //     // Load the image
  //     final img.Image? image = img.decodeImage(imageFile.readAsBytesSync());
  //     if (image == null) {
  //       // Handle if the image cannot be decoded
  //       return;
  //     }
  //     var time = DateFormat('yyyy/dd/MM HH:ss').format(
  //       DateTime.now(),
  //     );
  //     // Read a jpeg image from file.
  //     var file = await copyAssetToFile('assets/image/logo.png');
  //     final srcImage = img.decodeJpg(file.readAsBytesSync());
  //     // Calculate the Y position for the watermark below the image
  //     int watermarkY = image.height; // Adjust the offset as needed
  //     img.compositeImage(
  //       image,
  //       srcImage!,
  //       dstW: 150,
  //       dstH: 150,
  //       dstX: 10,
  //       dstY: watermarkY - 200, // Adjust the offset as needed
  //     );
  //     img.drawString(
  //       image,
  //       'Lat $_lat, Long $_long',
  //       font: img.arial24,
  //       x: 200,
  //       y: watermarkY - 200,
  //       wrap: true,
  //     );
  //     img.drawString(
  //       image,
  //       _watermarkText,
  //       font: img.arial24,
  //       x: 200,
  //       maskChannel: img.Channel.green,
  //       y: watermarkY - 160, // Add vertical spacing between watermark elements
  //     );
  //     img.drawString(
  //       image,
  //       time,
  //       font: img.arial24,
  //       x: 200,
  //       y: watermarkY - 110, // Add vertical spacing between watermark elements
  //       wrap: true,
  //     );

  //     // Get the path to the internal storage
  //     final Directory? outputDir = await getExternalStorageDirectory();
  //     final String dir = outputDir?.path ?? '/storage/emulated/0';
  //     // Define a new path for the image with watermark in internal storage
  //     var filename = "${DateFormat("yyyyMMddHHss").format(DateTime.now())}.jpg";
  //     final String newImagePath = '$dir/$filename';
  //     // Save the image with watermark to internal storage
  //     File(newImagePath).writeAsBytesSync(img.encodePng(image));
  //     if (!mounted) return;
  //     await Navigator.of(context).push(
  //       MaterialPageRoute(
  //         builder: (context) => DisplayResultPage(
  //           imagePath: newImagePath,
  //         ),
  //       ),
  //     );
  //   } catch (e) {
  //     rethrow;
  //   }
  // }

  // ///
  // /// END : UNUSED FUNCTION
  // ///

  ///This function to take a picture from camera
  Future<void> takePicture() async {
    try {
      if (_controller != null) {
        if (!_controller!.value.isTakingPicture) {
          showDialog(
            context: context,
            builder: (context) => const CircularProgressDialog(),
          );

          /// var picture = await _controller!.takePicture();
          ///save the image to the storage or do something else
          _controller!.takePicture().then(
            (value) {
              Navigator.pop(context);
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => DisplayResultPage(
                    imagePath: value.path,
                    lat: _lat,
                    long: _long,
                    watermark: _watermarkText,
                  ),
                ),
              );
            },
          );
        }
      }
    } catch (e) {
      ///DEBUG ERROR
      if (kDebugMode) {
        print(e);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    checkPermission(
      Permission.location,
      (granted) {
        if (granted) {
          getLocation();
        }
      },
    );

    ///To display the current output from the camera
    ///Create a CameraController
    _controller = CameraController(
      widget.camera,
      //define the resolution to use
      ResolutionPreset.high,
      imageFormatGroup: ImageFormatGroup.jpeg,
    );
    // Initialize the controller. This returns a Future
    _initializeControllerFuture = _controller?.initialize();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Stack(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: CameraPreview(
                    _controller!,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    top: 50,
                    left: 50,
                  ),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      "Lat $_lat˚\nLong $_long˚\n$_watermarkText",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(
                      bottom: 16,
                    ),
                    child: FloatingActionButton(
                      child: const Icon(Icons.camera_alt),
                      onPressed: () async {
                        try {
                          // Ensure that the camera is initialized.
                          await _initializeControllerFuture;
                          // Attempt to take a picture and then get the location
                          // where the image file is saved.
                          checkPermission(
                            Permission.storage,
                            (granted) {
                              takePicture();
                            },
                          );
                        } catch (e) {
                          // If an error occurs, log the error to the console.
                        }
                      },
                    ),
                  ),
                ),
              ],
            );
          } else {
            // Otherwise, display a loading indicator
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
