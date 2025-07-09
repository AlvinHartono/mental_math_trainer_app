import 'dart:math';

import 'package:mental_math_trainer_app/services/question_generator.dart';

class TimedMode {
  final DateTime dateStart;
  final DateTime dateEnd;
  final String accuracy;
  final String correct;
  final String incorrect;
  final String gameId;
  final int numQuestion;
  final int remainingSeconds;
  final Question? currentQuestion;
  final int button1Answer;
  final int button2Answer;

  TimedMode({
    required this.numQuestion,
    required this.correct,
    required this.incorrect,
    required this.dateStart,
    required this.dateEnd,
    required this.accuracy,
    required this.gameId,
    required this.remainingSeconds,
    this.currentQuestion,
    this.button1Answer = 0,
    this.button2Answer = 0,
  });

  // Helper method to generate and set answer options
  TimedMode withAnswerOptions(Question question, Random random) {
    List<int> answers = [question.answer, question.wrongAnswer];
    answers.shuffle(random);
    return copyWith(
      button1Answer: answers[0],
      button2Answer: answers[1],
    );
  }

  factory TimedMode.initial({
    required Question initialQuestion,
    required int initialRemainingSeconds,
    required String gameId,
  }) {
    final random = Random();
    final instance = TimedMode(
      numQuestion: 0,
      correct: '0',
      incorrect: '0',
      dateStart: DateTime.now(),
      dateEnd: DateTime.now(), // Will be updated on game end
      accuracy: '0', // Will be updated on game end
      gameId: gameId,
      remainingSeconds: initialRemainingSeconds,
      currentQuestion: initialQuestion,
    );
    return instance.withAnswerOptions(initialQuestion, random);
  }

  Map<String, dynamic> toMap() {
    return {
      'gameId': gameId,
      'dateStart': dateStart,
      'dateEnd': dateEnd,
      'accuracy': accuracy,
      'correct': correct,
      'incorrect': incorrect,
      'numQuestion': numQuestion,
    };
  }

  factory TimedMode.fromJson(Map<String, dynamic> json) {
    return TimedMode(
      correct: json['correct'],
      incorrect: json['incorrect'],
      dateStart: json['dateStart'].toDate(),
      dateEnd: json['dateEnd'].toDate(),
      accuracy: json['accuracy'],
      gameId: json['gameId'],
      numQuestion: json['numQuestion'],
      remainingSeconds: 0,
      currentQuestion: null,
      button1Answer: 0,
      button2Answer: 0,
    );
  }

  TimedMode copyWith({
    int? numQuestion,
    String? correct,
    String? incorrect,
    DateTime? dateStart,
    DateTime? dateEnd,
    String? accuracy,
    String? gameId,
    int? remainingSeconds,
    Question? currentQuestion,
    int? button1Answer,
    int? button2Answer,
  }) {
    return TimedMode(
      numQuestion: numQuestion ?? this.numQuestion,
      correct: correct ?? this.correct,
      incorrect: incorrect ?? this.incorrect,
      dateStart: dateStart ?? this.dateStart,
      dateEnd: dateEnd ?? this.dateEnd,
      accuracy: accuracy ?? this.accuracy,
      gameId: gameId ?? this.gameId,
      remainingSeconds: remainingSeconds ?? this.remainingSeconds,
      currentQuestion: currentQuestion ?? this.currentQuestion,
      button1Answer: button1Answer ?? this.button1Answer,
      button2Answer: button2Answer ?? this.button2Answer,
    );
  }
}
