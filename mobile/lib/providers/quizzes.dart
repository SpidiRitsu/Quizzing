import 'dart:convert';
import 'dart:io';
import 'package:Quizzing/models/question.dart';
import 'package:Quizzing/models/quiz.dart';
import 'package:Quizzing/models/quiz_to_user.dart';
import 'package:Quizzing/providers/api.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:recase/recase.dart';
import 'package:uuid/uuid.dart';
import 'package:Quizzing/providers/notifications.dart';
import 'package:barcode_scan/barcode_scan.dart';

import 'auth.dart';

class Quizzes extends ChangeNotifier {
  List<Quiz> _availableQuizzes = [];
  List<Quiz> _yourQuizzes = [];
  List<Question> _questions = [];
  Quiz selectedQuiz;

  List<Quiz> get availableQuizzes => _availableQuizzes;
  List<Quiz> get yourQuizzes => _yourQuizzes;
  List<Question> get questions => _questions;

  Future<void> fetchAvailableQuizzes() async {
    try {
      final userData = await Auth.getUserData();
      final filter = {
        "where": {
          "userId": userData['userId'],
        },
        "include": [
          {
            "relation": "quiz",
            "scope": {
              "include": [
                {
                  "relation": "owner",
                }
              ]
            }
          },
          {"relation": "user"},
        ],
      };

      var url = '${Api.URL}/quiz-to-user?filter=${jsonEncode(filter)}';
      var response = await http.get(url);
      var responeObject = json.decode(Utf8Decoder().convert(response.bodyBytes))
          as List<dynamic>;
      final List<QuizToUser> loadedObjects = [];
      responeObject.forEach((obj) {
        loadedObjects.add(QuizToUser.fromApi(obj));
      });

      List<Quiz> loadedQuizes = [];
      loadedObjects.forEach((obj) {
        loadedQuizes.add(obj.quiz);
      });

      loadedQuizes = loadedQuizes.where((quiz) => quiz.isActive).toList();

      _availableQuizzes = loadedQuizes;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> fetchUserQuizzes() async {
    try {
      final userData = await Auth.getUserData();
      final filter = {
        "where": {
          "quizOwner": userData['userId'],
          "isActive": 1,
        },
        "include": [
          {"relation": "owner"},
        ],
      };

      var url = '${Api.URL}/quiz-owners?filter=${jsonEncode(filter)}';
      var response = await http.get(url);
      var responeObject = json.decode(Utf8Decoder().convert(response.bodyBytes))
          as List<dynamic>;
      final List<Quiz> loadedObjects = [];
      responeObject.forEach((obj) {
        loadedObjects.add(Quiz.fromApi(obj));
      });
      _yourQuizzes = loadedObjects;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> fetchQuestions(int quizId) async {
    try {
      final filter = {
        "where": {
          "quizId": quizId,
        },
        "include": [
          {
            "relation": "quiz",
          },
        ],
      };
      var url = '${Api.URL}/questions?filter=${jsonEncode(filter)}';
      var response = await http.get(url);
      var responeObject = json.decode(Utf8Decoder().convert(response.bodyBytes))
          as List<dynamic>;
      final List<Question> loadedObjects = [];
      responeObject.forEach((obj) {
        loadedObjects.add(Question.fromApi(obj));
      });

      _questions = loadedObjects;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> updateQuestion(
      int questionId, String fieldName, String value) async {
    try {
      // is this needed?
      var filter = {
        "include": [
          {
            "relation": "owner",
          },
        ],
      };
      // var url = '${Api.URL}/questions/$questionId?filter=${jsonEncode(filter)}';
      var url = '${Api.URL}/questions/$questionId';
      var response = await http.patch(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({ReCase(fieldName).camelCase: value}),
      );
      if (response.statusCode != 204) {
        throw HttpException('Could not change status');
      }

      await fetchQuestions(selectedQuiz.id);
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> updateQuiz(int quizId, String fieldName, String value) async {
    try {
      var filter = {
        "include": [
          {
            "relation": "owner",
          },
        ],
      };
      // var url = '${Api.URL}/quiz-owners/$quizId?filter=${jsonEncode(filter)}'; //leaving this just in case
      var url = '${Api.URL}/quiz-owners/$quizId';
      var response = await http.patch(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({ReCase(fieldName).camelCase: value}),
      );
      if (response.statusCode != 204) {
        throw HttpException('Could not change status');
      }

      await fetchQuiz(quizId);
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> deleteQuiz(int quizId) async {
    try {
      var url = '${Api.URL}/quiz-owners/$quizId';
      var response = await http.patch(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'isActive': 0}),
      );
      if (response.statusCode != 204) {
        throw HttpException('Could not change status');
      }

      await fetchUserQuizzes();
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> addEmptyQuiz() async {
    try {
      final userData = await Auth.getUserData();
      var uuid = Uuid();
      var url = '${Api.URL}/quiz-owners';
      var response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'quizName': 'NEW_QUIZ_${uuid.v4()}',
          'accessCode': uuid.v4(),
          'dateCreated': DateTime.now().toUtc().toIso8601String(),
          'isActive': 1,
          'quizOwner': userData['userId'],
        }),
      );

      print(response.statusCode);
      print(response.body);

      if (response.statusCode != 200) {
        throw HttpException('Could not post');
      }

      await fetchUserQuizzes();
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> fetchQuiz(int quizId) async {
    try {
      var url = '${Api.URL}/quiz-owners/$quizId';
      var response = await http.get(url);
      selectedQuiz = Quiz.fromApi(
        json.decode(
          Utf8Decoder().convert(response.bodyBytes),
        ),
      );
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> addEmptyQuestion(int quizId) async {
    try {
      var url = '${Api.URL}/questions';
      var response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'quizId': quizId,
          'correctAnswer': '1234',
          'question': 'Empty question...',
        }),
      );
      if (response.statusCode != 200) {
        throw HttpException('Could not post');
      }

      await fetchQuestions(quizId);
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> deleteQuestion(int questionId) async {
    try {
      var url = '${Api.URL}/questions/$questionId';
      var response = await http.delete(url);

      print(response.statusCode);
      print(response.body);
      if (response.statusCode != 204) {
        throw HttpException('Could not post');
      }

      await fetchQuestions(selectedQuiz.id);
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<int> getQuizId(Map<String, dynamic> where) async {
    try {
      var filter = {"where": where};
      var url = '${Api.URL}/quiz-owners?filter=${jsonEncode(filter)}';
      var response = await http.get(url);
      if (response.statusCode != 200) {
        throw HttpException('Could not get');
      }
      print('hi');
      var responseObject =
          json.decode(Utf8Decoder().convert(response.bodyBytes));
      if (responseObject.length > 0) {
        return responseObject[0]['id'];
      }
    } catch (error) {
      throw error;
    }
  }

  Future<void> assignQuizToUser(BuildContext context, String accessCode) async {
    try {
      final userData = await Auth.getUserData();
      var url = '${Api.URL}/quiz-to-user';
      var response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'dateAttached': DateTime.now().toUtc().toIso8601String(),
          'quizId': await getQuizId({
            'accessCode': accessCode,
            'quizOwner': {'neq': userData['userId']},
          }),
          'userId': userData['userId'],
        }),
      );

      print(response.body);
      if (response.statusCode != 200) {
        throw HttpException('Could not post');
      }

      Provider.of<Notifications>(context, listen: false)
          .sendNotification('A new quiz has been added!');
      await fetchAvailableQuizzes();
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> scanQR(BuildContext context) async {
    var result = await BarcodeScanner.scan();

    if (result.type == ResultType.Barcode) {
      print(result.rawContent);
      await assignQuizToUser(context, result.rawContent);
    }
  }
}

// class Quizzes extends ChangeNotifier {
//   List<Quiz> _availableQuizzes = [];
//   List<Quiz> _yourQuizzes = [];
//   List<Question> _questions = [];
//   Quiz selectedQuiz;

//   List<Quiz> get availableQuizzes => _availableQuizzes;
//   List<Quiz> get yourQuizzes => _yourQuizzes;
//   List<Question> get questions => _questions;

//   Future<void> fetchAvailableQuizzes() async {
//     try {
//       final userData = await Auth.getUserData();
//       final filter = {
//         "where": {
//           "userId": userData['userId'],
//         },
//         "include": [
//           {
//             "relation": "quiz",
//             "scope": {
//               "include": [
//                 {
//                   "relation": "owner",
//                 }
//               ]
//             }
//           },
//           {"relation": "user"},
//         ],
//       };

//       var url = '${Api.URL}/quiz-to-user?filter=${jsonEncode(filter)}';
//       var response = await http.get(url);
//       var responeObject = json.decode(Utf8Decoder().convert(response.bodyBytes))
//           as List<dynamic>;
//       final List<QuizToUser> loadedObjects = [];
//       responeObject.forEach((obj) {
//         loadedObjects.add(QuizToUser.fromApi(obj));
//       });

//       List<Quiz> loadedQuizes = [];
//       loadedObjects.forEach((obj) {
//         loadedQuizes.add(obj.quiz);
//       });

//       loadedQuizes = loadedQuizes.where((quiz) => quiz.isActive).toList();

//       _availableQuizzes = loadedQuizes;
//       notifyListeners();
//     } catch (error) {
//       throw error;
//     }
//   }

//   Future<void> fetchUserQuizzes() async {
//     try {
//       final userData = await Auth.getUserData();
//       final filter = {class Quizzes
//         "where": {
//           "quizOwner": userData['userId'],
//           "isActive": 1,
//         },
//         "include": [
//           {"relation": "owner"},
//         ],
//       };

//       var url = '${Api.URL}/quiz-owners?filter=${jsonEncode(filter)}';
//       var response = await http.get(url);
//       var responeObject = json.decode(Utf8Decoder().convert(response.bodyBytes))
//           as List<dynamic>;
//       final List<Quiz> loadedObjects = [];
//       responeObject.forEach((obj) {
//         loadedObjects.add(Quiz.fromApi(obj));
//       });
//       _yourQuizzes = loadedObjects;
//       notifyListeners();
//     } catch (error) {
//       throw error;
//     }
//   }

//   Future<void> fetchQuestions(int quizId) async {
//     try {
//       final filter = {
//         "where": {
//           "quizId": quizId,
//         },
//         "include": [
//           {
//             "relation": "quiz",
//           },
//         ],
//       };
//       var url = '${Api.URL}/questions?filter=${jsonEncode(filter)}';
//       var response = await http.get(url);
//       var responeObject = json.decode(Utf8Decoder().convert(response.bodyBytes))
//           as List<dynamic>;
//       final List<Question> loadedObjects = [];
//       responeObject.forEach((obj) {
//         loadedObjects.add(Question.fromApi(obj));
//       });

//       _questions = loadedObjects;
//       notifyListeners();
//     } catch (error) {
//       throw error;
//     }
//   }
// }

// Future<void> updateQuestion(
//     int questionId, String fieldName, String value) async {
//   try {
//     // is this needed?
//     var filter = {
//       "include": [
//         {
//           "relation": "owner",
//         },
//       ],
//     };
//     // var url = '${Api.URL}/questions/$questionId?filter=${jsonEncode(filter)}';
//     var url = '${Api.URL}/questions/$questionId';
//     var response = await http.patch(
//       url,
//       headers: {'Content-Type': 'application/json'},
//       body: json.encode({ReCase(fieldName).camelCase: value}),
//     );
//     if (response.statusCode != 204) {
//       throw HttpException('Could not change status');
//     }

//     await fetchQuestions(selectedQuiz.id);
//     notifyListeners();
//   } catch (error) {
//     throw error;
//   }
// }

// Future<void> updateQuiz(int quizId, String fieldName, String value) async {
//   try {
//     var filter = {
//       "include": [
//         {
//           "relation": "owner",
//         },
//       ],
//     };
//     // var url = '${Api.URL}/quiz-owners/$quizId?filter=${jsonEncode(filter)}'; //leaving this just in case
//     var url = '${Api.URL}/quiz-owners/$quizId';
//     var response = await http.patch(
//       url,
//       headers: {'Content-Type': 'application/json'},
//       body: json.encode({ReCase(fieldName).camelCase: value}),
//     );
//     if (response.statusCode != 204) {
//       throw HttpException('Could not change status');
//     }

//     await fetchQuiz(quizId);
//     notifyListeners();
//   } catch (error) {
//     throw error;
//   }
// }

// Future<void> deleteQuiz(int quizId) async {
//   try {
//     var url = '${Api.URL}/quiz-owners/$quizId';
//     var response = await http.patch(
//       url,
//       headers: {'Content-Type': 'application/json'},
//       body: json.encode({'isActive': 0}),
//     );
//     if (response.statusCode != 204) {
//       throw HttpException('Could not change status');
//     }

//     await fetchUserQuizzes();
//     notifyListeners();
//   } catch (error) {
//     throw error;
//   }
// }

// Future<void> addEmptyQuiz() async {
//   try {
//     final userData = await Auth.getUserData();
//     var uuid = Uuid();
//     var url = '${Api.URL}/quiz-owners';
//     var response = await http.post(
//       url,
//       headers: {'Content-Type': 'application/json'},
//       body: json.encode({
//         'quizName': 'NEW_QUIZ_${uuid.v4()}',
//         'accessCode': uuid.v4(),
//         'dateCreated': DateTime.now().toUtc().toIso8601String(),
//         'isActive': 1,
//         'quizOwner': userData['userId'],
//       }),
//     );

//     print(response.statusCode);
//     print(response.body);

//     if (response.statusCode != 200) {
//       throw HttpException('Could not post');
//     }

//     await fetchUserQuizzes();
//     notifyListeners();
//   } catch (error) {
//     throw error;
//   }
// }

// Future<void> fetchQuiz(int quizId) async {
//   try {
//     var url = '${Api.URL}/quiz-owners/$quizId';
//     var response = await http.get(url);
//     selectedQuiz = Quiz.fromApi(
//       json.decode(
//         Utf8Decoder().convert(response.bodyBytes),
//       ),
//     );
//     notifyListeners();
//   } catch (error) {
//     throw error;
//   }
// }

// Future<void> addEmptyQuestion(int quizId) async {
//   try {
//     var url = '${Api.URL}/questions';
//     var response = await http.post(
//       url,
//       headers: {'Content-Type': 'application/json'},
//       body: json.encode({
//         'quizId': quizId,
//         'correctAnswer': '1234',
//         'question': 'Empty question...',
//       }),
//     );
//     if (response.statusCode != 200) {
//       throw HttpException('Could not post');
//     }

//     await fetchQuestions(quizId);
//     notifyListeners();
//   } catch (error) {
//     throw error;
//   }
// }

// Future<void> deleteQuestion(int questionId) async {
//   try {
//     var url = '${Api.URL}/questions/$questionId';
//     var response = await http.delete(url);

//     print(response.statusCode);
//     print(response.body);
//     if (response.statusCode != 204) {
//       throw HttpException('Could not post');
//     }

//     await fetchQuestions(selectedQuiz.id);
//     notifyListeners();
//   } catch (error) {
//     throw error;
//   }
// }

// Future<int> getQuizId(Map<String, dynamic> where) async {
//   try {
//     var filter = {"where": where};
//     var url = '${Api.URL}/quiz-owners?filter=${jsonEncode(filter)}';
//     var response = await http.get(url);
//     if (response.statusCode != 200) {
//       throw HttpException('Could not get');
//     }
//     print('hi');
//     var responseObject = json.decode(Utf8Decoder().convert(response.bodyBytes));
//     if (responseObject.length > 0) {
//       return responseObject[0]['id'];
//     }
//   } catch (error) {
//     throw error;
//   }
// }

// Future<void> assignQuizToUser(BuildContext context, String accessCode) async {
//   try {
//     final userData = await Auth.getUserData();
//     var url = '${Api.URL}/quiz-to-user';
//     var response = await http.post(
//       url,
//       headers: {'Content-Type': 'application/json'},
//       body: json.encode({
//         'dateAttached': DateTime.now().toUtc().toIso8601String(),
//         'quizId': await getQuizId({
//           'accessCode': accessCode,
//           'quizOwner': {'neq': userData['userId']},
//         }),
//         'userId': userData['userId'],
//       }),
//     );

//     print(response.body);
//     if (response.statusCode != 200) {
//       throw HttpException('Could not post');
//     }

//     Provider.of<Notifications>(context, listen: false)
//         .sendNotification('A new quiz has been added!');
//     await fetchAvailableQuizzes();
//     notifyListeners();
//   } catch (error) {
//     throw error;
//   }
// }

// Future<void> scanQR(BuildContext context) async {
//   var result = await BarcodeScanner.scan();

//   if (result.type == ResultType.Barcode) {
//     print(result.rawContent);
//     await assignQuizToUser(context, result.rawContent);
//   }
// }
