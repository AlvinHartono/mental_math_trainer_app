import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mental_math_trainer_app/models/item_choice_difficulty.dart';
import 'package:mental_math_trainer_app/models/item_choice_duration.dart';
import 'package:mental_math_trainer_app/models/timed_mode.dart';
import 'package:mental_math_trainer_app/providers/device_provider.dart';
import 'package:mental_math_trainer_app/providers/timed_provider.dart';
import 'package:mental_math_trainer_app/screens/evaluation_screens/timed_evalutation_screen.dart';
import 'package:mental_math_trainer_app/widgets/pause_menu.dart';
import 'package:mental_math_trainer_app/widgets/stats_custom.dart';

class TimedGameScreen extends ConsumerWidget {
  const TimedGameScreen({
    super.key,
    required this.difficulty,
    required this.duration,
  });

  final ItemChoiceDifficulty difficulty;
  final ItemChoiceDuration duration;

  TextStyle get whiteTextStyle => const TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
      );
  TextStyle get randomTextTheme => GoogleFonts.exo2(
        textStyle: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 80,
          color: Colors.white,
        ),
      );

  double getFontSize(int maxNumberDifficulty) {
    if (maxNumberDifficulty == 1000) return 36;
    return 48;
  }

  TextStyle buttonTextStyle(int maxNumberDifficulty) {
    return TextStyle(
      fontSize: getFontSize(maxNumberDifficulty),
      color: Colors.white,
      fontWeight: FontWeight.bold,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final timedGameState = ref.watch(timedProviderProvider(
        initialDifficulty: difficulty.difficulty,
        initialDurationName: duration.name,
        initialDifficultyName: difficulty.name));

    ref.listen<TimedMode>(
      timedProviderProvider(
          initialDifficulty: difficulty.difficulty,
          initialDurationName: duration.name,
          initialDifficultyName: difficulty.name),
      (previous, next) {
        if (next.remainingSeconds <= 0) {
          Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => const TimedEvaluationScreen(),
          ));
        }
      },
    );

    final deviceSize = ref.watch(deviceSizeProvider);
    final minutes =
        (timedGameState.remainingSeconds ~/ 60).toString().padLeft(2, '0');
    final seconds =
        (timedGameState.remainingSeconds % 60).toString().padLeft(2, '0');
    final questionText =
        '${timedGameState.currentQuestion!.number1} ${timedGameState.currentQuestion!.operator} ${timedGameState.currentQuestion!.number2}';

    final isPaused = ref.watch(_isPausedProvider);
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        ref.read(_isPausedProvider.notifier).state = true;
        ref
            .read(timedProviderProvider(
              initialDifficulty: difficulty.difficulty,
              initialDurationName: duration.name,
              initialDifficultyName: difficulty.name,
            ).notifier)
            .pauseTimer();
        // _showPauseMenu(context);
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 111, 66, 112),
          leading: IconButton(
            onPressed: () {
              final newPauseState = !isPaused;
              ref.read(_isPausedProvider.notifier).state = newPauseState;
              if (newPauseState) {
                ref
                    .read(timedProviderProvider(
                      initialDifficulty: difficulty.difficulty,
                      initialDurationName: duration.name,
                      initialDifficultyName: difficulty.name,
                    ).notifier)
                    .pauseTimer();
              } else {
                ref
                    .read(timedProviderProvider(
                      initialDifficulty: difficulty.difficulty,
                      initialDurationName: duration.name,
                      initialDifficultyName: difficulty.name,
                    ).notifier)
                    .resumeTimer();
              }
            },
            icon: Icon(isPaused ? Icons.play_arrow : Icons.pause),
          ),
          title: Text(
            '$minutes:$seconds',
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
                          'Question ${timedGameState.numQuestion + 1}',
                          style: whiteTextStyle,
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
                        StatsWidget(
                            correct: int.parse(timedGameState.correct),
                            incorrect: int.parse(timedGameState.incorrect)),
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
                                  .read(timedProviderProvider(
                                    initialDifficulty: difficulty.difficulty,
                                    initialDifficultyName: duration.name,
                                    initialDurationName: difficulty.name,
                                  ).notifier)
                                  .checkAnswer(timedGameState.button1Answer);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Text(
                              "${timedGameState.button1Answer}",
                              style: buttonTextStyle(difficulty.difficulty),
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
                                  .read(timedProviderProvider(
                                    initialDifficulty: difficulty.difficulty,
                                    initialDifficultyName: duration.name,
                                    initialDurationName: difficulty.name,
                                  ).notifier)
                                  .checkAnswer(timedGameState.button2Answer);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Text(
                              "${timedGameState.button2Answer}",
                              style: buttonTextStyle(difficulty.difficulty),
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
                  ref.read(_isPausedProvider.notifier).state = false;
                  ref.read(timedProviderProvider(
                    initialDifficulty: difficulty.difficulty,
                    initialDifficultyName: duration.name,
                    initialDurationName: difficulty.name,
                  ));
                },
                onRestart: () {
                  ref.read(_isPausedProvider.notifier).state = false;
                  ref.read(timedProviderProvider(
                    initialDifficulty: difficulty.difficulty,
                    initialDifficultyName: duration.name,
                    initialDurationName: difficulty.name,
                  ));
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

final _isPausedProvider = StateProvider<bool>((ref) => false);
