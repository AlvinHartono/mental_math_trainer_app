// import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mental_math_trainer_app/models/streak_mode.dart';
import 'package:uuid/v4.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'streak_provider.g.dart';

@riverpod
class StreakNotifier extends _$StreakNotifier {
  @override
  StreakMode build() {
    return StreakMode(
        gameId: const UuidV4().toString(),
        dateStart: DateTime.now(),
        streak: "0",
        dateEnd: DateTime.now());
  }

  void setStreak(StreakMode streakObject) {
    state = streakObject;
  }
}
