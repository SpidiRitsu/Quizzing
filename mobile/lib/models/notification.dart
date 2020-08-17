import 'package:Quizzing/models/user.dart';
import 'package:flutter/foundation.dart';

class NotificationObject {
  final int id;
  final String content;
  final DateTime dateCreated;
  final int userId;
  final User receiver;

  NotificationObject({
    @required this.id,
    @required this.content,
    this.dateCreated,
    this.userId,
    this.receiver,
  });

  factory NotificationObject.fromApi(Map<String, dynamic> body) {
    return NotificationObject(
      id: body['id'],
      content: body['content'],
      dateCreated: body['dateCreated'] != null
          ? DateTime.parse(body['dateCreated'])
          : null,
      userId: body['userId'],
      receiver: body.containsKey('user') ? User.fromApi(body['user']) : null,
    );
  }
}
