import 'package:mental_math_trainer_app/firebase/firebase_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'firebase_streak_provider.g.dart';

@riverpod
class FirebaseStreak extends _$FirebaseStreak {
  @override
  FutureOr<String?> build() async {
    return await FirebaseFirestoreHelper().getStreakData();
  }
}
// dart run build_runner watch -d