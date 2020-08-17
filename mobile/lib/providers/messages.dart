import 'dart:collection';
import 'dart:convert';

import 'package:Quizzing/models/message.dart';
import 'package:Quizzing/models/user.dart';
import 'package:Quizzing/models/user_message.dart';
import 'package:Quizzing/providers/auth.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import 'api.dart';

class Messages extends ChangeNotifier {
  List<Message> _messages = [];
  List<UserMessage> _userMessages = [];

  List<Message> get messages => _messages;
  List<UserMessage> get userMessages => _userMessages;

  Future<void> fetchMessages() async {
    try {
      final userData = await Auth.getUserData();
      final filterToUser = {
        "where": {
          "toUser": userData['userId'],
        },
        "order": ['id DESC'],
        "include": [
          {"relation": "sender"},
          {"relation": "receiver"},
        ]
      };
      final filterFromUser = {
        "where": {
          "fromUser": userData['userId'],
        },
        "order": ['id DESC'],
        "include": [
          {"relation": "sender"},
          {"relation": "receiver"},
        ]
      };

      var url =
          '${Api.URL}/user-message-history?filter=${jsonEncode(filterToUser)}';
      var response = await http.get(url);
      var responeObject = json.decode(Utf8Decoder().convert(response.bodyBytes))
          as List<dynamic>;
      final List<Message> loadedMessages = [];
      responeObject.forEach((obj) {
        loadedMessages.add(Message.fromApi(obj));
      });

      url =
          '${Api.URL}/user-message-history?filter=${jsonEncode(filterFromUser)}';
      response = await http.get(url);
      responeObject = json.decode(Utf8Decoder().convert(response.bodyBytes))
          as List<dynamic>;
      responeObject.forEach((obj) {
        loadedMessages.add(Message.fromApi(obj));
      });

      _messages = loadedMessages;

      final List<UserMessage> userMessages = [];
      // final List<User> senders = loadedMessages
      List<User> senders = loadedMessages
          .where(
            (e) =>
                e.sender.id != userData['userId'] &&
                e.receiver.id == userData['userId'],
          )
          .toList()
          .map((e) => e.sender)
          .toList()
          .toSet()
          .toList();
      // this makes messages unique
      var uniques = LinkedHashMap<int, User>();
      for (var u in senders) {
        uniques[u.id] = u;
      }
      senders = uniques.entries.toList().map((e) => e.value).toList();
      senders.forEach((sender) {
        userMessages.add(UserMessage(
          sender: sender,
          messages: loadedMessages
              .where((message) => identical(message.sender, sender))
              .toList(),
          lastMessage:
              getConversation(userData['userId'], sender.id).last.message,
        ));
      });

      _userMessages = userMessages;

      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  List<Message> getConversation(int userId, int senderId) {
    List<Message> yourMessages = messages
        .where((e) => e.fromUser == userId && e.toUser == senderId)
        .toList();

    List<Message> targetMessages = messages
        .where((e) => e.fromUser == senderId && e.toUser == userId)
        .toList();

    List<Message> newMessages = [...yourMessages, ...targetMessages];
    newMessages.sort((a, b) => a.dateSent.compareTo(b.dateSent));
    return newMessages;
  }

  sendMessage(message) async {
    try {
      final url = '${Api.URL}/user-message-history';
      final response = await http.post(
        url,
        headers: {'Content-type': 'application/json'},
        body: jsonEncode(message),
      );
      print(response.statusCode);

      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> createMessage(String username) async {
    try {
      final filter = {
        "where": {
          "username": username,
        }
      };
      final url = '${Api.URL}/users?filter=${jsonEncode(filter)}';
      final response = await http.get(url);
      var responeObject = json.decode(Utf8Decoder().convert(response.bodyBytes))
          as List<dynamic>;
      if (responeObject.length > 0) {
        _userMessages.insert(
          0,
          UserMessage(
            messages: [],
            lastMessage: '',
            sender: User.fromApi(responeObject[0]),
          ),
        );
        notifyListeners();
      }
    } catch (error) {
      throw error;
    }
  }
}
