import 'dart:async';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quickblox_chat_flutter/screens/call/video_call/video_call_setup.dart';
import 'package:quickblox_sdk/chat/constants.dart';
import 'package:quickblox_sdk/models/qb_filter.dart';
import 'package:quickblox_sdk/models/qb_message.dart';
import 'package:quickblox_sdk/models/qb_sort.dart';
import 'package:quickblox_sdk/models/qb_user.dart';
import 'package:quickblox_sdk/quickblox_sdk.dart';

import '../../../constants.dart';
import '../../../utils/dialog_utils.dart';
import '../../../utils/snackbar_utils.dart';
import '../Services/message_sender.dart';
import '../models/ChatMessage.dart';
import '../models/fetch_messages.dart';
import '../widgets/chat_header.dart';
import '../widgets/message.dart';

class ChatPage extends StatefulWidget {
  final QBUser user;
  String messageText;

  ChatPage({
    Key? key,
    this.messageText = "",
    required this.user,
  }) : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final List<String?> errors = [];
  final TextEditingController _messageController = TextEditingController();
  String? messageText;
  File? file;
  bool isRecorded = false;
  String dialogId = "";
  String? _messageId;

  List<ChatMessage?> messages = [];

  final sender = MessageSender();
  StreamSubscription? _newMessageSubscription;

  @override
  void initState() {
    super.initState();
    createDialog();

    _messageController.text = "";
    //sender.updateSeen(userID, widget.user.uid!);
  }

  void getMessages() async {
    QBSort sort = QBSort();
    sort.field = QBChatMessageSorts.DATE_SENT;
    sort.ascending = false;

    QBFilter filter = QBFilter();
    filter.field = QBChatMessageFilterFields.ID;
    filter.operator = QBChatMessageFilterOperators.IN;

    int limit = 100;
    int skip = 50;
    bool markAsRead = true;

    try {
      List<QBMessage?> result =
          await QB.chat.getDialogMessages(dialogId, sort: sort);
      print(result.last!.body!);
      List<ChatMessage> messagesList = [];
      result.forEach(
        (element) => messagesList.add(ChatMessage(
            messageTime: element!.dateSent!,
            text: element.body!,
            isSender: element.senderId != widget.user.id)),
      );
      setState(() {
        messages = messagesList;
      });
    } on PlatformException catch (e) {
      print(e);
      // Some error occurred, look at the exception message for more details
    }
  }

  void createDialog() async {
    final result = await sender.createDialog(
      widget.user.id!,
      context,
    );
    setState(() {
      dialogId = result;
    });
    getMessages();
    subscribeNewMessage();
  }

  void subscribeNewMessage() async {
    if (_newMessageSubscription != null) {
      SnackBarUtils.showResult(
          _scaffoldKey,
          "You already have a subscription for: " +
              QBChatEvents.RECEIVED_NEW_MESSAGE);
      return;
    }
    try {
      _newMessageSubscription = await QB.chat
          .subscribeChatEvent(QBChatEvents.RECEIVED_NEW_MESSAGE, (data) {
        Map<dynamic, dynamic> map = Map<dynamic, dynamic>.from(data);

        Map<dynamic, dynamic> payload =
            Map<dynamic, dynamic>.from(map["payload"]);

        _messageId = payload["id"] as String;

        SnackBarUtils.showResult(
            _scaffoldKey, "Received message: \n ${payload}");

        setState(() {
          messages.insert(
              0,
              ChatMessage(
                  messageTime: payload['dateSent'],
                  text: payload['body'],
                  isSender: payload['senderId'] != widget.user.id));
        });
      }, onErrorMethod: (error) {
        DialogUtils.showError(context, error);
      });
      SnackBarUtils.showResult(
          _scaffoldKey, "Subscribed: " + QBChatEvents.RECEIVED_NEW_MESSAGE);
    } on PlatformException catch (e) {
      DialogUtils.showError(context, e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: false,
          backgroundColor: Colors.black,
          title: Text(widget.user.fullName!),
          actions: [
            IconButton(
                onPressed: () {
                  QB.auth.getSession().then((value) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (builder) => VideoCallSetup(
                                OPPONENTS_IDS: [widget.user.id!],
                                LOGGED_USER_ID: value!.userId!)));
                  });
                },
                icon: Icon(Icons.video_call))
          ],
        ),
        body: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
                child: ListView.builder(
                    physics: BouncingScrollPhysics(),
                    reverse: true,
                    itemCount: messages.length,
                    itemBuilder: ((context, index) {
                      return Message(
                        message: messages[index]!,
                        userIMG: "default",
                      );
                    }))),
            Form(
              key: _formKey,
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.only(top: 8.0, left: 8),
                  child: Container(
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(12)),
                    width: double.infinity,
                    child: Row(
                      children: [
                        Expanded(child: buildMessageFormField()),
                        // IconButton(
                        //     onPressed: () {
                        //       showModalBottomSheet(
                        //           backgroundColor: kCardColor,
                        //           context: context,
                        //           builder: (BuildContext c) {
                        //             return buildBottomSheetMenu(context);
                        //           });
                        //     },
                        //     icon: Icon(Icons.attach_file)),
                        Padding(
                          padding: const EdgeInsets.only(right: 8.0, left: 4),
                          child: FloatingActionButton(
                              mini: true,
                              backgroundColor: kPrimaryColor,
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  _formKey.currentState!.save();
                                  _messageController.text = "";

                                  await sender.sendMessage(
                                      dialogId, context, messageText!);
                                  //getMessages();
                                  // await sender.sendMessage(
                                  //     context,
                                  //     widget.user.uid!,
                                  //     userID,
                                  //     messageText,
                                  //     widget.user.username!,
                                  //     widget.user.img!,
                                  //     "text",
                                  //     "default",
                                  //     widget.user.token!);
                                }
                              },
                              child: Icon(
                                CupertinoIcons.forward,
                                color: Colors.white,
                              )),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ));
  }

  TextFormField buildMessageFormField() {
    return TextFormField(
      textCapitalization: TextCapitalization.sentences,
      textInputAction: TextInputAction.done,
      maxLines: 4,
      minLines: 1,
      controller: _messageController,
      style: TextStyle(fontSize: 16),
      onSaved: (newValue) => messageText = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {}
        return null;
      },
      validator: (value) {
        if (value!.isEmpty) {
          return "Message field can not be empty!";
        }
        return null;
      },
      decoration: const InputDecoration(
        hintText: "Type message...",
        label: Text("Message"),
        hintStyle: TextStyle(fontSize: 16),
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
    );
  }
}

class FileMenuWidget extends StatelessWidget {
  final String text;
  final Function() onTap;
  final Icon icon;
  const FileMenuWidget({
    Key? key,
    required this.text,
    required this.onTap,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListTile(
          onTap: onTap,
          title: Text(
            text,
            style: TextStyle(color: kTextColor),
          ),
          leading: icon),
    );
  }
}
