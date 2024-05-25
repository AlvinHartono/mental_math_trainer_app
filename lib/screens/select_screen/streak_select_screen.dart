import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mental_math_trainer_app/models/streak_mode.dart';
import 'package:mental_math_trainer_app/providers/firebase_streak_provider.dart';
import 'package:mental_math_trainer_app/providers/streak_provider.dart';
import 'package:mental_math_trainer_app/screens/game_screens/streak_game_screen.dart';

class StreakSelectScreen extends ConsumerWidget {
  const StreakSelectScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var streakFirebase = ref.watch(firebaseStreakProvider).when(
          data: (data) => '$data',
          error: (error, stackTrace) => 'error lil bro: $error: $stackTrace',
          loading: () => 'Loading...',
        );

    TextStyle headerWhiteTextStyle = const TextStyle(
        color: Colors.white, fontWeight: FontWeight.bold, fontSize: 24);
    TextStyle whiteTextStyle =
        const TextStyle(color: Colors.white, fontWeight: FontWeight.bold);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Streak Mode"),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 66, 87, 112),
      ),
      backgroundColor: const Color.fromARGB(255, 66, 87, 112),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Press the button to start",
              style: headerWhiteTextStyle,
            ),
            Text(
              "Highest streak: $streakFirebase",
              style: whiteTextStyle,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                height: 50,
                width: 150,
                child: ElevatedButton(
                  style: const ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(Colors.white),
                  ),
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const StreakGameScreen(),
                    ));
                  },
                  child: const Text(
                    "Start",
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
