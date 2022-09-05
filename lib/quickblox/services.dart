import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quickblox_chat_flutter/quickblox/setup.dart';
import 'package:quickblox_chat_flutter/screens/auth/signin.dart';
import 'package:quickblox_chat_flutter/screens/auth/wrapper.dart';
import 'package:quickblox_chat_flutter/screens/home_screens/users_screen.dart';
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
      BuildContext context, String username, String password) async {
    print("started login");
    try {
      QBLoginResult result = await QB.auth.login(username, password);

      QBUser? qbUser = result.qbUser;
      QBSession? qbSession = result.qbSession;

      qbSession!.applicationId = int.parse(appId);

      DataHolder.getInstance().setSession(qbSession);
      DataHolder.getInstance().setUser(qbUser);
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (builder) => UsersScreen()),
          (route) => false);
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
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (builder) => SignInScreen()),
          (route) => false);
    } on PlatformException catch (e) {
      DialogUtils.showError(context, e);
    }
  }

  ////////////////////////////
  ///Get User
  static Future<List<QBUser?>> getUsers() async {
    try {
      List<QBUser?> userList = await QB.users.getUsers();
      int count = userList.length;
      print("Users were loaded. Count is: $count");
      return userList;
    } on PlatformException catch (e) {
      print(e);
      return [];
    }
  }
}
