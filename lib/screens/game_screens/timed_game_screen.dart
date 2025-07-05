import 'dart:async';
import 'dart:math';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mental_math_trainer_app/firebase/firebase_firestore.dart';
import 'package:mental_math_trainer_app/models/item_choice_difficulty.dart';
import 'package:mental_math_trainer_app/models/item_choice_duration.dart';
import 'package:mental_math_trainer_app/models/timed_mode.dart';
import 'package:mental_math_trainer_app/providers/device_provider.dart';
import 'package:mental_math_trainer_app/providers/timed_provider.dart';
import 'package:mental_math_trainer_app/screens/evaluation_screens/timed_evalutation_screen.dart';
import 'package:mental_math_trainer_app/services/question_generator.dart';
import 'package:mental_math_trainer_app/widgets/pause_menu.dart';
import 'package:mental_math_trainer_app/widgets/stats_custom.dart';
import 'package:uuid/uuid.dart';

Random random = Random();

enum DifficultyLevel { easy, medium, hard }

class TimedGameScreen extends ConsumerStatefulWidget {
  const TimedGameScreen(
      {super.key, required this.difficulty, required this.duration});

  final ItemChoiceDifficulty difficulty;
  final ItemChoiceDuration duration;

  @override
  ConsumerState<TimedGameScreen> createState() => _TimedGameScreenState();
}

class _TimedGameScreenState extends ConsumerState<TimedGameScreen> {
  bool isPaused = false;
  int correct = 0, incorrect = 0;
  late int maxNumberDifficulty;
  DifficultyLevel difficulty = DifficultyLevel.easy;
  late ItemChoiceDuration duration;
  late Question _currentQuestion;
  final QuestionGenerator _questionGenerator = QuestionGenerator();
  final start = DateTime.now();
  // String question = '';
  Key _animatedTextkey = UniqueKey();

  String uuid = const Uuid().v4();

  Timer? _timer;
  int second = 0, minute = 0;

  late int _button1Answer;
  late int _button2Answer;

