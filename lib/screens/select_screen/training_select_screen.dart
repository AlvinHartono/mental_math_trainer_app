import 'package:flutter/material.dart';
import 'package:mental_math_trainer_app/models/item_choice.dart';
import 'package:mental_math_trainer_app/models/item_choice_difficulty.dart';
import 'package:mental_math_trainer_app/screens/game_screens/training_game_screen.dart';

class TrainingModeScreen extends StatefulWidget {
  const TrainingModeScreen({super.key});

  @override
  State<TrainingModeScreen> createState() => _TrainingModeScreenState();
}

class _TrainingModeScreenState extends State<TrainingModeScreen> {
  final listDifficultyChoices = <ItemChoiceDifficulty>[
    ItemChoiceDifficulty(index: 0, name: "Easy", difficulty: 10),
    ItemChoiceDifficulty(index: 1, name: "Medium", difficulty: 100),
    ItemChoiceDifficulty(index: 2, name: "Hard", difficulty: 1000),
    // ItemChoice(1, "Medium"),
    // ItemChoice(2, "Hard"),
  ];

  final listOperatorChoices = <ItemChoice>[
    ItemChoice(index: 0, name: "+"),
    ItemChoice(index: 1, name: "-"),
    ItemChoice(index: 2, name: "*"),
    ItemChoice(index: 3, name: "/"),
  ];

  int selectedDifficultyIndex = 0;
  int selectedOperatorIndex = 0;

  TextStyle whiteTextStyle = const TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.bold,
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Practice Mode"),
        backgroundColor: const Color.fromARGB(255, 66, 112, 84),
      ),
      backgroundColor: const Color.fromARGB(255, 66, 112, 84),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 50),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Difficulty:",
                    style: whiteTextStyle,
                  ),
                  Row(
                    children: [
                      Wrap(
                        children: listDifficultyChoices
                            .map((e) => Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 0, 3, 0),
                                  child: ChoiceChip(
                                    label: Text(e.name),
                                    selected:
                                        selectedDifficultyIndex == e.index,
                                    onSelected: (value) => setState(() {
                                      selectedDifficultyIndex = e.index;
                                    }),
                                  ),
                                ))
                            .toList(),
                      ),
                    ],
                  ),
                  Text(
                    "Operator:",
                    style: whiteTextStyle,
                  ),
                  Row(
                    children: [
                      Wrap(
                        children: listOperatorChoices
                            .map((e) => Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 0, 0, 0),
                                  child: ChoiceChip(
                                    label: Text(
                                      e.name,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    selected: selectedOperatorIndex == e.index,
                                    onSelected: (value) => setState(() {
                                      selectedOperatorIndex = e.index;
                                    }),
                                  ),
                                ))
                            .toList(),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.05,
                width: MediaQuery.of(context).size.width * 0.4,
                child: ElevatedButton(
                  style: const ButtonStyle(
                      backgroundColor: MaterialStatePropertyAll(Colors.white)),
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => GameWarmupScreen(
                          difficulty:
                              listDifficultyChoices[selectedDifficultyIndex]
                                  .difficulty,
                          operator:
                              listOperatorChoices[selectedOperatorIndex].name,
                        ),
                      ),
                    );
                    print("pressed");
                  },
                  child: const Text(
                    "Start",
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
