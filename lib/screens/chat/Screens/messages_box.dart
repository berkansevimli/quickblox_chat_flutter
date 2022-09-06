import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quickblox_chat_flutter/screens/chat/Screens/chat_screen.dart';
import 'package:quickblox_sdk/chat/constants.dart';
import 'package:quickblox_sdk/models/qb_dialog.dart';
import 'package:quickblox_sdk/models/qb_filter.dart';
import 'package:quickblox_sdk/models/qb_sort.dart';
import 'package:quickblox_sdk/models/qb_user.dart';
import 'package:quickblox_sdk/quickblox_sdk.dart';
import 'package:quickblox_sdk/users/constants.dart';

import '../../../../size_config.dart';
import '../../../../utils.dart';
import '../../../utils/dialog_utils.dart';

class MessagesBoxPage extends StatefulWidget {
  final int user;
  MessagesBoxPage({Key? key, required this.user}) : super(key: key);

  @override
  _MessagesBoxPageState createState() => _MessagesBoxPageState();
}

class _MessagesBoxPageState extends State<MessagesBoxPage> {
  List<QBDialog?> _dialogs = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDialogs();
  }

  void getDialogs() async {
    try {
      QBSort sort = QBSort();
      sort.field = QBChatDialogSorts.LAST_MESSAGE_DATE_SENT;
      sort.ascending = true;

      QBFilter filter = QBFilter();
      filter.field = QBChatDialogFilterFields.LAST_MESSAGE_DATE_SENT;
      filter.operator = QBChatDialogFilterOperators.ALL;

      filter.value = "";

      List<QBDialog?> dialogs = await QB.chat.getDialogs();
      setState(() {
        _dialogs = dialogs;
      });
      var dialogsLength = dialogs.length;
      // print(dialogs[0]!.userId);
      print("The $dialogsLength dialogs were loaded success");
    } on PlatformException catch (e) {
      DialogUtils.showError(context, e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Messages")),
      body: ListView.builder(
          itemCount: _dialogs.length,
          itemBuilder: ((context, index) {
            return ListTile(
              leading: CircleAvatar(
                backgroundImage: _dialogs[index]!.photo == null
                    ? const AssetImage("assets/icons/user.png") as ImageProvider
                    : NetworkImage(_dialogs[index]!.photo!),
              ),
              title: Text(_dialogs[index]!.name!),
              subtitle: Text(_dialogs[index]!.lastMessage!),
              trailing: Text(Utils.toTime(DateTime.fromMillisecondsSinceEpoch(
                  _dialogs[index]!.lastMessageDateSent!))),
              onTap: () async {
                print(widget.user);
                print(_dialogs[index]!.occupantsIds.toString());
                List<int?> ids = [];
                _dialogs[index]!.occupantsIds!.forEach((element) {
                  ids.add(element);
                });
                ids.remove(widget.user);

                QBFilter filter = QBFilter();
                filter.type = QBUsersFilterTypes.STRING;
                filter.field = QBUsersFilterFields.ID;
                filter.operator = QBUsersFilterOperators.EQ;
                filter.value = ids[0].toString();
                List<QBUser?> userList =
                    await QB.users.getUsers(filter: filter);
                int count = userList.length;
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (builder) => ChatPage(user: userList.first!)));
                print(count);
              },
            );
          })),
    );
  }
}
