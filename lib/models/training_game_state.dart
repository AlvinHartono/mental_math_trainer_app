import 'package:mental_math_trainer_app/services/question_generator.dart';

class TrainingGameState {
  final Question currentQuestion;
  final int correctAnswers;
  final int incorrectAnswers;
  final int questionsAnswered;
  final int totalQuestions;

  TrainingGameState({
    required this.currentQuestion,
    this.correctAnswers = 0,
    this.incorrectAnswers = 0,
    this.questionsAnswered = 0,
    this.totalQuestions = 0,
  });

  TrainingGameState copyWith({
    Question? currentQuestion,
    int? correctAnswers,
    int? incorrectAnswers,
    int? questionsAnswered,
  }) {
    return TrainingGameState(
      currentQuestion: currentQuestion ?? this.currentQuestion,
      correctAnswers: correctAnswers ?? this.correctAnswers,
      incorrectAnswers: incorrectAnswers ?? this.incorrectAnswers,
      questionsAnswered: questionsAnswered ?? this.questionsAnswered,
      totalQuestions: totalQuestions,
    );
  }
}
