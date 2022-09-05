import 'package:flutter/material.dart';
import 'package:quickblox_chat_flutter/quickblox/services.dart';

class UsersScreen extends StatefulWidget {
  const UsersScreen({Key? key}) : super(key: key);

  @override
  State<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("All Users"),
        actions: [
          IconButton(
              onPressed: () {
                QuickbloxServices.logout(context, _scaffoldKey);
              },
              icon: Icon(Icons.logout))
        ],
      ),
    );
  }
}
