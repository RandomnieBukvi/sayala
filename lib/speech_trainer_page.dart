import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

class SpeechTrainerPage extends StatefulWidget {
  const SpeechTrainerPage({super.key});

  @override
  State<SpeechTrainerPage> createState() => _SpeechTrainerPageState();
}

class _SpeechTrainerPageState extends State<SpeechTrainerPage> {
  final random = Random();
  final SpeechToText _speech = SpeechToText();
  final FlutterTts flutterTts = FlutterTts();

  bool _speechEnabled = false;
  String _lastWords = '';
  String _targetPhrase = '';
  List<LocaleName> _locales = [];
  String _selectedLocaleId = 'ru_RU';

  final List<String> _phrases = [
    "Дом Сон Рот Нос",
    "Мама Папа Рука Нога",
    "Машина Яблоко Комната Одежда",
  ];

  double _accuracy = 0.0;

  @override
  void initState() {
    super.initState();
    _initSpeech();
    _getNewPhrase(); // показываем фразу при старте
  }

  void _initSpeech() async {
    _speechEnabled = await _speech.initialize();
    _locales = await _speech.locales();
    final systemLocale = await _speech.systemLocale();
    setState(() {
      _selectedLocaleId = systemLocale?.localeId ?? 'ru_RU';
    });
  }

  void _getNewPhrase() {
    setState(() {
      _targetPhrase = _phrases[random.nextInt(_phrases.length)];
      _lastWords = '';
      _accuracy = 0.0;
    });
    // speak(_targetPhrase); // озвучиваем фразу
  }

  Future<void> speak(String text) async {
    await flutterTts.setLanguage("ru-RU");
    await flutterTts.setPitch(1.0);
    await flutterTts.setSpeechRate(0.25);
    await flutterTts.speak(text);
  }

  void _startListening() async {
    await _speech.listen(
      localeId: _selectedLocaleId,
      onResult: _onSpeechResult,
    );
    setState(() {});
  }

  void _stopListening() async {
    await _speech.stop();
    setState(() {});
  }

  void _onSpeechResult(SpeechRecognitionResult result) {
    String recognized = result.recognizedWords.toLowerCase().trim();
    String target = _targetPhrase.toLowerCase().trim();

    double similarity = _calculateSimilarity(target, recognized);

    setState(() {
      _lastWords = recognized;
      _accuracy = similarity;
    });
  }

  double _calculateSimilarity(String a, String b) {
    int distance = _levenshtein(a, b);
    int maxLength = max(a.length, b.length);
    if (maxLength == 0) return 1.0;
    return (1 - distance / maxLength).clamp(0.0, 1.0);
  }

  int _levenshtein(String s1, String s2) {
    List<List<int>> dp = List.generate(
        s1.length + 1, (_) => List.filled(s2.length + 1, 0));

    for (int i = 0; i <= s1.length; i++) {
      for (int j = 0; j <= s2.length; j++) {
        if (i == 0)
          dp[i][j] = j;
        else if (j == 0)
          dp[i][j] = i;
        else if (s1[i - 1] == s2[j - 1])
          dp[i][j] = dp[i - 1][j - 1];
        else
          dp[i][j] = 1 +
              min(dp[i - 1][j - 1], min(dp[i][j - 1], dp[i - 1][j]));
      }
    }
    return dp[s1.length][s2.length];
  }

  @override
  Widget build(BuildContext context) {
    Color resultColor = _accuracy > 0.8
        ? Colors.green
        : _accuracy > 0.4
            ? Colors.orange
            : Colors.red;

    return Scaffold(
    appBar: AppBar(
      title: Text(
        "Весёлый Тренажёр Речи 🎤",
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
      centerTitle: true,
    ),
    body: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Text(
          //   "Выбери язык 🌍",
          //   style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
          // ),
          // SizedBox(height: 8),
          // DropdownButton<String>(
          //   isExpanded: true,
          //   value: _selectedLocaleId,
          //   onChanged: (String? newValue) {
          //     setState(() {
          //       _selectedLocaleId = newValue!;
          //     });
          //   },
          //   items: _locales
          //       .map<DropdownMenuItem<String>>((locale) => DropdownMenuItem<String>(
          //             value: locale.localeId,
          //             child: Text(locale.name),
          //           ))
          //       .toList(),
          // ),
          SizedBox(height: 24),
          Text(
            "Повтори фразу 🗣️",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.deepPurple),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 10),
          SpeakableCard(text: _targetPhrase, speak: speak,),
          SizedBox(height: 24),
          Text(
            "Ты сказал(а):",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
          ),
          Text(
            _lastWords.isEmpty ? "..." : _lastWords,
            style: TextStyle(fontSize: 24, color: Colors.teal),
          ),
          SizedBox(height: 20),
          if (_lastWords.isNotEmpty)
            Column(
              children: [
                Text(
                  "Точность",
                  style: TextStyle(fontSize: 20),
                ),
                Text(
                  "${(_accuracy * 100).toStringAsFixed(1)}%",
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: resultColor),
                ),
              ],
            ),
          Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: _speech.isNotListening ? _startListening : _stopListening,
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  backgroundColor: Colors.pink,
                  iconColor: Colors.white
                ),
                child: Icon(_speech.isNotListening ? Icons.mic : Icons.stop),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  // backgroundColor: Colors.orangeAccent,
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  // textStyle: TextStyle(fontSize: 18),
                ),
                onPressed: _getNewPhrase,
                child: Text("Новая фраза 🎲"),
              ),
            ],
          ),
          SizedBox(height: 16),
        ],
      ),
    ),
  );
}
}


class SpeakableCard extends StatefulWidget {
  final String text;
  final Future<void> Function(String) speak;

  const SpeakableCard({Key? key, required this.text, required this.speak}) : super(key: key);

  @override
  _SpeakableCardState createState() => _SpeakableCardState();
}

class _SpeakableCardState extends State<SpeakableCard> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      onTap: () {
        widget.speak(widget.text);
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 25),
        padding: EdgeInsets.all(16),
        margin: EdgeInsets.symmetric(horizontal: _isPressed ? 10 : 0),
        decoration: BoxDecoration(
          color: Colors.yellow[100],
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.orangeAccent, width: 2),
          boxShadow: _isPressed
              ? []
              : [
                  BoxShadow(
                    color: Colors.orange.withOpacity(0.4),
                    offset: Offset(0, 4),
                    blurRadius: 8,
                  ),
                ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.volume_up, size: 28),
            SizedBox(width: 12),
            Flexible(
              child: Text(
                widget.text,
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}