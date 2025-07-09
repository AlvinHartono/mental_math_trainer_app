import 'dart:math';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mental_math_trainer_app/models/training_game_state.dart';
import 'package:mental_math_trainer_app/providers/device_provider.dart';
import 'package:mental_math_trainer_app/providers/training_game_provider.dart';
import 'package:mental_math_trainer_app/screens/evaluation_screens/training_evaluation_screen.dart';
import 'package:mental_math_trainer_app/services/question_generator.dart';
import 'package:mental_math_trainer_app/widgets/stats_custom.dart';

Random random = Random();

class GameWarmupScreen extends ConsumerWidget {
  const GameWarmupScreen({
    super.key,
    required this.difficulty,
    required this.operator,
  });
  final int difficulty;
  final String operator;

  // Key _animatedTextKey = UniqueKey();

  TextStyle get randomTextTheme => GoogleFonts.exo2(
        textStyle: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 80,
          color: Colors.white,
        ),
      );
  double getFontSize(int maxNumberDifficulty) {
    return maxNumberDifficulty == 1000
        ? 36
        : 48; // Change font size if difficulty is 100
  }

  TextStyle buttonTextStyle(int maxNumberDifficulty) {
    return TextStyle(
      fontSize: getFontSize(maxNumberDifficulty),
      color: Colors.white,
      fontWeight: FontWeight.bold,
    );
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
  Widget build(BuildContext context, WidgetRef ref) {
    final trainingGameState = ref.watch(trainingGameProviderProvider(
        difficulty: difficulty, operator: operator));

    ref.listen<TrainingGameState>(
      trainingGameProviderProvider(difficulty: difficulty, operator: operator),
      (previous, next) {
        if (next.questionsAnswered == next.totalQuestions) {
          Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => TrainingEvaluationScreen(
                correct: next.correctAnswers,
                incorrect: next.incorrectAnswers,
                difficulty: difficulty,
                operator: operator),
          ));
        }
      },
    );

    final deviceSize = ref.watch(deviceSizeProvider);
    final questionText =
        '${trainingGameState.currentQuestion.number1} ${trainingGameState.currentQuestion.operator} ${trainingGameState.currentQuestion.number2}';

    List<int> answerOptions = [
      trainingGameState.currentQuestion.answer,
      trainingGameState.currentQuestion.wrongAnswer
    ];
    answerOptions.shuffle();

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
          title:
              Text("Question ${trainingGameState.questionsAnswered + 1} / 30"),
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
                      correct: trainingGameState.correctAnswers,
                      incorrect: trainingGameState.incorrectAnswers,
                    ),
                    const SizedBox(
                      height: 150,
                    ),
                    AnimatedTextKit(
                      key: ValueKey(questionText),
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
                          ref
                              .read(trainingGameProviderProvider(
                                      difficulty: difficulty,
                                      operator: operator)
                                  .notifier)
                              .submitAnswer(answerOptions[0]);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          "${answerOptions[0]}",
                          style: buttonTextStyle(difficulty),
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
                          ref
                              .read(trainingGameProviderProvider(
                                      difficulty: difficulty,
                                      operator: operator)
                                  .notifier)
                              .submitAnswer(answerOptions[1]);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          "${answerOptions[1]}",
                          style: buttonTextStyle(difficulty),
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
