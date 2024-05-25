import 'dart:math';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mental_math_trainer_app/firebase/firebase_firestore.dart';
import 'package:mental_math_trainer_app/models/streak_mode.dart';
import 'package:mental_math_trainer_app/providers/streak_provider.dart';
import 'package:mental_math_trainer_app/screens/evaluation_screens/streak_evaluation_screen.dart';

Random random = Random();

class StreakGameScreen extends ConsumerStatefulWidget {
  const StreakGameScreen({super.key});

  @override
  ConsumerState<StreakGameScreen> createState() => _StreakGameScreenState();
}

class _StreakGameScreenState extends ConsumerState<StreakGameScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _controller = TextEditingController();

  bool isBroken = false;
  int randomNumber1 = 0;
  int randomNumber2 = 0;
  int answer = 0;
  int numQuestions = 1;
  String question = '';
  String operator = '';
  Key _animatedTextKey = UniqueKey();
  final start = DateTime.now();
  String uuid = const Uuid().v4();

  TextStyle randomTextTheme = GoogleFonts.exo2(
    textStyle: const TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 80,
      color: Colors.white,
    ),
  );
  TextStyle whiteTextTheme = GoogleFonts.exo2(
    textStyle: const TextStyle(
      fontWeight: FontWeight.normal,
      color: Colors.white,
    ),
  );
  TextStyle greyTextTheme = GoogleFonts.exo2(
    textStyle: const TextStyle(
      fontWeight: FontWeight.normal,
      color: Colors.grey,
    ),
  );

  void randomize() {
    setState(() {
      // Determine difficulty level based on the number of questions
      int maxNumber;
      if (numQuestions <= 10) {
        maxNumber = 10;
      } else if (numQuestions <= 20) {
        maxNumber = 100;
      } else {
        maxNumber = 1000;
      }

      randomNumber1 = random.nextInt(maxNumber + 1);
      randomNumber2 = random.nextInt(maxNumber + 1);

      // Randomly select an operator
      List<String> operators = ['+', '-', '*', '/'];
      operator = operators[random.nextInt(operators.length)];

      // Calculate the answer based on the selected operator
      switch (operator) {
        case '+':
          answer = randomNumber1 + randomNumber2;
          break;
        case '-':
          answer = randomNumber1 - randomNumber2;
          break;
        case '*':
          answer = randomNumber1 * randomNumber2;
          break;
        case '/':
          // Ensure randomNumber2 is not zero and the result is an integer
          randomNumber2 = randomNumber2 == 0 ? 1 : randomNumber2;
          answer = randomNumber1 ~/ randomNumber2;
          randomNumber1 =
              answer * randomNumber2; // Adjust to ensure integer division
          break;
      }

      question = "$randomNumber1 $operator $randomNumber2";
      _animatedTextKey = UniqueKey();
    });
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    void checkAns(int ans) {
      setState(() {
        if (ans == answer) {
          numQuestions++;
          _controller.clear();
        } else {
          isBroken = !isBroken;
          Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => const StreakEvaluationScreen(),
          ));
          ref.read(streakNotifierProvider.notifier).setStreak(
                StreakMode(
                  gameId: uuid,
                  dateStart: start,
                  streak: (numQuestions - 1).toString(),
                  dateEnd: DateTime.now(),
                ),
              );
          final streak = ref.watch(streakNotifierProvider);

          try {
            FirebaseFirestoreHelper Firebasehelper = FirebaseFirestoreHelper();
            Firebasehelper.sendStreakData(streak);
            print("send Successful");
          } catch (e) {
            print("sendStreakData error: $e");
          }
        }
        randomize();
      });
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

    randomize();
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
          title: Text(numQuestions.toString()),
          centerTitle: true,
          backgroundColor: const Color.fromARGB(255, 66, 87, 112),
        ),
        backgroundColor: const Color.fromARGB(255, 66, 87, 112),
        body: Center(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedTextKit(
                  key: _animatedTextKey,
                  isRepeatingAnimation: false,
                  animatedTexts: [
                    TyperAnimatedText(
                      question,
                      textStyle: randomTextTheme,
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 16,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 100,
                        width: 100,
                        child: TextFormField(
                          style: whiteTextTheme,
                          decoration: InputDecoration(
                            hintText: "0",
                            hintStyle: greyTextTheme,
                          ),
                          controller: _controller,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please enter an answer";
                            }
                            return null;
                          },
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      SizedBox(
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              int userAns = int.parse(_controller.text);
                              checkAns(userAns);
                            }
                          },
                          child: const Icon(
                            Icons.send,
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
      ),
    );
  }
}
