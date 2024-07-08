class Message {
  final int fromUser;
  final int toUser;
  final String message;

  Message(
      {required this.fromUser, required this.toUser, required this.message});

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      fromUser: json['from_user'],
      toUser: json['to_user'],
      message: json['message'],
    );
  }
}
