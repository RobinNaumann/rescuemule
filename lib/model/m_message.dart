import 'dart:convert';

import 'package:flutter_chat_core/flutter_chat_core.dart';

class Message {
  final String sender;
  final String receiver;
  final String message;
  final DateTime creationTime;

  Message({
    required this.sender,
    required this.receiver,
    required this.message,
    required this.creationTime,
  });

  static Message createMessage({
    required sender,
    required receiver,
    required message,
  }) {
    DateTime time = DateTime.now();
    //int id = (sender+receiver+time.toString()).hashCode;
    return Message(
      sender: sender,
      receiver: receiver,
      message: message,
      creationTime: time,
    );
  }

  Map<String, dynamic> toJson() => {
    'sender': sender,
    'receiver': receiver,
    'message': message,
    'creationTime': creationTime.toString(),
  };

  factory Message.fromJson(Map<String, dynamic> json) => Message(
    sender: json['sender'],
    receiver: json['receiver'],
    message: json['message'],
    creationTime: DateTime.parse(json['creationTime']),
  );

  int get id => (sender + receiver + creationTime.toString()).hashCode;

  TextMessage toTextMessage() {
    return TextMessage(id: '$id', authorId: sender, text: message);
  }

  List<int> toBytes() {
    return utf8.encode(jsonEncode(toJson()));
  }
  
  factory Message.fromBytes(List<int> bytes) {
    String jsonString = utf8.decode(bytes);
    Map<String, dynamic> jsonMap = jsonDecode(jsonString);
    return Message.fromJson(jsonMap);
  }
}
