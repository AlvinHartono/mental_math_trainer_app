import 'package:flutter/material.dart';
import 'package:mental_math_trainer_app/screens/select_screen/streak_select_screen.dart';
import 'package:mental_math_trainer_app/screens/select_screen/timed_select_screen.dart';
import 'package:mental_math_trainer_app/screens/select_screen/training_select_screen.dart';
import 'package:mental_math_trainer_app/widgets/game_mode_button.dart';

class GameSelectScreen extends StatelessWidget {
  const GameSelectScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Image(
          image: AssetImage('assets/logo.png'),
          height: 50,
        ),
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: const SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: EdgeInsets.fromLTRB(0, 12, 0, 0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GameModeButton(
                    gameModeScreen: TimedModeSelectScreen(),
                    title: "Timed Mode",
                    color: Color.fromARGB(255, 111, 66, 112),
                    icon: Icons.timer,
                    description: "Solve as much question as possible.",
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  GameModeButton(
                    gameModeScreen: StreakSelectScreen(),
                    title: "Streak Mode",
                    color: Color.fromARGB(255, 66, 87, 112),
                    icon: Icons.trending_up,
                    description: "Question will be harder as the streak goes.",
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  GameModeButton(
                    gameModeScreen: TrainingModeScreen(),
                    title: "Practice Mode",
                    color: Color.fromARGB(255, 66, 112, 84),
                    icon: Icons.fitness_center,
                    description: "train your math skills with 30 questions.",
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
