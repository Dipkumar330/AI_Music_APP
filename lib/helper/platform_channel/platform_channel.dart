import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../utils/app_logger.dart';

class PlatformChannel {
  final MethodChannel _platform = const MethodChannel("com.dr_mechanix.dr_mechanix");

  Future<bool> checkForPermission(Permission permission) async {
    if (Platform.isIOS) {
      bool result = await _checkContactPermissionForIOS(permission);
      return result;
    } else if (Platform.isAndroid) {
      bool result = await _checkContactPermissionForAndroid(permission);
      return result;
    } else {
      return false;
    }
  }

  Future<bool> _checkContactPermissionForIOS(Permission permission) async {
    PermissionStatus permissionStatus = await permission.status;
    Logger().v(" PermissionStatus :: ${permissionStatus.toString()}");
    if (permissionStatus == PermissionStatus.granted) {
      return true;
    } else if (permissionStatus == PermissionStatus.denied) {
      Logger().v("PermissionGroup :: $permission");
      PermissionStatus status = await permission.request();
      return status == PermissionStatus.granted;
    } else if (permissionStatus == PermissionStatus.permanentlyDenied) {
      Logger().v("PermissionGroup :: $permission");
      openSettings();
      return false;
    } else {
      return false;
    }
  }

  Future<bool> _checkContactPermissionForAndroid(Permission permission) async {
    PermissionStatus permissionStatus = await permission.status;
    Logger().v(" PermissionStatus :: ${permissionStatus.toString()}");

    if (Platform.isAndroid) {
      final androidInfo = await DeviceInfoPlugin().androidInfo;
      final sdkInt = androidInfo.version.sdkInt;
      if (sdkInt < 33 && (permission == Permission.storage || permission == Permission.camera)) {
        return true;
      }
    }

    if (permissionStatus == PermissionStatus.granted) {
      return true;
    } else if (permissionStatus == PermissionStatus.denied) {
      PermissionStatus pStatus = await permission.request();
      Logger().v(" PermissionStatus :: ${pStatus.toString()}");
      if (pStatus == PermissionStatus.granted) {
        return true;
      } else if (pStatus == PermissionStatus.permanentlyDenied) {
        return false;
      } else if (pStatus == PermissionStatus.denied) {
        return false;
      } else {
        bool status = await _checkContactPermissionForNeverAsk(permission);
        return status;
      }
    } else if (permissionStatus == PermissionStatus.permanentlyDenied) {
      return false;
    }
    return false;
  }

  Future<bool> _checkContactPermissionForNeverAsk(Permission permission) async {
    Logger().v("_check Persmission For NeverAsk");
    PermissionStatus permissionStatus = await permission.request();
    Logger().v(" PermissionStatus :: ${permissionStatus.toString()}");
    if (permissionStatus == PermissionStatus.granted) {
      return true;
    } else if (permissionStatus == PermissionStatus.permanentlyDenied) {
      return false;
    } else if (permissionStatus == PermissionStatus.denied) {
      return false;
    } else {
      bool status = await _checkContactPermissionForNeverAsk(permission);
      return status;
    }
  }

  Future<bool> openSettings() async {
    bool isOpened = await openAppSettings();
    return isOpened;
  }

  Future<dynamic> openAppleMaps({
    String? sourceLat,
    String? sourceLong,
    String? destLat,
    String? destLong,
  }) async {
    try {
      final result = await _platform.invokeMethod('apple_map', {
        "sourceLat": sourceLat,
        "sourceLong": sourceLong,
        "destLat": destLat,
        "destLong": destLong,
      });
      return result;
    } on PlatformException catch (e) {
      Logger().e("Exception :: ${e.message}");
      return 568.0;
    }
  }
}
