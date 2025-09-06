import 'package:flutter/material.dart';
import 'package:zhanashyr/main_page.dart';
import 'package:zhanashyr/quiz.dart';
import 'package:zhanashyr/speech_trainer_page.dart';
import 'package:zhanashyr/welcome_page.dart';
import 'package:zhanashyr/youtube.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';
import 'auth_wrapper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Speech Trainer',
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: Colors.orange,
        textTheme: GoogleFonts.nunitoTextTheme(), // Детский шрифт
        scaffoldBackgroundColor: Colors.yellow[100],
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.orange,
          foregroundColor: Colors.white,
        ),
        colorScheme: ColorScheme.fromSwatch().copyWith(
          secondary: Colors.orangeAccent,
        ),
        iconTheme: IconThemeData(color: Colors.orange),
        // textTheme: TextTheme(
        //   headlineLarge: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        //   bodyMedium: TextStyle(fontSize: 18),
        // ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Colors.green,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.orangeAccent,
            foregroundColor: Colors.white,
            textStyle: GoogleFonts.nunito(fontSize: 20),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            // backgroundColor: Colors.orangeAccent,
            foregroundColor: Colors.orange,
            // textStyle: GoogleFonts.nunito(fontSize: 20),
          ),
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: Colors.orange, // Ярко-оранжевый фон
          selectedItemColor: Colors.white, // Белые иконки при выборе
          unselectedItemColor: Colors.white70, // Полупрозрачные белые иконки
          selectedIconTheme: IconThemeData(size: 30),
          unselectedIconTheme: IconThemeData(size: 26),
          showUnselectedLabels: true,
          type: BottomNavigationBarType.fixed,
          elevation: 0,
        ),
        inputDecorationTheme: InputDecorationTheme(
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey, width: 1),
            borderRadius: BorderRadius.circular(40),
          ),
          filled: true,
          fillColor: Colors.white70,
          floatingLabelStyle: TextStyle(color: Colors.orange),
          labelStyle: TextStyle(color: Colors.grey),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.orange, width: 2),
            borderRadius: BorderRadius.circular(40),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.pink, width: 2),
            borderRadius: BorderRadius.circular(40),
          ),
        ),
        switchTheme: SwitchThemeData(
          trackColor: WidgetStateProperty.all(Colors.orange)
        )
      ),
      debugShowCheckedModeBanner: false,
      home: AuthWrapper(),
    );
  }
}
