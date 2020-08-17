import 'dart:convert';

import 'package:Quizzing/models/user.dart';
import 'package:Quizzing/providers/api.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:Quizzing/screens/auth_screen.dart';
import 'package:flutter/material.dart';

class Auth extends ChangeNotifier {
  User user;
  bool isAuth = false; // I'm pretty sure this will be obsolete

  // TODO: Add biometric auth to make autologin more secure
  Future<void> autoLogin() async {
    if (!isAuth && user != null) return;

    final prefs = await SharedPreferences.getInstance();

    if (!prefs.containsKey('userData')) return;

    final userData = json.decode(prefs.getString('userData'));
    var expiration = DateTime.parse(userData['expiration']);

    if (DateTime.now().difference(expiration).inMilliseconds < 0) {
      isAuth = true;
      user = await fetchUserData({"id": userData['userId']});
      notifyListeners();
    } else {
      clearUserData();
    }
  }

  Future<void> authenticate(String username, String password) async {
    var where = {"username": username};
    try {
      var fetchedUser = await fetchUserData(where);

      if (fetchedUser.password == password) {
        isAuth = true;
        user = fetchedUser;

        final prefs = await SharedPreferences.getInstance();
        final userData = json.encode({
          "userId": user.id,
          "expiration": DateTime.now().add(Duration(days: 1)).toIso8601String(),
        });

        prefs.setString('userData', userData);
      }

      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<User> fetchUserData(Map where) async {
    try {
      final url = '${Api.URL}/users?filter={"where":${jsonEncode(where)}}';
      final response = await http.get(url);
      final responeObject = json.decode(response.body).first;
      final fetchedUser = User.fromApi(responeObject);
      return fetchedUser;
    } catch (error) {
      throw error;
    }
  }

  Future<bool> register(String username, String email, String password) async {
    final url = '${Api.URL}/users';
    try {
      final response = await http.post(
        url,
        headers: {'Content-type': 'application/json'},
        body: jsonEncode(
          {
            'username': username,
            'email': email,
            'password': password,
            'isActive': 1,
          },
        ),
      );
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (error) {
      throw error;
    }
  }

  logout(context) async {
    Navigator.of(context).popUntil((route) => route.isFirst);
    Navigator.of(context).pushReplacementNamed(AuthScreen.route);
    isAuth = false;
    user = null;
    clearUserData();
  }

  clearUserData() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  static getUserData() async {
    final prefs = await SharedPreferences.getInstance();

    if (!prefs.containsKey('userData')) return;

    final userData = json.decode(prefs.getString('userData'));

    return userData;
  }
}
