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
    String type = message!.messageType;

    return Padding(
      padding: EdgeInsets.only(right: isSender ? 8.0 : 0.0),
      child: Container(
        constraints: BoxConstraints(maxWidth: SizeConfig.screenWidth / 1.5),
        padding: EdgeInsets.only(
          left: type == "text" ? kDefaultPadding * 0.75 : 0,
          right: type == "text" ? kDefaultPadding * 0.75 : 0,
          top: type == "text" ? kDefaultPadding / 2 : 0,
        ),
        decoration: BoxDecoration(
          color: isSender
              ? Theme.of(context).highlightColor
              : Theme.of(context).canvasColor,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12),
              topRight: Radius.circular(12),
              bottomLeft: isSender ? Radius.circular(12) : Radius.circular(0),
              bottomRight: isSender ? Radius.circular(0) : Radius.circular(12)),
        ),
        child: Column(
          crossAxisAlignment:
              isSender ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Text(
              message!.text,
              style: TextStyle(
                color: Theme.of(context).textTheme.bodyText1!.color,
              ),
            ),
            Padding(
              padding: type == "text" ? EdgeInsets.all(4.0) : EdgeInsets.all(8),
              child: Text(
                Utils.toTime(message!.messageTime),
                style: isSender
                    ? TextStyle(
                        fontSize: 10,
                      )
                    : TextStyle(
                        fontSize: 10,
                      ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
