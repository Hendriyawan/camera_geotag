import 'dart:io';
import 'package:permission_handler/permission_handler.dart';

/// This function to check permission
Future<void> checkPermission(
    Permission permission, Function(bool) onGranted) async {
  if (Platform.isIOS) {
    // if (await Permission.location.serviceStatus.isEnabled) {
    //   ///permission is enabled
    //   var status = await permission.request();
    //   if (status.isGranted) {
    //     onGranted(true);
    //   } else if (status.isDenied) {
    //     onGranted(false);
    //   } else if (await permission.isPermanentlyDenied) {
    //     openAppSettings();
    //   }
    // }
    Map<Permission, PermissionStatus> statuses = await [
      Permission.location,
    ].request();
    if (statuses[Permission.location] == PermissionStatus.granted) {
      onGranted(true);
    } else {
      onGranted(false);
    }
  } else {
    var permissionStatus = await permission.request();
    if (permissionStatus.isGranted) {
      onGranted(true);
    } else {
      onGranted(false);
    }
  }
}
