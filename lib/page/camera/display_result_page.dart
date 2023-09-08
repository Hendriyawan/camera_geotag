import 'dart:io';
import 'dart:typed_data';
import 'package:camera_locate/page/camera/custom_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:ui' as ui;

class DisplayResultPage extends StatefulWidget {
  final String imagePath;
  final double lat;
  final double long;
  final String watermark;
  const DisplayResultPage({
    super.key,
    required this.imagePath,
    this.lat = 0.0,
    this.long = 0.0,
    this.watermark = '',
  });

  @override
  State<DisplayResultPage> createState() => _DisplayResultPageState();
}

class _DisplayResultPageState extends State<DisplayResultPage> {
  final GlobalKey _globalKey = GlobalKey();

  ///SAVE THE FILE
  Future<void> savePicture() async {
    final Directory? outputDir = await getExternalStorageDirectory();
    final String dir = outputDir?.path ?? '/storage/emulated/0';
    var filename =
        "$dir/${DateFormat("yyyyddMMHHmmss").format(DateTime.now())}.jpg";
    RenderRepaintBoundary boundary =
        _globalKey.currentContext?.findRenderObject() as RenderRepaintBoundary;
    ui.Image image = await boundary.toImage();
    ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    if (byteData != null) {
      Uint8List pngBytes = byteData.buffer.asUint8List();
      File(filename).writeAsBytesSync(pngBytes);
      // ignore: use_build_context_synchronously
      showMessage(context, Colors.green, "Berhasil disimpan !");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        actions: [
          TextButton(
            onPressed: () {
              savePicture();
            },
            child: const Text(
              "Simpan",
              style: TextStyle(
                color: Colors.black,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      body: RepaintBoundary(
        key: _globalKey,
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: [
              Image.file(
                File(
                  widget.imagePath,
                ),
              ),
              Positioned(
                bottom: 1,
                left: 1,
                right: 1,
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 16,
                    right: 16,
                    bottom: 32,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(
                        "assets/image/logo.png",
                        width: 60,
                        height: 60,
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Lat ${widget.lat}˚ Long ${widget.long}˚\n${widget.watermark}',
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                DateFormat('yyyy/MM/dd HH:mm:ss')
                                    .format(DateTime.now()),
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
