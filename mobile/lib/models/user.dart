import 'package:flutter/foundation.dart';

class User {
  final int id;
  final String username;
  final String email;
  final String name;
  final String surname;
  final String password;
  final DateTime dateCreated;
  final int isActive;

  User({
    @required this.id,
    @required this.username,
    @required this.email,
    this.name,
    this.surname,
    @required this.password,
    this.dateCreated,
    @required this.isActive,
  });

  factory User.fromApi(Map<String, dynamic> body) {
    return User(
      id: body['id'],
      username: body['username'],
      email: body['email'],
      name: body['name'] ?? null,
      surname: body['surname'] ?? null,
      password: body['password'] ?? null,
      dateCreated: body['dateCreated'] != null
          ? DateTime.parse(body['dateCreated'])
          : null,
      isActive: body['isActive'],
    );
  }
}
