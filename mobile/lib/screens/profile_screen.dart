import 'package:Quizzing/providers/auth.dart';
import 'package:Quizzing/providers/quizzes.dart';
import 'package:Quizzing/widgets/main_drawer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';

class ProfileScreen extends StatefulWidget {
  static const route = '/profile';

  const ProfileScreen({Key key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
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
    return Scaffold(
      drawer: MainDrawer(),
      appBar: AppBar(
        centerTitle: true,
        title: Text('profile').tr(),
        elevation: 0,
      ),
      body: Consumer<Auth>(
        builder: (context, auth, _) => _isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Column(
                children: <Widget>[
                  Container(
                    child: Column(
                      children: <Widget>[
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          height: 110,
                          width: 110,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            image: DecorationImage(
                              image: NetworkImage(
                                  "https://i.pinimg.com/236x/7f/3e/73/7f3e73373671be619946d72de024d36e.jpg"),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Text(
                          '${auth.user.username}',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 20,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                            alignment: Alignment.center,
                            margin: EdgeInsets.symmetric(horizontal: 60),
                            child: Text('${auth.user.email}',
                                textAlign: TextAlign.center)),
                        SizedBox(
                          height: 18,
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 45),
                          // margin: EdgeInsets.all(40),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Column(
                                children: <Widget>[
                                  Text(
                                    Provider.of<Quizzes>(context)
                                        .yourQuizzes
                                        .length
                                        .toString(),
                                    style:
                                        TextStyle(fontWeight: FontWeight.w600),
                                  ),
                                  Text('QUIZES CREATED').tr()
                                ],
                              ),
                              SizedBox(
                                width: 24,
                              ),
                              // Container(
                              //     height: 60,
                              //     child: VerticalDivider(
                              //       color: Color(0xFFfaa307),
                              //       thickness: 1.5,
                              //     )),
                              // Column(
                              //   children: <Widget>[
                              //     Text(
                              //       '140',
                              //       style: TextStyle(fontWeight: FontWeight.w600),
                              //     ),
                              //     Text("POINTS").tr()
                              //   ],
                              // ),
                              Container(
                                  height: 60,
                                  child: VerticalDivider(
                                    color: Color(0xFFfaa307),
                                    thickness: 1.5,
                                  )),
                              SizedBox(
                                width: 24,
                              ),
                              Column(
                                children: <Widget>[
                                  Text(
                                    Provider.of<Quizzes>(context)
                                        .availableQuizzes
                                        .length
                                        .toString(),
                                    style:
                                        TextStyle(fontWeight: FontWeight.w600),
                                  ),
                                  Text("QUIZES'S AVAILABLE").tr()
                                ],
                              ),
                              // SizedBox( height: 2,),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                ],
              ),
      ),
    );
  }
}
