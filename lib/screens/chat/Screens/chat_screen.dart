import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quickblox_sdk/models/qb_user.dart';

import '../../../constants.dart';
import '../Services/message_sender.dart';
import '../models/fetch_messages.dart';
import '../widgets/chat_header.dart';

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
  final List<String?> errors = [];
  final TextEditingController _messageController = TextEditingController();
  String? messageText;
  File? file;
  bool isRecorded = false;

  final sender = MessageSender();

  @override
  void initState() {
    super.initState();

    _messageController.text = "";
    //sender.updateSeen(userID, widget.user.uid!);
  }

  void addError({String? error}) {
    if (!errors.contains(error))
      setState(() {
        errors.add(error);
      });
  }

  void removeError({String? error}) {
    if (errors.contains(error))
      setState(() {
        errors.remove(error);
      });
  }

  @override
  Widget build(BuildContext context) {
    //final Map blocks = widget.user.blocks!;
    //print(blocks);
    return Scaffold(
        appBar: AppBar(
          leading: BackButton(
            onPressed: () => Navigator.pop(context),
          ),
          automaticallyImplyLeading: false,
          elevation: 0.5,
          shadowColor: Theme.of(context).primaryColor,
          title: ChatHeaderWidget(
            widget: widget,
            buildContext: context,
          ),
        ),
        body: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: FetchMessages(
                receiverID: widget.user.login!,
                userIMG: widget.user.customData!,
              ),
            ),
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
        if (value.isNotEmpty) {
          removeError(error: "Message feel can not be empty!");
        }
        return null;
      },
      validator: (value) {
        if (value!.isEmpty) {
          addError(error: "Message feel can not be empty!");
          return "";
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