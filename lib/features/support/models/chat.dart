class Chat {
  final String id;
  final String contactName;
  final String lastMessage;
  final DateTime lastMessageTime;
  final String avatarUrl;
  final String priority;
  final String status;

  Chat({
    required this.id,
    required this.contactName,
    required this.lastMessage,
    required this.lastMessageTime,
    required this.avatarUrl,
    required this.priority,
    required this.status,
  });
}