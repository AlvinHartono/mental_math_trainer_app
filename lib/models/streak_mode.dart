class StreakMode {
  final DateTime dateStart;
  final DateTime dateEnd;
  final String streak;
  final String gameId;

  StreakMode({
    required this.gameId,
    required this.dateStart,
    required this.streak,
    required this.dateEnd,
  });

  Map<String, dynamic> toMap() {
    return {
      'gameId': gameId,
      'dateStart': dateStart,
      'dateEnd': dateEnd,
      'streak': streak,
    };
  }

  factory StreakMode.fromJson(Map<String, dynamic> json) {
    return StreakMode(
      gameId: json['gameId'],
      dateStart: json['dateStart'].toDate(),
      streak: json['streak'],
      dateEnd: json['dateEnd'].toDate(),
    );
  }
}
