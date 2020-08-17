import 'package:Quizzing/models/question.dart';
import 'package:Quizzing/providers/quizzes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:provider/provider.dart';

class QuizEditor extends StatefulWidget {
  QuizEditor({Key key}) : super(key: key);

  @override
  _QuizEditorState createState() => _QuizEditorState();
}

class _QuizEditorState extends State<QuizEditor> {
  final _formKey = GlobalKey<FormState>();

  void edit(int questionId, String title, String value) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          TextEditingController controller = TextEditingController();
          controller.text = value ?? '';
          return AlertDialog(
            content: Stack(
              overflow: Overflow.visible,
              children: <Widget>[
                Positioned(
                  right: -40.0,
                  top: -40.0,
                  child: InkResponse(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: CircleAvatar(
                      child: Icon(Icons.close),
                      // backgroundColor: Color(0xFF9A48D0),
                    ),
                  ),
                ),
                Form(
                  key: _formKey,
                  child: Container(
                    height: 220,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        TextFormField(
                          controller: controller,
                          decoration: InputDecoration(labelText: title),
                          textInputAction: TextInputAction.done,
                          maxLength: 512,
                          minLines: 5,
                          maxLines: 5,
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please provide a value.';
                            } else {
                              return null;
                            }
                          },
                        ),
                        Container(
                          width: double.infinity,
                          child: RaisedButton(
                            color: Theme.of(context).primaryColor,
                            onPressed: () {
                              if (_formKey.currentState.validate()) {
                                _formKey.currentState.save();
                                Provider.of<Quizzes>(context, listen: false)
                                    .updateQuestion(
                                        questionId,
                                        title.split(' ').join(''),
                                        controller.text);
                              }
                              Navigator.of(context).pop();
                              setState(() {});
                            },
                            child: Text(
                              'Save',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<Quizzes>(
      builder: (context, quizzes, _) => Scaffold(
        resizeToAvoidBottomInset: false,
        floatingActionButton: FloatingActionButton(
          child: Icon(
            Icons.add,
            color: Colors.white,
          ),
          onPressed: () {
            quizzes.addEmptyQuestion(quizzes.selectedQuiz.id);
          },
        ),
        body: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              pinned: true,
              centerTitle: true,
              title: Text('Quiz Editor'),
            ),
            for (var i = 0; i < quizzes.questions.length; i++)
              SliverStickyHeader(
                header: Container(
                  height: 60.0,
                  color: Colors.lightBlue,
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  alignment: Alignment.centerLeft,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          '${i + 1}. ${quizzes.questions[i].question ?? 'No question...'}',
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          style: const TextStyle(
                              color: Colors.white, fontSize: 16),
                        ),
                      ),
                      Row(
                        children: <Widget>[
                          IconButton(
                            icon: Icon(
                              Icons.edit,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              edit(
                                quizzes.questions[i].id,
                                'Question',
                                quizzes.questions[i].question,
                              );
                            },
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.delete,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              Provider.of<Quizzes>(context, listen: false)
                                  .deleteQuestion(quizzes.questions[i].id);
                            },
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                sliver: SliverList(
                  delegate: SliverChildListDelegate(<Widget>[
                    CheckboxListTile(
                      value: (quizzes.questions[i].correctAnswer ?? '')
                          .contains('1'),
                      onChanged: (value) {
                        setState(() {
                          if (quizzes.questions[i].correctAnswer
                              .contains('1')) {
                            if (quizzes.questions[i].correctAnswer.length > 1) {
                              quizzes.questions[i].correctAnswer = quizzes
                                  .questions[i].correctAnswer
                                  .replaceFirst(RegExp('1'), '');
                            }
                          } else {
                            quizzes.questions[i].correctAnswer += '1';
                          }
                          quizzes.updateQuestion(
                              quizzes.questions[i].id,
                              'correctAnswer',
                              quizzes.questions[i].correctAnswer);
                        });
                      },
                      controlAffinity: ListTileControlAffinity.leading,
                      title: Text(
                        'Answer 1',
                        style: TextStyle(color: Colors.black),
                      ),
                      isThreeLine: true,
                      subtitle: Text(
                        quizzes.questions[i].answer1 ?? 'No answer...',
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: TextStyle(color: Colors.black54),
                      ),
                      secondary: IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () => edit(
                          quizzes.questions[i].id,
                          'Answer 1',
                          quizzes.questions[i].answer1,
                        ),
                      ),
                    ),
                    CheckboxListTile(
                      value: (quizzes.questions[i].correctAnswer ?? '')
                          .contains('2'),
                      onChanged: (value) {
                        setState(() {
                          if (quizzes.questions[i].correctAnswer
                              .contains('2')) {
                            if (quizzes.questions[i].correctAnswer.length > 1) {
                              quizzes.questions[i].correctAnswer = quizzes
                                  .questions[i].correctAnswer
                                  .replaceFirst(RegExp('2'), '');
                            }
                          } else {
                            quizzes.questions[i].correctAnswer += '2';
                          }
                          quizzes.updateQuestion(
                              quizzes.questions[i].id,
                              'correctAnswer',
                              quizzes.questions[i].correctAnswer);
                        });
                      },
                      controlAffinity: ListTileControlAffinity.leading,
                      title: Text(
                        'Answer 2',
                        style: TextStyle(color: Colors.black),
                      ),
                      isThreeLine: true,
                      subtitle: Text(
                        quizzes.questions[i].answer2 ?? 'No answer...',
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: TextStyle(color: Colors.black54),
                      ),
                      secondary: IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () => edit(
                          quizzes.questions[i].id,
                          'Answer 2',
                          quizzes.questions[i].answer2,
                        ),
                      ),
                    ),
                    CheckboxListTile(
                      value: (quizzes.questions[i].correctAnswer ?? '')
                          .contains('3'),
                      onChanged: (value) {
                        setState(() {
                          if (quizzes.questions[i].correctAnswer
                              .contains('3')) {
                            if (quizzes.questions[i].correctAnswer.length > 1) {
                              quizzes.questions[i].correctAnswer = quizzes
                                  .questions[i].correctAnswer
                                  .replaceFirst(RegExp('3'), '');
                            }
                          } else {
                            quizzes.questions[i].correctAnswer += '3';
                          }
                          quizzes.updateQuestion(
                              quizzes.questions[i].id,
                              'correctAnswer',
                              quizzes.questions[i].correctAnswer);
                        });
                      },
                      controlAffinity: ListTileControlAffinity.leading,
                      title: Text(
                        'Answer 3',
                        style: TextStyle(color: Colors.black),
                      ),
                      isThreeLine: true,
                      subtitle: Text(
                        quizzes.questions[i].answer3 ?? 'No answer...',
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: TextStyle(color: Colors.black54),
                      ),
                      secondary: IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () => edit(
                          quizzes.questions[i].id,
                          'Answer 3',
                          quizzes.questions[i].answer3,
                        ),
                      ),
                    ),
                    CheckboxListTile(
                      value: (quizzes.questions[i].correctAnswer ?? '')
                          .contains('4'),
                      onChanged: (value) {
                        setState(() {
                          if (quizzes.questions[i].correctAnswer
                              .contains('4')) {
                            if (quizzes.questions[i].correctAnswer.length > 1) {
                              quizzes.questions[i].correctAnswer = quizzes
                                  .questions[i].correctAnswer
                                  .replaceFirst(RegExp('4'), '');
                            }
                          } else {
                            quizzes.questions[i].correctAnswer += '4';
                          }
                          quizzes.updateQuestion(
                              quizzes.questions[i].id,
                              'correctAnswer',
                              quizzes.questions[i].correctAnswer);
                        });
                      },
                      controlAffinity: ListTileControlAffinity.leading,
                      title: Text(
                        'Answer 4',
                        style: TextStyle(color: Colors.black),
                      ),
                      isThreeLine: true,
                      subtitle: Text(
                        quizzes.questions[i].answer4 ?? 'No answer...',
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: TextStyle(color: Colors.black54),
                      ),
                      secondary: IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () => edit(
                          quizzes.questions[i].id,
                          'Answer 4',
                          quizzes.questions[i].answer4,
                        ),
                      ),
                    ),
                  ]),
                ),
              )
          ],
        ),
      ),
    );
  }
}
