import 'dart:math';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mental_math_trainer_app/providers/device_provider.dart';
import 'package:mental_math_trainer_app/screens/evaluation_screens/training_evaluation_screen.dart';
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
  int difficulty = 10;
  int randomNumber1 = 0;
  int randomNumber2 = 0;
  int answer = 0;
  String question = '';
  int numQuestions = 1;
  Key _animatedTextKey = UniqueKey();

  TextStyle randomTextTheme = GoogleFonts.exo2(
    textStyle: const TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 80,
      color: Colors.white,
    ),
  );
  double getFontSize() {
    return difficulty == 1000
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
    difficulty = widget.difficulty;
    randomize();
  }

  void randomize() {
    setState(() {
      randomNumber1 = random.nextInt(difficulty);
      randomNumber2 = random.nextInt(difficulty);

      switch (widget.operator) {
        case '+':
          answer = randomNumber1 + randomNumber2;
          question = '$randomNumber1 + $randomNumber2';
          break;
        case '-':
          answer = randomNumber1 - randomNumber2;
          question = '$randomNumber1 - $randomNumber2';
          break;
        case '*':
          answer = randomNumber1 * randomNumber2;
          question = '$randomNumber1 * $randomNumber2';
          break;
        case '/':
          // Ensure no division by zero and integers for division
          randomNumber2 = randomNumber2 == 0 ? 1 : randomNumber2;
          randomNumber1 = randomNumber1 - (randomNumber1 % randomNumber2);
          answer = randomNumber1 ~/ randomNumber2;
          question = '$randomNumber1 / $randomNumber2';
          break;
        default:
          answer = randomNumber1 + randomNumber2;
          question = '$randomNumber1 + $randomNumber2';
      }

      _animatedTextKey = UniqueKey(); // Change the key to restart animation
    });
  }

  void checkAns(int ans) {
    setState(() {
      if (ans == answer) {
        correct++;
      } else {
        incorrect++;
      }
    });
    numQuestions++;
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
              Navigator.pop(context, true);
            },
            child: const Text('Exit'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
    return shouldExit ?? false;
  }

  @override
  Widget build(BuildContext context) {
    void checkGame() {
      if (numQuestions == 30) {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => TrainingEvaluationScreen(
            correct: correct,
            incorrect: incorrect,
            difficulty: difficulty,
            operator: widget.operator,
          ),
        ));
      }
    }

    final deviceSize = ref.watch(deviceSizeProvider);

    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (didPop) {
          return;
        }
        _onWillPop(context);
      },
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: const Color.fromARGB(255, 66, 112, 84),
            title: Text("Question $numQuestions / 30"),
            centerTitle: true,
          ),
          backgroundColor: const Color.fromARGB(255, 66, 112, 84),
          body: SizedBox(
            width: deviceSize!.width,
            height: deviceSize.height,
            // color: Colors.red,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: deviceSize.width,
                  height: deviceSize.height * 0.5,
                  // color: Colors.blue,
                  child: Column(
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
                            question,
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
                  // color: Colors.yellow,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 150,
                        height: 200,
                        child: ElevatedButton(
                          onPressed: () {
                            randomize();
                            int ans = answer % 2 == 0
                                ? answer
                                : random.nextInt(difficulty);
                            checkAns(ans);
                            checkGame();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            answer % 2 == 0
                                ? "$answer"
                                : random.nextInt(difficulty).toString(),
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
                            randomize();
                            int ans = answer % 2 == 1
                                ? answer
                                : random.nextInt(difficulty);
                            checkAns(ans);
                            checkGame();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            answer % 2 == 1
                                ? "$answer"
                                : random.nextInt(difficulty).toString(),
                            style: buttonTextStyle(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )),
    );
  }
}
