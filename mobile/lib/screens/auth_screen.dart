import 'package:Quizzing/providers/auth.dart';
import 'package:Quizzing/screens/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';

enum AuthMode {
  Login,
  SignUp,
}

class AuthScreen extends StatefulWidget {
  static const route = "/";
  AuthScreen({Key key}) : super(key: key);

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  TextEditingController login = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController passwordRepeat = TextEditingController();

  AuthMode _authMode = AuthMode.Login;

  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      Provider.of<Auth>(context, listen: false).autoLogin();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          stops: [0.1, 0.5, 0.7, 0.9],
          colors: [
            Colors.yellow[800],
            Colors.yellow[700],
            Colors.yellow[600],
            Colors.yellow[400],
          ],
        ),
      ),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.transparent,
        body: Consumer<Auth>(
              builder: (context, auth, _) => Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        'Quizzing',
                        style: TextStyle(
                          fontSize: 96,
                          color: Colors.white,
                          fontFamily: "Bangers",
                        ),
                      ),
                      SizedBox(
                         height: 24,
                      ),
                      Card(
                        elevation: 7,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Container(
                            width: 300,
                            height: _authMode == AuthMode.Login ? 275 : 395,
                            child: Column(
                              children: <Widget>[
                                TextField(
                                  controller: login,
                                  decoration: InputDecoration(labelText: 'username'.tr()),
                                  ),
                                if (_authMode == AuthMode.SignUp) ...[
                                  TextField(
                                    controller: email,
                                    decoration: InputDecoration(labelText: 'email'.tr()),
                                    ),
                                ],
                                TextField(
                                  controller: password,
                                  obscureText: true,
                                  decoration: InputDecoration(labelText: 'password'.tr()),
                                ),
                                if (_authMode == AuthMode.SignUp) ...[
                                  TextField(
                                    controller: passwordRepeat,
                                    obscureText: true,
                                    decoration:
                                      InputDecoration(labelText: 'repeat_password'.tr()),
                                ),
                                ],
                                SizedBox(
                                  height: 30,
                                ),
                                Column(
                                  children: <Widget>[
                                    ButtonTheme(
                                      minWidth: double.infinity,
                                      child: RaisedButton(
                                          color: Theme.of(context).primaryColor,
                                          textColor: Theme.of(context)
                                              .primaryTextTheme
                                              .button
                                              .color,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                          child: Text(
                                            _authMode == AuthMode.Login
                                                ? 'login'.tr()
                                                : 'sign_up'.tr(),
                                          ),
                                          onPressed: () async {
                                            if (_authMode == AuthMode.Login) {
                                              await auth.authenticate(
                                                  login.text, password.text);
                                              // if (auth.isAuth == false)
                                              if (auth.isAuth) {
                                                Navigator.pushReplacementNamed(
                                                    context, DashboardScreen.route);
                                              } else if (auth.isAuth == false)
                                                showDialog(
                                                  context: context,
                                                  builder: (ctx) => AlertDialog(
                                                    title: Text(auth.isAuth == true
                                                        ? 'success'.tr()
                                                        : 'something_went_wrong'.tr()),
                                                    content: Text( auth.isAuth == true
                                                            ? 'you_logged_in'.tr()
                                                            : 'try_again'.tr()),
                                                    actions: <Widget>[
                                                      FlatButton(
                                                        child: Text('dismiss'.tr()),
                                                        onPressed: () {
                                                          Navigator.of(context).pop();
                                                        },
                                                      )
                                                    ],
                                                  ),
                                                );
                                            } else {
                                              if (password.text ==
                                                  passwordRepeat.text) {
                                                var isRegistered =

                                                    await auth.register(login.text,
                                                        email.text, password.text);
                                                if (isRegistered) {
                                                  setState(() {
                                                    email.text = '';
                                                    password.text = '';
                                                    passwordRepeat.text = '';
                                                    _authMode = AuthMode.Login;
                                                  });
                                                }
                                                showDialog(
                                                  context: context,
                                                  builder: (ctx) => AlertDialog(
                                                    title: Text(isRegistered == true
                                                        ? 'success'.tr()
                                                        : 'something_went_wrong'.tr()),
                                                    content: Text(isRegistered == true
                                                        ? 'you_logged_in'.tr()
                                                        : 'try_again'.tr()),
                                                    actions: <Widget>[
                                                      FlatButton(
                                                        child: Text('dismiss'.tr()),
                                                        onPressed: () {
                                                          Navigator.of(context).pop();
                                                        },
                                                      )
                                                    ],
                                                  ),
                                                );
                                              }
                                            }
                                          }),
                                    ),
                                    ButtonTheme(
                                      minWidth: double.infinity,
                                      child: OutlineButton(
                                        child: Text(
                                          _authMode == AuthMode.Login
                                              ? 'sign_up'.tr()
                                              : 'login'.tr(),
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            login.text = '';
                                            email.text = '';
                                            password.text = '';
                                            passwordRepeat.text = '';
                                            if (_authMode == AuthMode.Login)
                                              _authMode = AuthMode.SignUp;
                                            else
                                              _authMode = AuthMode.Login;
                                          });
                                        },
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text('Alpha version. Build: ¯\\_(ツ)_/¯')
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}
