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
import 'package:mental_math_trainer_app/widgets/stats_custom.dart';
import 'package:uuid/uuid.dart';

Random random = Random();

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
  late ItemChoiceDifficulty difficulty;
  late ItemChoiceDuration duration;
  int randomNumber1 = 0;
  int randomNumber2 = 0;
  int answer = 0;
  int wrongAns = 0;
  int numQuestions = 1;
  final start = DateTime.now();
  String question = '';
  Key _animatedTextkey = UniqueKey();

  String uuid = const Uuid().v4();

  Timer? _timer;
  int second = 0, minute = 0;

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
    return difficulty == 1000
        ? 36
        : 48; // Change font size if difficulty is 1000
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
    duration = widget.duration;
    minute = duration.duration;
    randomize();
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
                checkGame();
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

  void randomize() {
    setState(() {
      randomNumber1 = random.nextInt(difficulty.difficulty);
      randomNumber2 = random.nextInt(difficulty.difficulty);
      answer = randomNumber1 + randomNumber2;
      question = '$randomNumber1 + $randomNumber2';

      // Generate a wrong answer that is different from the correct answer
      do {
        wrongAns = random.nextInt(difficulty.difficulty * 2);
      } while (wrongAns == answer);
    });

    _animatedTextkey = UniqueKey();
  }

  void checkAns(int ans) {
    setState(() {
      if (ans == answer) {
        correct++;
      } else {
        incorrect++;
      }
      numQuestions++;
    });
    randomize();
  }

  void checkGame() {
    Navigator.of(context).pushReplacement(MaterialPageRoute(
      builder: (context) => const TimedEvaluationScreen(),
    ));
    ref.read(timedProviderProvider.notifier).setTimed(TimedMode(
        correct: correct.toString(),
        incorrect: incorrect.toString(),
        dateStart: start,
        dateEnd: DateTime.now(),
        accuracy: (correct / numQuestions * 100).toStringAsFixed(0),
        gameId: uuid,
        numQuestion: numQuestions));

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

  Future<void> _showPauseMenu(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Game Paused'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text('Select an option:'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Continue'),
              onPressed: () {
                setState(() {
                  isPaused = false;
                });
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Restart'),
              onPressed: () {
                setState(() {
                  isPaused = false;
                  correct = 0;
                  incorrect = 0;
                  minute = duration.duration;
                  second = 0;
                  numQuestions = 1;
                  randomize();
                  _startTimer();
                });
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Home'),
              onPressed: () {
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = ref.watch(deviceSizeProvider);

    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (didPop) {
          return;
        }
        setState(() {
          isPaused = true;
        });
        _showPauseMenu(context);
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 111, 66, 112),
          leading: IconButton(
              onPressed: () {
                setState(() {
                  isPaused = !isPaused;
                });
                if (isPaused) {
                  _showPauseMenu(context);
                }
              },
              icon: Icon(isPaused ? Icons.play_arrow : Icons.pause)),
          title: Text(
              '${minute.toString().padLeft(2, '0')}:${second.toString().padLeft(2, '0')}'), //_formatTime(_totalSeconds)
          centerTitle: true,
        ),
        backgroundColor: const Color.fromARGB(255, 111, 66, 112),
        body: Container(
          width: deviceSize!.width,
          height: deviceSize.height,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: deviceSize.width,
                height: deviceSize.height * 0.5,
                child: Column(
                  children: [
                    Text(
                      'Question $numQuestions',
                      style: whiteTextStyle,
                    ),
                    AnimatedTextKit(
                      key: _animatedTextkey,
                      animatedTexts: [
                        TyperAnimatedText(
                          question,
                          textStyle: randomTextTheme,
                        ),
                      ],
                      isRepeatingAnimation: false,
                    ),
                    StatsWidget(correct: correct, incorrect: incorrect),
                  ],
                ),
              ),
              Container(
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
                          checkAns(answer);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          "$answer",
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
                          checkAns(wrongAns);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          "$wrongAns",
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
      ),
    );
  }
}
