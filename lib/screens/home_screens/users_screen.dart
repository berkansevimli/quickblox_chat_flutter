import 'package:flutter/material.dart';
import 'package:quickblox_chat_flutter/quickblox/services.dart';
import 'package:quickblox_sdk/models/qb_user.dart';

class UsersScreen extends StatefulWidget {
  const UsersScreen({Key? key}) : super(key: key);

  @override
  State<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<QBUser?> userList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUsers();
  }

  void getUsers() async {
    final result = await QuickbloxServices.getUsers();

    setState(() {
      userList = result.toList();
    });
  }

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
        body: ListView.builder(
            itemCount: userList.length,
            itemBuilder: ((context, index) {
              return ListTile(
                title: Text(userList[index]!.login!),
              );
            })));
  }
}
