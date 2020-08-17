import 'package:Quizzing/models/quiz.dart';
import 'package:Quizzing/providers/quizzes.dart';
import 'package:Quizzing/screens/quiz.dart';
import 'package:Quizzing/widgets/main_drawer.dart';
import 'package:Quizzing/screens/quiz.dart';
import 'package:Quizzing/screens/quiz_detail.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';

class QuizzesScreen extends StatefulWidget {
  static const route = '/quizzes';
  const QuizzesScreen({Key key}) : super(key: key);

  @override
  _QuizzesScreenState createState() => _QuizzesScreenState();
}

class _QuizzesScreenState extends State<QuizzesScreen> {
  var _isLoading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  void _load() async {
    setState(() {
      _isLoading = true;
    });
    await Provider.of<Quizzes>(context, listen: false).fetchUserQuizzes();
    Provider.of<Quizzes>(context, listen: false)
        .fetchAvailableQuizzes()
        .then((_) {
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        drawer: MainDrawer(),
        appBar: AppBar(
          centerTitle: true,
          title: Text('quizzes').tr(),
          elevation: 0,
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.add),
              onPressed:
                  Provider.of<Quizzes>(context, listen: false).addEmptyQuiz,
            ),
          ],
          bottom: TabBar(
            labelColor: Colors.redAccent,
            unselectedLabelColor: Colors.white,
            indicatorSize: TabBarIndicatorSize.label,
            indicator: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
              color: Colors.white,
            ),
            tabs: [
              Tab(
                child: Align(
                  alignment: Alignment.center,
                  child: Text("available").tr(),
                ),
              ),
              Tab(
                child: Align(
                  alignment: Alignment.center,
                  child: Text("yours").tr(),
                ),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            Consumer<Quizzes>(
              builder: (context, quizzes, _) => _isLoading
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : quizzes.availableQuizzes.length > 0
                      ? ListView.builder(
                          itemCount: quizzes.availableQuizzes.length,
                          itemBuilder: (context, index) {
                            final Quiz quiz = quizzes.availableQuizzes[index];

                            return ListTile(
                              leading: Icon(Icons.question_answer),
                              title: Text(
                                '${quiz.quizName}',
                                overflow: TextOverflow.ellipsis,
                              ),
                              subtitle: Text(quiz.owner.username),
                              trailing: Icon(Icons.arrow_forward_ios),
                              onTap: () {
                                // if (quiz.isActive) {
                                // Navigator.of(context).pushNamed(QuizScreen.route);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => QuizDetailScreen(
                                      quiz.id,
                                    ),
                                  ),
                                );
                                // }
                              },
                            );
                          },
                        )
                      : Center(
                          child: Text('no_quizzes_to_show').tr(),
                        ),
            ),
            Consumer<Quizzes>(
              builder: (context, quizzes, _) => _isLoading
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : quizzes.yourQuizzes.length > 0
                      ? ListView.builder(
                          itemCount: quizzes.yourQuizzes.length,
                          itemBuilder: (context, index) {
                            final Quiz quiz = quizzes.yourQuizzes[index];

                            return ListTile(
                              leading: Icon(Icons.question_answer),
                              title: Text(
                                '${quiz.quizName}',
                                overflow: TextOverflow.ellipsis,
                              ),
                              subtitle: Text(quiz.owner.username),
                              trailing: Icon(Icons.arrow_forward_ios),
                              onTap: () {
                                // if (quiz.isActive) {
                                // Navigator.of(context).pushNamed(QuizScreen.route);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => QuizDetailScreen(
                                      quiz.id,
                                    ),
                                  ),
                                );
                                // }
                              },
                            );
                          },
                        )
                      : Center(
                          child: Text('You have no quizzes yet!'),
                        ),
            ),
          ],
        ),
      ),
    );
  }
}

// class QuizzesScreen extends StatelessWidget {
//   static const route = '/quizzes';
//   const QuizzesScreen({Key key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return DefaultTabController(
//       length: 2,
//       child: Scaffold(
//         drawer: MainDrawer(),
//         appBar: AppBar(
//           centerTitle: true,
//           title: Text('quizzes').tr(),
//           elevation: 0,
//           bottom: TabBar(
//             labelColor: Theme.of(context).primaryColor,
//             unselectedLabelColor: Colors.white,
//             indicatorSize: TabBarIndicatorSize.label,
//             indicator: BoxDecoration(
//               borderRadius: BorderRadius.only(
//                 topLeft: Radius.circular(10),
//                 topRight: Radius.circular(10),
//               ),
//               color: Colors.white,
//             ),
//             tabs: [
//               Tab(
//                 child: Align(
//                   alignment: Alignment.center,
//                   child: Text("available").tr(),
//                 ),
//               ),
//               Tab(
//                 child: Align(
//                   alignment: Alignment.center,
//                   child: Text("yours").tr(),
//                 ),
//               ),
//             ],
//           ),
//         ),
//         body: TabBarView(
//           children: <Widget>[
//             ListView.builder(
//               itemCount: 25,
//               itemBuilder: (context, index) => ListTile(
//                 leading: Icon(Icons.question_answer),
//                 title: Text('Available Quiz ${index + 1}'),
//                 subtitle: Text('This quiz is a very interesting one!'),
//                 onTap: () {
//                   Navigator.of(context).pushNamed(QuizScreen.route);
//                 },
//               ),
//             ),
//             ListView.builder(
//               itemCount: 50,
//               itemBuilder: (context, index) => ListTile(
//                 leading: Icon(Icons.question_answer),
//                 title: Text('Your Quiz ${index + 1}'),
//                 subtitle: Text('This quiz is a very interesting one!'),
//                 onTap: () {
//                   Navigator.of(context).pushNamed(QuizScreen.route);
//                 },
//               ),
//             ),
//           ],
//         ),

//       ),
//     );
//   }
// }