  TextStyle whiteTextStyle = const TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.bold,
  );
  TextStyle randomTextTheme = GoogleFonts.exo2(
    textStyle: const TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 80,
      color: Colors.white,
    ),
  );

  double getFontSize() {
    if (difficulty == DifficultyLevel.hard) return 36;
    return 48;
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

    maxNumberDifficulty = widget.difficulty.difficulty;
    duration = widget.duration;
    minute = duration.duration;

    if (maxNumberDifficulty == 10) {
      difficulty = DifficultyLevel.easy;
    } else if (maxNumberDifficulty == 100) {
      difficulty = DifficultyLevel.medium;
    } else {
      difficulty = DifficultyLevel.hard;
    }
    _generateNewQuestion();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  // Timer Logic Function
  void _startTimer() {
    const oneSecond = Duration(seconds: 1);
    _timer?.cancel(); // Cancel any existing timer
    _timer = Timer.periodic(
      oneSecond,
      (timer) {
        setState(() {
          if (!isPaused) {
            if (second == 0) {
              if (minute == 0) {
                timer.cancel();
                _endGame();
                // checkGame();
              } else {
                minute--;
                second = 59;
              }
            } else {
              second--;
            }
          }
        });
      },
    );
  }

  void _generateNewQuestion() {
    _currentQuestion =
        _questionGenerator.generateQuestion(maxNumberDifficulty, '+');
    _animatedTextkey = UniqueKey();

    List<int> answers = [_currentQuestion.answer, _currentQuestion.wrongAnswer];

    answers.shuffle(random);

    _button1Answer = answers[0];
    _button2Answer = answers[1];

    setState(() {});
  }

  void checkAnswer(int userAnswer) {
    setState(() {
      if (userAnswer == _currentQuestion.answer) {
        correct++;
      } else {
        incorrect++;
      }
      _generateNewQuestion();
    });
  }

  void _endGame() {
    Navigator.of(context).pushReplacement(MaterialPageRoute(
      builder: (context) => const TimedEvaluationScreen(),
    ));

    final totalQuestions = correct + incorrect;
    final accuracy = totalQuestions > 0
        ? (correct / totalQuestions * 100).toStringAsFixed(0)
        : 0.toString();

    ref.read(timedProviderProvider.notifier).setTimed(TimedMode(
        correct: correct.toString(),
        incorrect: incorrect.toString(),
        dateStart: start,
        dateEnd: DateTime.now(),
        accuracy: accuracy,
        gameId: uuid,
        numQuestion: totalQuestions));

    final timed = ref.watch(timedProviderProvider);

    try {
      FirebaseFirestoreHelper firebaseHelper = FirebaseFirestoreHelper();
      firebaseHelper.sendTimedData(
        timed,
        difficulty.name,
        duration.name,
      );
      print("timed data sent successfully");
    } catch (e) {
      print("timed data send failed: $e");
    }
  }

  // Future<void> _showPauseMenu(BuildContext context) async {
  //   return showDialog<void>(
  //     context: context,
  //     barrierDismissible: false,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         title: const Text('Game Paused'),
  //         content: SingleChildScrollView(
  //           child: ListBody(
  //             children: const <Widget>[
  //               Text('Select an option:'),
  //             ],
  //           ),
  //         ),
  //         actions: <Widget>[
  //           TextButton(
  //             child: const Text('Continue'),
  //             onPressed: () {
  //               setState(() {
  //                 isPaused = false;
  //               });
  //               Navigator.of(context).pop();
  //             },
  //           ),
  //           TextButton(
  //             child: const Text('Restart'),
  //             onPressed: () {
  //               setState(() {
  //                 isPaused = false;
  //                 correct = 0;
  //                 incorrect = 0;
  //                 minute = duration.duration;
  //                 second = 0;
  //                 // numQuestions = 1;
  //                 _generateNewQuestion();
  //                 _startTimer();
  //               });
  //               Navigator.of(context).pop();
  //             },
  //           ),
  //           TextButton(
  //             child: const Text('Home'),
  //             onPressed: () {
  //               Navigator.of(context).popUntil((route) => route.isFirst);
  //             },
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    final deviceSize = ref.watch(deviceSizeProvider);
    final questionText =
        '${_currentQuestion.number1} ${_currentQuestion.operator} ${_currentQuestion.number2}';

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        setState(() {
          isPaused = true;
        });
        // _showPauseMenu(context);
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 111, 66, 112),
          leading: IconButton(
            onPressed: () {
              setState(() {
                isPaused = !isPaused;
              });
              // if (isPaused) {
              //   // _showPauseMenu(context);
              // } else {
              //   Navigator.of(context).pop();
              // }
            },
            icon: Icon(isPaused ? Icons.play_arrow : Icons.pause),
          ),
          title: Text(
            '${minute.toString().padLeft(2, '0')}:${second.toString().padLeft(2, '0')}',
          ),
          centerTitle: true,
        ),
        backgroundColor: const Color.fromARGB(255, 111, 66, 112),
        body: Stack(
          children: [
            SizedBox(
              width: deviceSize!.width,
              height: deviceSize.height,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: deviceSize.width,
                    height: deviceSize.height * 0.5,
                    child: Column(
                      children: [
                        Text(
                          'Question ${correct + incorrect + 1}',
                          style: whiteTextStyle,
                        ),
                        AnimatedTextKit(
                          key: _animatedTextkey,
                          animatedTexts: [
                            TyperAnimatedText(
                              questionText,
                              textStyle: randomTextTheme,
                            ),
                          ],
                          isRepeatingAnimation: false,
                        ),
                        StatsWidget(correct: correct, incorrect: incorrect),
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
                              checkAnswer(_button1Answer);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Text(
                              "$_button1Answer",
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
                              checkAnswer(_button2Answer);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Text(
                              "$_button2Answer",
                              style: buttonTextStyle(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            if (isPaused)
              PauseMenu(
                onContinue: () {
                  setState(() {
                    isPaused = false;
                  });
                },
                onRestart: () {
                  setState(() {
                    isPaused = false;
                    correct = 0;
                    incorrect = 0;
                    minute = duration.duration;
                    second = 0;
                    _generateNewQuestion();
                    _startTimer();
                  });
                },
                onHome: () {
                  Navigator.of(context).popUntil((route) => route.isFirst);
                },
              ),
          ],
        ),
      ),
    );
  }
}
