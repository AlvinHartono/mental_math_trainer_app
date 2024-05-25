class TimedMode {
  final DateTime dateStart;
  final DateTime dateEnd;
  final String accuracy;
  final String correct;
  final String incorrect;
  final String gameId;
  final int numQuestion;

  TimedMode({
    required this.numQuestion,
    required this.correct,
    required this.incorrect,
    required this.dateStart,
    required this.dateEnd,
    required this.accuracy,
    required this.gameId,
  });

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
        numQuestion: json['numQuestion']);
  }
}
