import 'dart:async';
import 'dart:math';

import 'package:mental_math_trainer_app/firebase/firebase_firestore.dart';
import 'package:mental_math_trainer_app/models/timed_mode.dart';
import 'package:mental_math_trainer_app/services/question_generator.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/v4.dart';

part 'timed_provider.g.dart';

@riverpod
class TimedProvider extends _$TimedProvider {
  Timer? _timer;
  late int _maxNumberDifficulty;
  late String _selectedDurationName;
  late String _selectedDifficultyName;

  final QuestionGenerator _questionGenerator = QuestionGenerator();
  final FirebaseFirestoreHelper _firebaseHelper = FirebaseFirestoreHelper();
  final Random _random = Random();

  @override
  TimedMode build({
    required int initialDifficulty,
    required String initialDurationName,
    required String initialDifficultyName,
  }) {
    _maxNumberDifficulty = initialDifficulty;
    _selectedDurationName = initialDurationName;
    _selectedDifficultyName = initialDifficultyName;
    final initialRemainingSeconds = initialDifficulty * 60;

    final initialQuestion =
        _questionGenerator.generateQuestion(_maxNumberDifficulty, '+');

    _startTimer(initialRemainingSeconds);

    return TimedMode.initial(
      initialQuestion: initialQuestion,
      initialRemainingSeconds: initialRemainingSeconds,
      gameId: const UuidV4().toString(),
    );
  }

  void _startTimer(int initialSeconds) {
    _timer?.cancel();
    state = state.copyWith(remainingSeconds: initialSeconds);
    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        if (state.remainingSeconds > 0) {
          state = state.copyWith(remainingSeconds: state.remainingSeconds - 1);
        } else {
          timer.cancel();
          _endGame();
        }
      },
    );
  }

  void generateNewQuestion() {
    final newQuestion =
        _questionGenerator.generateQuestion(_maxNumberDifficulty, '+');

    state = state.copyWith(currentQuestion: newQuestion);
    state = state.withAnswerOptions(newQuestion, _random);
  }

  void checkAnswer(int userAnswer) {
    if (userAnswer == state.currentQuestion!.answer) {
      state = state.copyWith(
        correct: (int.parse(state.correct) + 1).toString(),
        numQuestion: state.numQuestion + 1,
      );
    } else {
      state = state.copyWith(
        incorrect: (int.parse(state.incorrect) + 1).toString(),
        numQuestion: state.numQuestion + 1,
      );
    }
    generateNewQuestion();
  }

  void _endGame() {
    _timer?.cancel();
    final totalQuestions =
        int.parse(state.correct) + int.parse(state.incorrect);

    final accuracy = totalQuestions > 0
        ? (int.parse(state.correct) / totalQuestions * 100).toStringAsFixed(0)
        : '0';

    state = state.copyWith(
      dateEnd: DateTime.now(),
      accuracy: accuracy,
      numQuestion: totalQuestions,
    );

    _firebaseHelper.sendTimedData(
      state,
      _selectedDifficultyName,
      _selectedDurationName,
    );
  }

  void pauseTimer() {
    _timer?.cancel();
  }

  void resumeTimer() {
    _startTimer(state.remainingSeconds);
  }

  // @override
  // void dispose() {
  //   _timer?.cancel();
  //   super.dispose();
  // }
}
