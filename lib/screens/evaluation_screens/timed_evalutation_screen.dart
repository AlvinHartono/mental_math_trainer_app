import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mental_math_trainer_app/providers/timed_provider.dart';
import 'package:mental_math_trainer_app/screens/select_screen/timed_select_screen.dart';
import 'package:mental_math_trainer_app/widgets/stats_custom.dart';

class TimedEvaluationScreen extends ConsumerWidget {
  const TimedEvaluationScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final timed = ref.watch(timedProviderProvider);

    TextStyle streakStyle = const TextStyle(
      color: Colors.white,
      fontSize: 80,
      fontWeight: FontWeight.bold,
    );

    TextStyle whiteTextStyle = const TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.bold,
    );

    TextStyle header2WhiteTextStyle = const TextStyle(
        color: Colors.white, fontWeight: FontWeight.bold, fontSize: 24);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Timed Evaluation"),
        backgroundColor: const Color.fromARGB(255, 111, 66, 112),
      ),
      backgroundColor: const Color.fromARGB(255, 111, 66, 112),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Accuracy:",
              style: header2WhiteTextStyle,
            ),
            StatsWidget(
                correct: int.parse(timed.correct),
                incorrect: int.parse(timed.incorrect)),
            Text(
              "${timed.accuracy}%",
              style: streakStyle,
            ),
            Text(
              "Question Answered: ",
              style: whiteTextStyle,
            ),
            Text(
              timed.numQuestion.toString(),
              style: whiteTextStyle,
            ),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => const TimedModeSelectScreen(),
                ));
              },
              icon: const Icon(Icons.replay),
              label: const Text('Retry'),
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
      ),
    );
  }
}
