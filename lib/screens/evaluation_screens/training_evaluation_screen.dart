import 'package:flutter/material.dart';
import 'package:mental_math_trainer_app/screens/game_screens/training_game_screen.dart';
import 'package:mental_math_trainer_app/widgets/stats_custom.dart';

class TrainingEvaluationScreen extends StatelessWidget {
  const TrainingEvaluationScreen(
      {super.key,
      required this.correct,
      required this.incorrect,
      required this.difficulty,
      required this.operator});

  final int correct;
  final int incorrect;
  final int difficulty;
  final String operator;

  Text accuracyResult(int accuracy) {
    Color textColor = Colors.white;
    if (accuracy >= 80 && accuracy <= 100) {
      textColor = Colors.green;
    } else if (accuracy >= 60 && accuracy < 80) {
      textColor = Colors.yellow;
    } else if (accuracy >= 30 && accuracy < 60) {
      textColor = Colors.red;
    } else if (accuracy >= 0 && accuracy < 30) {
      textColor = Colors.black;
    }
    return Text(
      "$accuracy%",
      style: TextStyle(
        color: textColor,
        fontWeight: FontWeight.bold,
        fontSize: 80,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final int accuracy = (correct / (correct + incorrect) * 100).toInt();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Evaluation"),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 66, 112, 84),
      ),
      backgroundColor: const Color.fromARGB(255, 66, 112, 84),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(0, 150, 0, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              "Accuracy",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
            accuracyResult(accuracy),
            StatsWidget(correct: correct, incorrect: incorrect),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 16, 0, 0),
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => GameWarmupScreen(
                        difficulty: difficulty, operator: operator),
                  ));
                },
                icon: const Icon(Icons.replay),
                label: const Text("Retry"),
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
      ),
    );
  }
}
