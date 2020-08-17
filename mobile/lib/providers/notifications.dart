import 'dart:convert';
import 'dart:io';
import 'auth.dart';
import 'package:Quizzing/models/notification.dart';
import 'package:Quizzing/providers/api.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Notifications extends ChangeNotifier {
  List<NotificationObject> _notifications = [];

  List<NotificationObject> get notifications => _notifications;

  Future<void> fetchNotifications() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userData = json.decode(prefs.getString('userData'));
      final filter = {
        "where": {
          "userId": userData['userId'],
        },
        "order": ["id DESC"],
        "include": [
          {"relation": "user"}
        ]
      };
      final url = '${Api.URL}/notifications?filter=${jsonEncode(filter)}';
      final response = await http.get(url);
      final responeObject = json.decode(response.body) as List<dynamic>;
      final List<NotificationObject> loadedObjects = [];
      responeObject.forEach((obj) {
        loadedObjects.add(NotificationObject.fromApi(obj));
      });
      _notifications = loadedObjects;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> sendNotification(String content) async {
    try {
      final userData = await Auth.getUserData();
      var url = '${Api.URL}/notifications';
      var response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'content': content,
          'dateCreated': DateTime.now().toUtc().toIso8601String(),
          'userId': userData['userId'],
        }),
      );
      print(response.statusCode);
      print(response.body);
      if (response.statusCode != 200) {
        throw HttpException('Could not post');
      }
      await fetchNotifications();
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }
}
