import 'package:Quizzing/providers/notifications.dart';
import 'package:Quizzing/widgets/main_drawer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';

class NotificationsScreen extends StatefulWidget {
  static const route = '/notifications';

  const NotificationsScreen({Key key}) : super(key: key);

  @override
  _NotificationsScreenState createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  var _isLoading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  void _load() {
    Provider.of<Notifications>(context, listen: false)
        .fetchNotifications()
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
        title: Text('notifications').tr(),
      ),
      body: Consumer<Notifications>(
        builder: (context, notifications, _) => _isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : notifications.notifications.length == 0
                ? Center(
                    child: Text('no_notifications_to_show').tr(),
                  )
                : ListView.builder(
                    itemCount: notifications.notifications.length,
                    itemBuilder: (context, index) => ListTile(
                      leading: Icon(Icons.notifications),
                      title: Text('Notification'),
                      subtitle:
                          Text(notifications.notifications[index].content),
                      onTap: () {},
                    ),
                  ),
      ),
    );
  }
}
