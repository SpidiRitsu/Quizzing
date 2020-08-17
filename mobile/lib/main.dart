import 'package:Quizzing/providers/auth.dart';
import 'package:Quizzing/providers/messages.dart';
import 'package:Quizzing/providers/notifications.dart';
import 'package:Quizzing/providers/quizzes.dart';
import 'package:Quizzing/screens/auth_screen.dart';
import 'package:Quizzing/screens/dashboard.dart';
import 'package:Quizzing/screens/messages.dart';
import 'package:Quizzing/screens/notifications.dart';
import 'package:Quizzing/screens/profile_screen.dart';
import 'package:Quizzing/screens/quiz.dart';
import 'package:Quizzing/screens/quizzes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';

void main() {
  runApp(
    EasyLocalization(
        supportedLocales: [Locale('en'), Locale('pl')],
        path: 'assets/translations',
        fallbackLocale: Locale('en'),
        child: MyApp()),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => Auth(),
        ),
        ChangeNotifierProvider(
          create: (_) => Notifications(),
        ),
        ChangeNotifierProvider(
          create: (_) => Messages(),
        ),
        ChangeNotifierProvider(
          create: (_) => Quizzes(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale,
        title: 'Quizzing',
        theme: ThemeData(
          // primarySwatch: Colors.blue,
          primaryColor: Color(0xFFfaa307),
          primarySwatch: Colors.amber,
          primaryIconTheme: IconThemeData(color: Colors.white),
          primaryTextTheme: TextTheme(
            headline6: TextStyle(
              color: Colors.white,
            ),
          ),

          // brightness: Brightness.light,
          // This makes the visual density adapt to the platform that you run
          // the app on. For desktop platforms, the controls will be smaller and
          // closer together (more dense) than on mobile platforms.
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        initialRoute: "/",
        routes: {
          AuthScreen.route: (_) => AuthScreen(),
          DashboardScreen.route: (_) => DashboardScreen(),
          NotificationsScreen.route: (_) => NotificationsScreen(),
          MessagesScreen.route: (_) => MessagesScreen(),
          QuizzesScreen.route: (_) => QuizzesScreen(),
          // QuizScreen.route: (_) => QuizScreen(),
          ProfileScreen.route: (_) => ProfileScreen(),
        },
      ),
    );
  }
}
