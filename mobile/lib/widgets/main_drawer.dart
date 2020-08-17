import 'package:Quizzing/providers/auth.dart';
import 'package:Quizzing/providers/quizzes.dart';
import 'package:Quizzing/screens/dashboard.dart';
import 'package:Quizzing/screens/messages.dart';
import 'package:Quizzing/screens/notifications.dart';
import 'package:Quizzing/screens/profile_screen.dart';
import 'package:Quizzing/screens/quizzes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<Auth>(
      builder: (context, auth, _) => Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Center(
                child: ListTile(
                  leading: Icon(
                    Icons.account_circle,
                    color: Colors.white,
                    size: 42,
                  ),
                  title: Text(
                    '${auth.user.name ?? auth.user.username}',
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.white,
                    ),
                  ),
                  onTap: (){ 
                    Navigator.of(context)
                      .pushReplacementNamed(ProfileScreen.route);
                    },
                ),
              ),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
              ),
            ),
            ListTile(
              leading: Icon(Icons.dashboard),
              title: Text('dashboard').tr(),
              onTap: () {
                Navigator.of(context)
                    .pushReplacementNamed(DashboardScreen.route);
              },
            ),
            ListTile(
              leading: Icon(Icons.question_answer),
              title: Text('quizzes').tr(),
              onTap: () {
                Navigator.of(context).pushReplacementNamed(QuizzesScreen.route);
              },
            ),
            ListTile(
                leading: Icon(Icons.camera),
                title: Text('qr_scan').tr(),
                onTap: () => Provider.of<Quizzes>(context, listen: false)
                    .scanQR(context),
              ),
            ListTile(
              leading: Icon(Icons.notifications),
              title: Text('notifications').tr(),
              onTap: () {
                Navigator.of(context)
                    .pushReplacementNamed(NotificationsScreen.route);
              },
            ),
            ListTile(
              leading: Icon(Icons.mail_outline),
              title: Text('messages').tr(),
              onTap: () {
                Navigator.of(context)
                    .pushReplacementNamed(MessagesScreen.route);
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.exit_to_app),
              title: Text('logout').tr(),
              onTap: () => auth.logout(context),
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.language),
              title: Text('Language - English'),
              onTap: () => context.locale = Locale('en'),
            ),
            ListTile(
              leading: Icon(Icons.language),
              title: Text('Język - Polski'),
              onTap: () => context.locale = Locale('pl'),
            ),


          ],
        ),
      ),
    );
  }
}
