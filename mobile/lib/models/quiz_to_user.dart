import 'package:flutter/foundation.dart';

import 'quiz.dart';
import 'user.dart';

class QuizToUser {
  final DateTime dateAttached;
  final int quizId;
  final int userId;
  final Quiz quiz;
  final User user;

  QuizToUser({
    @required this.dateAttached,
    @required this.quizId,
    @required this.userId,
    this.quiz,
    this.user,
  });

  factory QuizToUser.fromApi(Map<String, dynamic> body) {
    return QuizToUser(
      dateAttached: body['dateAttached'] != null
          ? DateTime.parse(body['dateAttached'])
          : null,
      quizId: body['quizId'],
      userId: body['userId'],
      quiz: body.containsKey('quiz') ? Quiz.fromApi(body['quiz']) : null,
      user: body.containsKey('user') ? User.fromApi(body['user']) : null,
    );
  }
}
