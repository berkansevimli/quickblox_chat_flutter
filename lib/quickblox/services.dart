import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quickblox_chat_flutter/quickblox/setup.dart';
import 'package:quickblox_chat_flutter/screens/auth/wrapper.dart';
import 'package:quickblox_sdk/auth/module.dart';
import 'package:quickblox_sdk/models/qb_session.dart';
import 'package:quickblox_sdk/models/qb_user.dart';
import 'package:quickblox_sdk/quickblox_sdk.dart';

import '../data_holder.dart';
import '../utils/dialog_utils.dart';
import '../utils/snackbar_utils.dart';

class QuickbloxServices {
  ///////////////////// auth ///////////////////////////////////
  ///login
  static Future<bool> login(GlobalKey<ScaffoldState> scaffoldKey,
      String username, String password) async {
    print("started login");
    try {
      QBLoginResult result = await QB.auth.login(username, password);

      QBUser? qbUser = result.qbUser;
      QBSession? qbSession = result.qbSession;

      qbSession!.applicationId = int.parse(appId);

      DataHolder.getInstance().setSession(qbSession);
      DataHolder.getInstance().setUser(qbUser);

      SnackBarUtils.showResult(scaffoldKey, "Login success");
      return true;
    } on PlatformException catch (e) {
      print("error: $e");
      //DialogUtils.showError(context, e);
      return false;
    }
  }

  ///Logout
  static Future<void> logout(
    BuildContext context,
    GlobalKey<ScaffoldState> scaffoldKey,
  ) async {
    try {
      await QB.auth.logout();
      SnackBarUtils.showResult(scaffoldKey, "Logout success");
      Navigator.pushAndRemoveUntil(context,
          MaterialPageRoute(builder: (builder) => Wrapper()), (route) => false);
    } on PlatformException catch (e) {
      DialogUtils.showError(context, e);
    }
  }
}
