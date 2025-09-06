import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_tts/flutter_tts.dart'; // Добавляем пакет для озвучки

class WelcomePage extends StatefulWidget {
  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  String _userName = "Гость"; // Имя пользователя по умолчанию, если оно не найдено в Firebase
  final FlutterTts _flutterTts = FlutterTts(); // Инициализация объекта для озвучки

  @override
  void initState() {
    super.initState();
    _getUserName();
    _speak('Привет, $_userName!'); // Озвучиваем приветствие
  }

  // Функция для получения имени пользователя из Firebase
  void _getUserName() {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        _userName = user.displayName ?? user.email?.split('@')[0] ?? 'Гость';
      });
    }
  }

  // Функция для обновления имени пользователя в Firebase
  Future<void> _updateUserName(String newName) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        await user.updateProfile(displayName: newName);  // Обновляем имя пользователя
        await user.reload();  // Обновляем данные пользователя
        user = FirebaseAuth.instance.currentUser;  // Получаем обновленного пользователя
        setState(() {
          _userName = user?.displayName ?? 'Гость';
        });
      } catch (e) {
        print("Ошибка при обновлении имени: $e");
      }
    }
  }

  // Функция для озвучивания текста
  Future<void> _speak(String text) async {
    await _flutterTts.speak(text); // Озвучиваем переданный текст
  }

  // Функция для редактирования имени
  void _editName() async {
    String? newName = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        TextEditingController controller = TextEditingController(text: _userName);
        return AlertDialog(
          title: Text('Введите новое имя'),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(labelText: 'Имя'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(controller.text);
              },
              child: Text('Сохранить'),
            ),
          ],
        );
      },
    );

    if (newName != null && newName.isNotEmpty) {
      _updateUserName(newName); // Обновляем имя
    }
  }

  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
    // После выхода из аккаунта можно перейти на страницу входа или регистрации
  }

  // Весь остальной код остается без изменений...

@override
Widget build(BuildContext context) {
  return Scaffold(
    resizeToAvoidBottomInset: false,
    appBar: AppBar(
      title: Text('Приветственная страница'),
      actions: [
        IconButton(
          icon: Icon(Icons.edit),
          onPressed: _editName,
        ),
        IconButton(
          icon: Icon(Icons.logout),
          tooltip: 'Выйти',
          onPressed: _signOut,
        ),
      ],
    ),
    body: SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Анимированный персонаж
            Container(
              height: 150,
              width: 150,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/character.gif'),
                  fit: BoxFit.cover,
                ),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.orangeAccent, width: 2),
              ),
            ),
            SizedBox(height: 20),
            // Приветствие
            Text(
              'Привет, $_userName!',
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            // Информация
            Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    ListTile(
                      leading: Icon(Icons.account_circle),
                      title: Text('Имя: $_userName'),
                    ),
                    ListTile(
                      leading: Icon(Icons.email),
                      title: Text(FirebaseAuth.instance.currentUser?.email ?? 'Нет email'),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 30),
            // Настройки (фиктивные)
            Text(
              'Настройки',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SwitchListTile(
              title: Text('Уведомления'),
              value: true,
              onChanged: (bool value) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text('Настройка уведомлений изменена (фиктивно)'),
                ));
              },
            ),
            SwitchListTile(
              title: Text('Озвучка включена'),
              value: true,
              onChanged: (bool value) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text('Настройка озвучки изменена (фиктивно)'),
                ));
              },
            ),
            ListTile(
              leading: Icon(Icons.palette),
              title: Text('Тема оформления'),
              subtitle: Text('Светлая'),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text('Изменение темы пока не реализовано'),
                ));
              },
            ),
          ],
        ),
      ),
    ),
  );
}

}
