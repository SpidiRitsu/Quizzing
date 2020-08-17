import 'package:Quizzing/models/quiz.dart';
import 'package:flutter/foundation.dart';

class Question {
  final int id;
  // final String question;
  // final String answer1;
  // final String answer2;
  // final String answer3;
  // final String answer4;
  // final String correctAnswer;
  String question;
  String answer1;
  String answer2;
  String answer3;
  String answer4;
  String correctAnswer;
  final int quizId;
  final Quiz quiz;

  Question({
    // @required this.id,
    this.id,
    @required this.question,
    this.answer1,
    this.answer2,
    this.answer3,
    this.answer4,
    @required this.correctAnswer,
    @required this.quizId,
    this.quiz,
  });

  factory Question.fromApi(Map<String, dynamic> body) {
    print(body);
    return Question(
      id: body['id'],
      question: body['question'],
      answer1: body['answer1'],
      answer2: body['answer2'],
      answer3: body['answer3'],
      answer4: body['answer4'],
      correctAnswer: body['correctAnswer'],
      quizId: body['quizId'],
      quiz: body.containsKey('quiz') ? Quiz.fromApi(body['quiz']) : null,
    );
  }
}
