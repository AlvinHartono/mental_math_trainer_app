import 'dart:math';

class StreakGameState {
  final int number1;
  final int number2;
  final String operator;
  final int answer;
  final int currentStreak;
  final bool isFinished;
  final DateTime startTime;

  StreakGameState(
      {required this.number1,
      required this.number2,
      required this.operator,
      required this.answer,
      this.currentStreak = 0,
      this.isFinished = false,
      required this.startTime});

  // Factory to create the very first state of the game
  factory StreakGameState.initial() {
    final random = Random();
    final number1 = random.nextInt(10) + 1;
    final number2 = random.nextInt(10) + 1;
    final answer = number1 + number2;
    return StreakGameState(
      number1: number1,
      number2: number2,
      operator: '+',
      answer: answer,
      startTime: DateTime.now(),
    );
  }

  // A method to create a copy of the state with some new values.
  // This is useful for updating the state without mutating it.
  StreakGameState copyWith({
    int? number1,
    int? number2,
    String? operator,
    int? answer,
    int? currentStreak,
    bool? isFinished,
  }) {
    return StreakGameState(
        number1: number1 ?? this.number1,
        number2: number2 ?? this.number2,
        operator: operator ?? this.operator,
        answer: answer ?? this.answer,
        currentStreak: currentStreak ?? this.currentStreak,
        isFinished: isFinished ?? this.isFinished,
        startTime: startTime);
  }
}
