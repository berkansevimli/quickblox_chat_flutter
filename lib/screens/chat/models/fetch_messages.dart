import 'package:flutter/material.dart';
import 'package:quickblox_chat_flutter/screens/chat/models/ChatMessage.dart';
import 'package:quickblox_chat_flutter/screens/chat/widgets/message.dart';

import '../../../../constants.dart';
import '../../../../size_config.dart';
import '../../../../utils.dart';

class FetchMessages extends StatefulWidget {
  final String receiverID;
  final String userIMG;

  const FetchMessages(
      {Key? key, required this.receiverID, required this.userIMG})
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
    return ListView(

        // physics: BouncingScrollPhysics(),
        // reverse: true,
        // children: snapshot.data!.docs.map((DocumentSnapshot document) {
        //   Map<String, dynamic> data =
        //       document.data()! as Map<String, dynamic>;

        //   bool isSender = data['from'] == userID;
        //   String type = data['type'];
        //   String mediaURL = data['media'];

        //   ChatMessage message = ChatMessage(
        //       text: data['message'],
        //       messageType: type,
        //       isSender: isSender,
        //       mediaUrl: data['media'],
        //       messageTime: data['time'].toDate()
        //       );

        //   return Message(
        //     message: message,
        //     userIMG: widget.userIMG,
        //   );
        // })

        );
  }
}
