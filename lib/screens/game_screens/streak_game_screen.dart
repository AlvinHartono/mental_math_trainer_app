import 'dart:math';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mental_math_trainer_app/models/streak_game_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Watch the game state from the provider
    final gameState = ref.watch(streakNotifierProvider);
    final question =
        "${gameState.number1} ${gameState.operator} ${gameState.number2}";

    // Listen for the game to end to trigger navigation
    ref.listen<StreakGameState>(streakNotifierProvider, (previous, next) {
      if (next.isFinished) {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => const StreakEvaluationScreen(),
        ));
      }
    });

    // Text styles
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

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;

        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Are you sure?'),
            content: const Text('Your streak will be lost!'),
            actions: [
              TextButton(
                // Pop the dialog, then pop the game screen
                onPressed: () =>
                    Navigator.of(context).popUntil((route) => route.isFirst),
                child: const Text('Exit'),
              ),
              TextButton(
                // Just pop the dialog
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancel'),
              ),
            ],
          ),
        );
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text("Streak: ${gameState.currentStreak}"),
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
                  key: ValueKey(question),
                  isRepeatingAnimation: false,
                  animatedTexts: [
                    TyperAnimatedText(question, textStyle: randomTextTheme),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
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
                              final userAnswer = int.parse(_controller.text);
                              ref
                                  .read(streakNotifierProvider.notifier)
                                  .submitAnswer(userAnswer);
                              _controller.clear();
                            }
                          },
                          child: const Icon(Icons.send),
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
