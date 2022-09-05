import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quickblox_chat_flutter/screens/auth/signin.dart';
import 'package:quickblox_chat_flutter/screens/home_screens/users_screen.dart';
import 'package:quickblox_sdk/models/qb_session.dart';
import 'package:quickblox_sdk/quickblox_sdk.dart';

class Wrapper extends StatefulWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  State<Wrapper> createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkUser();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }

  checkUser() async {
    try {
      QBSession? session = await QB.auth.getSession();
      print("session result: ${session?.userId} ");
      if (session != null) {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (builder) => UsersScreen()),
            (route) => false);
      } else {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (builder) => SignInScreen()),
            (route) => false);
      }
    } on PlatformException catch (e) {
      // Some error occurred, look at the exception message for more details
    }
  }
}
