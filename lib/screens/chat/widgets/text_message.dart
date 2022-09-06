import 'package:flutter/material.dart';

import '../../../constants.dart';
import '../../../size_config.dart';
import '../../../utils.dart';
import '../models/ChatMessage.dart';

class TextMessage extends StatelessWidget {
  const TextMessage({
    Key? key,
    this.message,
  }) : super(key: key);

  final ChatMessage? message;

  @override
  Widget build(BuildContext context) {
    bool isSender = message!.isSender;

    return Padding(
      padding: EdgeInsets.only(right: isSender ? 8.0 : 0.0),
      child: Container(
        constraints: BoxConstraints(maxWidth: SizeConfig.screenWidth / 1.5),
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isSender ? Colors.black : Colors.red,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
              bottomLeft: isSender ? Radius.circular(24) : Radius.circular(0),
              bottomRight: isSender ? Radius.circular(0) : Radius.circular(24)),
        ),
        child: Column(
          crossAxisAlignment:
              isSender ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Text(
                message!.text,
                style: TextStyle(color: Colors.white),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 8),
              child: Text(
                Utils.toTime(
                    DateTime.fromMillisecondsSinceEpoch(message!.messageTime)),
                style: isSender
                    ? TextStyle(
                        fontSize: 10, color: Colors.white.withOpacity(0.8))
                    : TextStyle(
                        fontSize: 10, color: Colors.white.withOpacity(0.8)),
              ),
            )
          ],
        ),
      ),
    );
  }
}
