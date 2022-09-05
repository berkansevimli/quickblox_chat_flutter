enum MessageStatus { not_sent, not_view, viewed }

class ChatMessage {
  final String text;
  final String messageType;
  final bool isSender;
  final String mediaUrl;
  final DateTime messageTime;

  ChatMessage({
    this.mediaUrl = "",
    required this.messageTime,
    required this.text,
    required this.messageType,
    required this.isSender,
  });
}

