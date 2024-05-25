import 'package:flutter/material.dart';
import 'package:mental_math_trainer_app/firebase/firebase_firestore.dart';
import 'package:mental_math_trainer_app/models/item_choice_difficulty.dart';
import 'package:mental_math_trainer_app/models/item_choice_duration.dart';
import 'package:mental_math_trainer_app/models/timed_mode.dart';
import 'package:mental_math_trainer_app/screens/game_screens/timed_game_screen.dart';

class TimedModeSelectScreen extends StatefulWidget {
  const TimedModeSelectScreen({super.key});

  @override
  State<TimedModeSelectScreen> createState() => _TimedModeSelectScreenState();
}

class _TimedModeSelectScreenState extends State<TimedModeSelectScreen> {
  bool _isLoading = false;
  TimedMode? timedModeData;

  TextStyle whiteTextStyle = const TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.bold,
  );

  final listDifficultyChoices = <ItemChoiceDifficulty>[
    ItemChoiceDifficulty(
      index: 0,
      name: "Easy",
      difficulty: 10,
    ),
    ItemChoiceDifficulty(
      index: 1,
      name: "Medium",
      difficulty: 100,
    ),
    ItemChoiceDifficulty(
      index: 2,
      name: "Hard",
      difficulty: 1000,
    ),
  ];

  final listDurationChoices = <ItemChoiceDuration>[
    ItemChoiceDuration(index: 0, name: "1 minute", duration: 1),
    ItemChoiceDuration(index: 1, name: "3 minutes", duration: 3),
    ItemChoiceDuration(index: 2, name: "5 minutes", duration: 5),
  ];

  int selectedDifficultyIndex = 0;
  int selectedDurationIndex = 0;

  Future<void> _fetchHighScore() async {
    setState(() {
      _isLoading = true;
    });
    try {
      FirebaseFirestoreHelper helper = FirebaseFirestoreHelper();
      timedModeData = await helper.getTimedData(
          listDifficultyChoices[selectedDifficultyIndex].name,
          listDurationChoices[selectedDurationIndex].name);
    } catch (e) {
      print("error");
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Timed Mode"),
        backgroundColor: const Color.fromARGB(255, 111, 66, 112),
      ),
      backgroundColor: const Color.fromARGB(255, 111, 66, 112),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Difficulty",
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
                                        onSelected: (value) {
                                          setState(() {
                                            selectedDifficultyIndex = e.index;
                                          });
                                          _fetchHighScore();
                                        },
                                      ),
                                    ))
                                .toList(),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Text(
                        "Duration",
                        style: whiteTextStyle,
                      ),
                      Row(
                        children: [
                          Wrap(
                            children: listDurationChoices
                                .map((e) => Padding(
                                      padding:
                                          const EdgeInsets.fromLTRB(0, 0, 3, 0),
                                      child: ChoiceChip(
                                        label: Text(e.name),
                                        selected:
                                            selectedDurationIndex == e.index,
                                        onSelected: (value) {
                                          setState(() {
                                            selectedDurationIndex = e.index;
                                          });
                                          _fetchHighScore();
                                        },
                                      ),
                                    ))
                                .toList(),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      Row(
                        children: [
                          Text(
                            "Accuracy: ",
                            style: whiteTextStyle,
                          ),
                          _isLoading
                              ? const CircularProgressIndicator()
                              : Text(
                                  timedModeData == null
                                      ? "No data"
                                      : "${timedModeData!.accuracy}%",
                                  style: whiteTextStyle,
                                ),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            "High Score: ",
                            style: whiteTextStyle,
                          ),
                          _isLoading
                              ? const CircularProgressIndicator()
                              : Text(
                                  timedModeData == null
                                      ? "No data"
                                      : (int.parse(timedModeData!.correct) +
                                              int.parse(
                                                  timedModeData!.incorrect))
                                          .toString(),
                                  style: whiteTextStyle,
                                ),
                        ],
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      Center(
                        child: SizedBox(
                          height: MediaQuery.of(context).size.height * 0.05,
                          width: MediaQuery.of(context).size.width * 0.8,
                          child: ElevatedButton(
                            style: const ButtonStyle(
                              backgroundColor: MaterialStatePropertyAll(
                                Colors.white,
                              ),
                            ),
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => TimedGameScreen(
                                  difficulty: listDifficultyChoices[
                                      selectedDifficultyIndex],
                                  duration: listDurationChoices[
                                      selectedDurationIndex],
                                ),
                              ));
                            },
                            child: const Text(
                              "Start",
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
