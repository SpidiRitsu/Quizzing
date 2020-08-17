import 'package:Quizzing/models/message.dart';
import 'package:Quizzing/models/user.dart';
import 'package:flutter/foundation.dart';

class UserMessage {
  final User sender;
  final List<Message> messages;
  final String lastMessage;

  UserMessage({
    @required this.sender,
    @required this.messages,
    @required this.lastMessage,
  });
}
