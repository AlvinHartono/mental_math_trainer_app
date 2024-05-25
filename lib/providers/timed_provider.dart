import 'package:mental_math_trainer_app/models/timed_mode.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/v4.dart';

part 'timed_provider.g.dart';

@riverpod
class TimedProvider extends _$TimedProvider {
  @override
  TimedMode build() {
    return TimedMode(
        numQuestion: 0,
        correct: '0',
        incorrect: '0',
        dateStart: DateTime.now(),
        dateEnd: DateTime.now(),
        accuracy: '0',
        gameId: const UuidV4().toString());
  }

  void setTimed(TimedMode timedObject) {
    state = timedObject;
  }
}
