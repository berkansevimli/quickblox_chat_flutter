import 'package:flutter/material.dart';
import 'package:quickblox_chat_flutter/quickblox/services.dart';
import 'package:quickblox_chat_flutter/screens/chat/Screens/chat_screen.dart';
import 'package:quickblox_chat_flutter/screens/chat/Screens/messages_box.dart';
import 'package:quickblox_sdk/models/qb_session.dart';
import 'package:quickblox_sdk/models/qb_user.dart';
import 'package:quickblox_sdk/quickblox_sdk.dart';

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
          leading: IconButton(
            icon: Icon(Icons.message),
            onPressed: () {
              QB.auth.getSession().then((value) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => MessagesBoxPage(
                              user: value!.userId!,
                            )));
              });
            },
          ),
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
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (builder) =>
                              ChatPage(user: userList[index]!)));
                },
              );
            })));
  }
}
