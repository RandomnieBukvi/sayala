import 'package:flutter/material.dart';
import 'package:zhanashyr/quiz.dart';
import 'package:zhanashyr/speech_trainer_page.dart';
import 'package:zhanashyr/welcome_page.dart';
import 'package:zhanashyr/youtube.dart';

class MainScreen extends StatefulWidget {
  @override
  MainScreenState createState() => MainScreenState();
}

class MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [WelcomePage(), WelcomeScreen(), SpeechTrainerPage(), VideoListPage()];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    print(Theme.of(context).textTheme.headlineLarge.toString());
    return Scaffold(
      extendBody: false, // Чтобы фон был прозрачным и края отображались
      body: IndexedStack(index: _selectedIndex, children: _pages),
      bottomNavigationBar: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(15),
          topRight: Radius.circular(15),
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.person_rounded), label: 'Профиль'),
            BottomNavigationBarItem(icon: Icon(Icons.quiz), label: 'Викторина'),
            BottomNavigationBarItem(
              icon: Icon(Icons.mic),
              label: 'Тренажер речи',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.spatial_audio_off_rounded),
              label: 'Артикуляционные упражнения',
            ),
          ],
        ),
      ),
    );
  }
}
