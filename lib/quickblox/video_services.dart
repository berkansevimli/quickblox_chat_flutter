import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quickblox_sdk/quickblox_sdk.dart';

import '../utils/dialog_utils.dart';
import '../utils/snackbar_utils.dart';

class VideoServices {
  static Future<void> init(
      GlobalKey<ScaffoldState> _scaffoldKey, BuildContext context) async {
    try {
      await QB.webrtc.init();
      SnackBarUtils.showResult(_scaffoldKey, "WebRTC was initiated");
    } on PlatformException catch (e) {
      DialogUtils.showError(context, e);
    }
  }

  static Future<void> releaseWebRTC(
      GlobalKey<ScaffoldState> _scaffoldKey, BuildContext context) async {
    try {
      await QB.webrtc.release();
      SnackBarUtils.showResult(_scaffoldKey, "WebRTC was released");
    } on PlatformException catch (e) {
      DialogUtils.showError(context, e);
    }
  }
}
