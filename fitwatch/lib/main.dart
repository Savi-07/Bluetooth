import 'package:fitwatch/utilities/sharedPrefsUtils.dart';
import 'package:flutter/material.dart';
import 'package:fitwatch/loginPage.dart';
import 'package:fitwatch/profilePage.dart';
import 'package:fitwatch/profileSetUp.dart';
import 'package:fitwatch/home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  String initialScreen = await getInitialRoute();

  runApp(MaterialApp(
    theme: ThemeData(useMaterial3: true),
    debugShowCheckedModeBanner: false,
    initialRoute: initialScreen,
    routes: {
      'login': (context) => Login(),
      // 'register': (context) => Register(),
      'profile': (context) => Profile(),
      'profileSetUp': (context) => ProfileSetUp(),
      'home': (context) => HomePage(),
    },
  ));
}
