// import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:math';

import 'package:mental_math_trainer_app/firebase/firebase_firestore.dart';
import 'package:mental_math_trainer_app/models/streak_game_state.dart';
import 'package:mental_math_trainer_app/models/streak_mode.dart';
import 'package:mental_math_trainer_app/services/question_generator.dart';
import 'package:uuid/v4.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'streak_provider.g.dart';

@riverpod
class StreakNotifier extends _$StreakNotifier {
  final FirebaseFirestoreHelper _firestoreHelper = FirebaseFirestoreHelper();
  final Random _random = Random();
  final QuestionGenerator _questionGenerator = QuestionGenerator();
  @override
  StreakGameState build() {
    final initialQuestion = _questionGenerator.generateQuestion(10, '+');
    return StreakGameState(
      number1: initialQuestion.number1,
      number2: initialQuestion.number2,
      operator: initialQuestion.operator,
      answer: initialQuestion.answer,
      startTime: DateTime.now(),
    );
  }

  // Method to generate a new question
  void _generateNewQuestion() {
    final streak = state.currentStreak;

    int maxNumber;
    if (streak <= 10) {
      maxNumber = 10;
    } else if (streak <= 20) {
      maxNumber = 100;
    } else {
      maxNumber = 1000;
    }
    // final number1 = _random.nextInt(maxNumber + 1);
    // final number2 = _random.nextInt(maxNumber + 1);

    // // for simplicity, only use addition.
    // final newOperator = '+';
    // final newAnswer = number1 + number2;

    final newQuestion = _questionGenerator.generateQuestion(maxNumber, '+');

    // Update the state with the new question
    state = state.copyWith(
      number1: newQuestion.number1,
      number2: newQuestion.number2,
      operator: newQuestion.operator,
      answer: newQuestion.answer,
    );
  }

  // Method to check the user's answer
  void submitAnswer(int userAnswer) {
    if (userAnswer == state.answer) {
      state = state.copyWith(currentStreak: state.currentStreak + 1);
      _generateNewQuestion();
    } else {
      _endGame();
    }
  }

  // void setStreak(StreakMode streakObject) {
  //   state = streakObject;
  // }

  Future<void> saveGameResult() async {}

  void _endGame() {
    final finalStreak = state.currentStreak;
    final startTime = state.startTime;

    // Save the final score to Firebase
    final result = StreakMode(
      gameId: const UuidV4().toString(),
      dateStart: startTime,
      streak: finalStreak.toString(),
      dateEnd: DateTime.now(),
    );
    _firestoreHelper.sendStreakData(result);

    // Update the state to indicate the game is finished
    state = state.copyWith(isFinished: true);
  }
}
