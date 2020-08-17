import 'package:Quizzing/models/user.dart';
import 'package:flutter/foundation.dart';

class Message {
  final int id;
  final String message;
  final DateTime dateSent;
  final int fromUser;
  final int toUser;
  final User sender;
  final User receiver;

  Message({
    @required this.id,
    @required this.message,
    @required this.dateSent,
    @required this.fromUser,
    @required this.toUser,
    this.sender,
    this.receiver,
  });

  factory Message.fromApi(Map<String, dynamic> body) {
    return Message(
      id: body['id'],
      message: body['message'],
      dateSent:
          body['dateSent'] != null ? DateTime.parse(body['dateSent']) : null,
      fromUser: body['fromUser'],
      toUser: body['toUser'],
      sender: body.containsKey('sender') ? User.fromApi(body['sender']) : null,
      receiver:
          body.containsKey('receiver') ? User.fromApi(body['receiver']) : null,
    );
  }
}
