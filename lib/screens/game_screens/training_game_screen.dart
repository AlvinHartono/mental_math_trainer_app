import 'dart:math';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mental_math_trainer_app/providers/device_provider.dart';
import 'package:mental_math_trainer_app/screens/evaluation_screens/training_evaluation_screen.dart';
import 'package:mental_math_trainer_app/services/question_generator.dart';
import 'package:mental_math_trainer_app/widgets/stats_custom.dart';

Random random = Random();

class GameWarmupScreen extends ConsumerStatefulWidget {
  const GameWarmupScreen(
      {super.key, required this.difficulty, required this.operator});
  final int difficulty;
  final String operator;
  @override
  ConsumerState<GameWarmupScreen> createState() => _GameWarmupScreenState();
}

class _GameWarmupScreenState extends ConsumerState<GameWarmupScreen> {
  int correct = 0, incorrect = 0;
  late int maxNumberDifficulty;
  late String selectedOperator;
  late Question _currentQuestion;
  final QuestionGenerator _questionGenerator = QuestionGenerator();
  int numQuestionsAnswered = 0;
  Key _animatedTextKey = UniqueKey();

  TextStyle randomTextTheme = GoogleFonts.exo2(
    textStyle: const TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 80,
      color: Colors.white,
    ),
  );
  double getFontSize() {
    return maxNumberDifficulty == 1000
        ? 36
        : 48; // Change font size if difficulty is 100
  }

  TextStyle buttonTextStyle() {
    return TextStyle(
      fontSize: getFontSize(),
      color: Colors.white,
      fontWeight: FontWeight.bold,
    );
  }

  @override
  void initState() {
    super.initState();
    maxNumberDifficulty = widget.difficulty;
    selectedOperator = widget.operator;
    _generateNewQuestion();
  }

  void _generateNewQuestion() {
    _currentQuestion = _questionGenerator.generateQuestion(
        maxNumberDifficulty, selectedOperator);
    _animatedTextKey = UniqueKey();
    setState(() {});
  }

  void _checkAnswer(int userAnswer) {
    setState(() {
      if (userAnswer == _currentQuestion.answer) {
        correct++;
      } else {
        incorrect++;
      }
      numQuestionsAnswered++;
    });
    _checkGameProgress();
    _generateNewQuestion();
  }

  void _checkGameProgress() {
    if (numQuestionsAnswered == 30) {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => TrainingEvaluationScreen(
            correct: correct,
            incorrect: incorrect,
            difficulty: maxNumberDifficulty,
            operator: selectedOperator),
      ));
    }
  }

  Future<bool> _onWillPop(BuildContext context) async {
    final shouldExit = await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Are you sure?'),
        content: const Text('Unsaved changes will be lost.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context, true);
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
            child: const Text('Exit'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
    return shouldExit ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = ref.watch(deviceSizeProvider);
    final questionText =
        '${_currentQuestion.number1} ${_currentQuestion.operator} ${_currentQuestion.number2}';

    List<int> answer = [_currentQuestion.answer, _currentQuestion.wrongAnswer];
    answer.shuffle();

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) {
          return;
        }
        _onWillPop(context);
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 66, 112, 84),
          title: Text("Question ${numQuestionsAnswered + 1} / 30"),
          centerTitle: true,
        ),
        backgroundColor: const Color.fromARGB(255, 66, 112, 84),
        body: SizedBox(
          width: deviceSize!.width,
          height: deviceSize.height,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: deviceSize.width,
                height: deviceSize.height,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    StatsWidget(
                      correct: correct,
                      incorrect: incorrect,
                    ),
                    const SizedBox(
                      height: 150,
                    ),
                    AnimatedTextKit(
                      key: _animatedTextKey,
                      animatedTexts: [
                        TyperAnimatedText(
                          questionText,
                          textStyle: randomTextTheme,
                        ),
                      ],
                      isRepeatingAnimation: false,
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: deviceSize.width,
                height: deviceSize.height * 0.3,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 150,
                      height: 200,
                      child: ElevatedButton(
                        onPressed: () {
                          _checkAnswer(answer[0]);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          "${answer[0]}",
                          style: buttonTextStyle(),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    SizedBox(
                      width: 150,
                      height: 200,
                      child: ElevatedButton(
                        onPressed: () {
                          _checkAnswer(answer[1]);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          "${answer[1]}",
                          style: buttonTextStyle(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
