import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Угадай эмоцию!',
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => QuizScreen()),
                );
              },
              child: Text('Начать'),
            ),
          ],
        ),
      ),
    );
  }
}

class Question {
  final String imageUrl;
  final String correctAnswer;
  final List<String> options;

  Question({
    required this.imageUrl,
    required this.correctAnswer,
    required this.options,
  });
}

final List<Question> questions = [
  Question(
    imageUrl: 'https://img2.freepng.ru/20180421/krw/ave21fzc6.webp',
    correctAnswer: 'Радость',
    options: ['Злость', 'Грусть', 'Радость', 'Удивление'],
  ),
  Question(
    imageUrl:
        'https://img.freepik.com/premium-photo/crying-sad-man_102671-4952.jpg',
    correctAnswer: 'Грусть',
    options: ['Радость', 'Грусть', 'Злость', 'Страх'],
  ),
];

class QuizScreen extends StatefulWidget {
  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int currentIndex = 0;
  int score = 0;
  bool answered = false;
  String? selected;
  final player = AudioPlayer();

  void nextQuestion() {
    setState(() {
      currentIndex++;
      selected = null;
      answered = false;
    });
  }

  void checkAnswer(String answer) {
    if (!answered) {
      setState(() {
        selected = answer;
        answered = true;
        if (answer == questions[currentIndex].correctAnswer) {
          score++;
          player.play(AssetSource('correct.wav'));
        } else {
          player.play(AssetSource('incorrect.wav'));
        }
      });
    }
  }

  final Map<String, String> emojis = {
    'Радость': '😄',
    'Грусть': '😢',
    'Злость': '😠',
    'Удивление': '😲',
    'Страх': '😱',
  };

  @override
  Widget build(BuildContext context) {
    if (currentIndex >= questions.length) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Тест завершён!', style: TextStyle(fontSize: 24)),
              SizedBox(height: 16),
              Text('Правильных ответов: $score из ${questions.length}'),
              SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    currentIndex = 0;
                    score = 0;
                  });
                },
                child: Text('Пройти снова'),
              ),
            ],
          ),
        ),
      );
    }

    final question = questions[currentIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text('Вопрос ${currentIndex + 1}/${questions.length}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.network(question.imageUrl, height: 200),
            SizedBox(height: 24),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.2,
              physics: NeverScrollableScrollPhysics(),
              children:
                  question.options.map((option) {
                    final isCorrect = option == question.correctAnswer;
                    final isSelected = option == selected;
                    Color? color;
                    if (answered) {
                      if (isCorrect)
                        color = Colors.green;
                      else if (isSelected)
                        color = Colors.red;
                    }

                    return ElevatedButton(
                      onPressed: () => checkAnswer(option),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: color,
                        padding: EdgeInsets.symmetric(vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            30,
                          ), // Меньше радиус — менее круглые углы
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            emojis[option] ?? '❓',
                            style: TextStyle(fontSize: 60),
                          ),
                          SizedBox(height: 8),
                          Text(
                            option,
                            style: TextStyle(fontSize: 18),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    );
                  }).toList(),
            ),
            SizedBox(height: 16),
            if (answered)
              ElevatedButton(onPressed: nextQuestion, child: Text('Далее')),
          ],
        ),
      ),
    );
  }
}
