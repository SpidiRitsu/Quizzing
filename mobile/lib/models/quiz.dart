import 'package:Quizzing/models/user.dart';
import 'package:Quizzing/models/user.dart';
import 'package:flutter/foundation.dart';

class Quiz {
  final int id;
  final String quizName;
  final String accessCode;
  final DateTime dateCreated;
  final bool isActive;
  final int quizOwner;
  final User owner;

  Quiz({
    @required this.id,
    @required this.quizName,
    @required this.accessCode,
    this.dateCreated,
    @required this.isActive,
    @required this.quizOwner,
    this.owner,
  });

  factory Quiz.fromApi(Map<String, dynamic> body) {
    print(body);
    return Quiz(
      id: body['id'],
      quizName: body['quizName'],
      accessCode: body['accessCode'],
      dateCreated: body['dateCreated'] != null
          ? DateTime.parse(body['dateCreated'])
          : null,
      isActive: body['isActive'] == 1 ? true : false,
      quizOwner: body['quizOwner'],
      owner: body.containsKey('owner') ? User.fromApi(body['owner']) : null,
    );
  }
}
