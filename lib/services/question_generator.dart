import 'dart:math';

class Question {
  final int number1;
  final int number2;
  final String operator;
  final int answer;
  final int wrongAnswer;

  Question(
      {required this.number1,
      required this.number2,
      required this.operator,
      required this.answer,
      required this.wrongAnswer});
}

class QuestionGenerator {
  final Random _random = Random();

  Question generateQuestion(int maxNumber, String operator) {
    int number1;
    int number2;
    int answer;
    int wrongAnswer;

    number1 = _random.nextInt(maxNumber + 1);
    number2 = _random.nextInt(maxNumber + 1);

    if (operator == '/') {
      number2 = number2 == 0 ? 1 : number2; // Avoid division by zero
      number1 = (number1 ~/ number2) * number2;
    }

    switch (operator) {
      case "+":
        answer = number1 + number2;
        break;
      case "-":
        answer = number1 - number2;
        break;
      case "*":
        answer = number1 * number2;
        break;
      case "/":
        answer = number1 ~/ number2;
        break;
      default:
        throw ArgumentError("Invalid operator: $operator");
    }

    int offset = _random.nextInt(5) + 1;
    if (_random.nextBool()) {
      wrongAnswer = answer + offset;
    } else {
      wrongAnswer = answer - offset;
      if (wrongAnswer < 0 && maxNumber < 100) {
        wrongAnswer = answer + offset;
      }
    }

    if (wrongAnswer == answer) {
      wrongAnswer += (_random.nextBool() ? 1 : -1); // Add or subtract 1
    }

    return Question(
        number1: number1,
        number2: number2,
        operator: operator,
        answer: answer,
        wrongAnswer: wrongAnswer);
  }
}
