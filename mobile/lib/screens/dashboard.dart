import 'package:Quizzing/providers/auth.dart';
import 'package:Quizzing/providers/quizzes.dart';
import 'package:Quizzing/screens/profile_screen.dart';
import 'package:Quizzing/widgets/main_drawer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';

import 'messages.dart';
import 'notifications.dart';
import 'quizzes.dart';

class DashboardScreen extends StatelessWidget {
  static const route = '/dashboard';

  const DashboardScreen({Key key}) : super(key: key);

  Widget buildGridItem({
    @required String title,
    @required IconData icon,
    @required Function onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Ink(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black54,
              blurRadius: 6.0, // has the effect of softening the shadow
              spreadRadius: 0.1, // has the effect of extending the shadow
              offset: Offset(
                3.0, // horizontal, move right 10
                3.0, // vertical, move down 10
              ),
            )
          ],
          gradient: LinearGradient(
            begin: Alignment(-1, -1),
            end: Alignment(-0.1, -0.75),
            colors: [
              // Theme.of(context).primaryColor,
              Color(0xffffba08),
              Color(0xFFfaa307),
            ],
            tileMode: TileMode.clamp,
            stops: [0.95, 0.95],
          ),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: onTap,
          child: GridTile(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 30.0),
                    child: Icon(
                      icon,
                      size: 48,
                      color: Colors.white,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 12.0),
                    child: Text(
                      title,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<Auth>(
      builder: (context, auth, _) => Scaffold(
        drawer: MainDrawer(),
        body: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              title: Text('dashboard').tr(),
              centerTitle: true,
              floating: true,
              snap: true,
            ),
            SliverGrid.count(
              crossAxisCount: 2,
              children: <Widget>[
                buildGridItem(
                  title: 'profile'.tr(),
                  icon: Icons.supervised_user_circle,
                  onTap: () {
                    Navigator.of(context)
                        .pushReplacementNamed(ProfileScreen.route);
                  },
                ),
                buildGridItem(
                  title: 'quizzes'.tr(),
                  icon: Icons.question_answer,
                  onTap: () {
                    Navigator.of(context)
                        .pushReplacementNamed(QuizzesScreen.route);
                  },
                ),
                buildGridItem(
                  title: 'qr_scan'.tr(),
                  icon: Icons.camera,
                  onTap: () => Provider.of<Quizzes>(context, listen: false)
                      .scanQR(context),
                ),
                buildGridItem(
                  title: 'notifications'.tr(),
                  icon: Icons.notification_important,
                  onTap: () {
                    Navigator.of(context)
                        .pushReplacementNamed(NotificationsScreen.route);
                  },
                ),
                buildGridItem(
                  title: 'messages'.tr(),
                  icon: Icons.message,
                  onTap: () {
                    Navigator.of(context)
                        .pushReplacementNamed(MessagesScreen.route);
                  },
                ),
              ],
            ),
            // delegate: SliverChildListDelegate(<Widget>[

            // ]))
          ],
        ),
      ),
    );
  }
}
