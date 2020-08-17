import 'package:Quizzing/models/question.dart';
import 'package:Quizzing/models/quiz.dart';
import 'package:Quizzing/providers/quizzes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:string_validator/string_validator.dart';
import 'package:auto_size_text/auto_size_text.dart';

class QuizScreen extends StatefulWidget {
  static const route = '/quiz';
  final Quiz quiz;
  const QuizScreen(this.quiz, {Key key}) : super(key: key);

  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  var _isLoading = true;
  var index = 0;
  var correctQuestions = 0;
  List<Question> questions;
  Question currentQuestion;

  @override
  void initState() {
    super.initState();
    _load();
  }

  void _load() async {
    setState(() {
      _isLoading = true;
    });
    Provider.of<Quizzes>(context, listen: false)
        .fetchQuestions(widget.quiz.id)
        .then((_) {
      questions = Provider.of<Quizzes>(context, listen: false).questions;
      setState(() {
        currentQuestion = questions[index];
        print(currentQuestion.question);
        _isLoading = false;
      });
    });
  }

  void validateAnswer(Question question, int answer) {
    if (question.correctAnswer.contains('$answer')) {
      print('Answer $answer is correct!');
      correctQuestions += 1;
    } else {
      print('Sorry, answer $answer is incorrect :(');
    }

    setState(() {
      index += 1;
      print('${index} ${questions.length}');
      if (index > questions.length - 1) {
        currentQuestion = Question(
            question: "You finished!",
            answer1: "",
            answer2: "",
            answer3: "",
            answer4: "",
            correctAnswer: "",
            id: 41243234,
            quizId: 51345345345);
      } else {
        currentQuestion = questions[index];
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Quiz'),
      ),
      body: Consumer<Quizzes>(
        builder: (context, quizzes, _) {
          if (_isLoading) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            if (index > questions.length - 1) {
              return QuizFinishScreen(
                correct: correctQuestions,
                total: index,
              );
            } else {
              return Column(
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(width: 1),
                        ),
                      ),
                      width: double.infinity,
                      child: !isURL(currentQuestion.question)
                          ? Center(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: AutoSizeText(
                                  currentQuestion.question,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 24,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            )
                          : Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Image.network(
                                currentQuestion.question,
                                color: Colors.black,
                              ),
                            ),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Column(
                      children: <Widget>[
                        Expanded(
                          flex: 1,
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                flex: 1,
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(width: 0.5),
                                      right: BorderSide(width: 0.5),
                                    ),
                                  ),
                                  child: InkWell(
                                    splashColor: Theme.of(context).accentColor,
                                    onTap: () {
                                      validateAnswer(currentQuestion, 1);
                                    },
                                    child: Ink(
                                      child: Center(
                                        child: !isURL(currentQuestion.question)
                                            ? Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Text(
                                                  currentQuestion.answer1 ?? '',
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    fontSize: 24,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              )
                                            : Padding(
                                                padding:
                                                    const EdgeInsets.all(20.0),
                                                child: Image.network(
                                                  currentQuestion.answer1,
                                                  color: Colors.black,
                                                ),
                                              ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(width: 0.5),
                                      left: BorderSide(width: 0.5),
                                    ),
                                  ),
                                  child: InkWell(
                                    splashColor: Theme.of(context).accentColor,
                                    onTap: () {
                                      validateAnswer(currentQuestion, 2);
                                    },
                                    child: Ink(
                                      child: Center(
                                        child: !isURL(currentQuestion.question)
                                            ? Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: AutoSizeText(
                                                  currentQuestion.answer2 ?? '',
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    fontSize: 24,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              )
                                            : Padding(
                                                padding:
                                                    const EdgeInsets.all(20.0),
                                                child: Image.network(
                                                  currentQuestion.answer2,
                                                  color: Colors.black,
                                                ),
                                              ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                flex: 1,
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: Border(
                                      top: BorderSide(width: 0.5),
                                      right: BorderSide(width: 0.5),
                                    ),
                                  ),
                                  child: InkWell(
                                    splashColor: Theme.of(context).accentColor,
                                    onTap: () {
                                      validateAnswer(currentQuestion, 3);
                                    },
                                    child: Ink(
                                      child: Center(
                                        child: !isURL(currentQuestion.question)
                                            ? Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: AutoSizeText(
                                                  currentQuestion.answer3 ?? '',
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    fontSize: 24,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              )
                                            : Padding(
                                                padding:
                                                    const EdgeInsets.all(20.0),
                                                child: Image.network(
                                                  currentQuestion.answer3,
                                                  color: Colors.black,
                                                ),
                                              ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: Border(
                                      top: BorderSide(width: 0.5),
                                      left: BorderSide(width: 0.5),
                                    ),
                                  ),
                                  child: InkWell(
                                    splashColor: Theme.of(context).accentColor,
                                    onTap: () {
                                      validateAnswer(currentQuestion, 4);
                                    },
                                    child: Ink(
                                      child: Center(
                                        child: !isURL(currentQuestion.question)
                                            ? Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: AutoSizeText(
                                                  currentQuestion.answer4 ?? '',
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    fontSize: 24,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              )
                                            : Padding(
                                                padding:
                                                    const EdgeInsets.all(20.0),
                                                child: Image.network(
                                                  currentQuestion.answer4,
                                                  color: Colors.black,
                                                ),
                                              ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              );
            }
          }
        },
      ),
    );
  }
}

class QuizFinishScreen extends StatelessWidget {
  final int correct;
  final int total;
  const QuizFinishScreen({
    @required this.correct,
    @required this.total,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Text(
            'Success!',
            style: TextStyle(fontSize: 56),
          ),
          SizedBox(
            height: 24,
          ),
          Text(
            '${(correct / total * 100).round()}%',
            style: TextStyle(fontSize: 56),
          ),
          Text(
            '$correct/$total',
            style: TextStyle(fontSize: 24),
          ),
        ],
      ),
    );
  }
}
