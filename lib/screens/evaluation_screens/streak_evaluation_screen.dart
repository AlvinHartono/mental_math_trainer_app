import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mental_math_trainer_app/providers/streak_provider.dart';
import 'package:mental_math_trainer_app/screens/select_screen/streak_select_screen.dart';

class StreakEvaluationScreen extends ConsumerWidget {
  const StreakEvaluationScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final streak = ref.watch(streakNotifierProvider);
    TextStyle streakStyle = const TextStyle(
      color: Colors.white,
      fontSize: 80,
      fontWeight: FontWeight.bold,
    );
    TextStyle header2WhiteTextStyle = const TextStyle(
        color: Colors.white, fontWeight: FontWeight.bold, fontSize: 24);
    return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 66, 87, 112),
          centerTitle: true,
          title: const Text(
            "Steak Evaluation",
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 66, 87, 112),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Streak:",
                style: header2WhiteTextStyle,
              ),
              Text(
                streak.currentStreak.toString(),
                style: streakStyle,
              ),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => const StreakSelectScreen(),
                  ));
                },
                icon: const Icon(Icons.replay),
                label: const Text(
                  'Retry',
                ),
              ),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.of(context).popUntil((route) => route.isFirst);
                },
                icon: const Icon(Icons.home),
                label: const Text("Home"),
              ),
            ],
          ),
        ));
  }
}
