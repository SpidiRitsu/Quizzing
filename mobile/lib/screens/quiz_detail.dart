import 'package:Quizzing/providers/auth.dart';
import 'package:Quizzing/providers/quizzes.dart';
import 'package:Quizzing/screens/quiz.dart';
import 'package:Quizzing/screens/quiz_editor.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QuizDetailScreen extends StatefulWidget {
  final int quizId;
  const QuizDetailScreen(this.quizId, {Key key}) : super(key: key);

  @override
  _QuizDetailScreenState createState() => _QuizDetailScreenState();
}

class _QuizDetailScreenState extends State<QuizDetailScreen> {
  var _isLoading = true;
  final _formKey = GlobalKey<FormState>();
  var _isOwner = false;

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
        .fetchQuiz(widget.quizId)
        .then((_) async {
      await Provider.of<Quizzes>(context, listen: false)
          .fetchQuestions(widget.quizId);
      var ownerId =
          Provider.of<Quizzes>(context, listen: false).selectedQuiz.quizOwner;
      var userId = (await Auth.getUserData())['userId'];
      if (ownerId == userId) {
        _isOwner = true;
      }
      setState(() {
        _isLoading = false;
      });
    });
  }

  void _showQRCode(String accessCode) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              color: Colors.white,
              child: Center(
                child: QrImage(
                  data: accessCode,
                  version: QrVersions.auto,
                  // size: 300,
                  // gapless: false,
                ),
              ),
            ),
          );
        });
  }

  Widget createEntry(
    BuildContext context, {
    @required String title,
    String value,
    bool editable,
    bool qrCode,
  }) {
    Icon trailingIcon;

    if (editable == true) {
      trailingIcon = Icon(Icons.edit);
    } else if (qrCode == true) {
      trailingIcon = Icon(Icons.camera_enhance);
    }

    return ListTile(
      title: Text('$title: '),
      subtitle: Text(value),
      trailing: trailingIcon,
      onTap: () {
        if (editable == true) {
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
                          height: 130,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              TextFormField(
                                controller: controller,
                                decoration: InputDecoration(labelText: title),
                                textInputAction: TextInputAction.done,
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
                                      Provider.of<Quizzes>(context,
                                              listen: false)
                                          .updateQuiz(
                                              widget.quizId,
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
        } else if (qrCode == true) {
          _showQRCode(value);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        centerTitle: true,
        title: Text('Quiz Details'),
      ),
      body: Consumer<Quizzes>(
        builder: (ctx, quizzes, _) => _isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Column(
                children: <Widget>[
                  createEntry(
                    context,
                    title: 'Quiz Name',
                    value: quizzes.selectedQuiz.quizName,
                    editable: _isOwner,
                  ),
                  createEntry(
                    context,
                    title: 'Access Code',
                    value: quizzes.selectedQuiz.accessCode,
                    qrCode: true,
                  ),
                  createEntry(
                    context,
                    title: 'Date created',
                    value: DateFormat('yyyy-MM-dd hh:mm')
                        .format(quizzes.selectedQuiz.dateCreated),
                  ),
                  createEntry(
                    context,
                    title: 'Questions count',
                    value: quizzes.questions.length.toString(),
                  ),
                  Expanded(
                    child: Container(),
                  ),
                  Container(
                    width: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
                      child: RaisedButton(
                        color: Theme.of(context).primaryColor,
                        child: Text(
                          'Start quiz',
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => QuizScreen(
                                quizzes.selectedQuiz,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  _isOwner
                      ? Row(
                          children: <Widget>[
                            Expanded(
                              flex: 3,
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
                                child: RaisedButton(
                                  color: Colors.black,
                                  child: Text(
                                    '⚠ DELETE ⚠',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  onPressed: () {
                                    quizzes.deleteQuiz(quizzes.selectedQuiz.id);
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 5,
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
                                child: RaisedButton(
                                  color: Theme.of(context).accentColor,
                                  child: Text(
                                    'Edit quiz',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => QuizEditor(),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ],
                        )
                      : Container(),
                ],
              ),
      ),
    );
  }
}
