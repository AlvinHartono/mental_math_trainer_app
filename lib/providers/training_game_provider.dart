import 'package:flutter/material.dart';
import 'package:mental_math_trainer_app/models/training_game_state.dart';
import 'package:mental_math_trainer_app/services/question_generator.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'training_game_provider.g.dart';

@riverpod
class TrainingGameProvider extends _$TrainingGameProvider {
  late QuestionGenerator _questionGenerator;
  late int _maxNumberDifficulty;
  late String _selectedOperator;

  @override
  TrainingGameState build({
    required int difficulty,
    required String operator,
  }) {
    _questionGenerator = QuestionGenerator();
    _maxNumberDifficulty = difficulty;
    _selectedOperator = operator;
    final initialQuestion = _questionGenerator.generateQuestion(
        _maxNumberDifficulty, _selectedOperator);
    return TrainingGameState(
      currentQuestion: initialQuestion,
    );
  }

  void generateNewQuestion() {
    final newQuestion = _questionGenerator.generateQuestion(
        _maxNumberDifficulty, _selectedOperator);
    state = state.copyWith(currentQuestion: newQuestion);
  }

  void submitAnswer(int userAnswer) {
    if (userAnswer == state.currentQuestion.answer) {
      state = state.copyWith(
        correctAnswers: state.correctAnswers + 1,
        questionsAnswered: state.questionsAnswered + 1,
      );
    } else {
      state = state.copyWith(
        incorrectAnswers: state.incorrectAnswers + 1,
        questionsAnswered: state.questionsAnswered + 1,
      );
    }
    if (state.questionsAnswered < state.totalQuestions) {
      generateNewQuestion();
    } else {
      // Game Finished Logic
    }
  }

  void resetGame() {
    final initialQuestion = _questionGenerator.generateQuestion(
        _maxNumberDifficulty, _selectedOperator);
    state = TrainingGameState(currentQuestion: initialQuestion);
  }
}
