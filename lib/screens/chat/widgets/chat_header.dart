import 'package:flutter/material.dart';

import '../Screens/chat_screen.dart';

class ChatHeaderWidget extends StatelessWidget {
  const ChatHeaderWidget({
    Key? key,
    required this.widget,
    required this.buildContext,
  }) : super(key: key);

  final ChatPage widget;
  final BuildContext buildContext;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            SizedBox(height: 32, width: 32, child: Container()),
            SizedBox(width: 15),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.user.login!,
                  style: TextStyle(fontSize: 16),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
