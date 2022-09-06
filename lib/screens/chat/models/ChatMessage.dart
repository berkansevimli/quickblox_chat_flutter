enum MessageStatus { not_sent, not_view, viewed }

class ChatMessage {
  final String text;
  final bool isSender;
  final String mediaUrl;
  final int messageTime;

  ChatMessage({
    this.mediaUrl = "",
    required this.messageTime,
    required this.text,
    required this.isSender,
  });
}
