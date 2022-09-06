import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quickblox_chat_flutter/screens/chat/models/ChatMessage.dart';
import 'package:quickblox_chat_flutter/screens/chat/widgets/message.dart';
import 'package:quickblox_sdk/chat/constants.dart';
import 'package:quickblox_sdk/models/qb_filter.dart';
import 'package:quickblox_sdk/models/qb_message.dart';
import 'package:quickblox_sdk/models/qb_sort.dart';
import 'package:quickblox_sdk/quickblox_sdk.dart';

import '../../../../constants.dart';
import '../../../../size_config.dart';
import '../../../../utils.dart';

class FetchMessages extends StatefulWidget {
  final String dialogId;
  final int userId;

  const FetchMessages({Key? key, required this.dialogId, required this.userId})
      : super(key: key);
  @override
  _FetchMessagesState createState() => _FetchMessagesState();
}

class _FetchMessagesState extends State<FetchMessages> {
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView();
  }
}
