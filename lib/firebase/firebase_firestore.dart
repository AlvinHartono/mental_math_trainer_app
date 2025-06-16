import 'package:firebase_auth/firebase_auth.dart';
import 'package:mental_math_trainer_app/firebase/firebase_auth_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mental_math_trainer_app/models/streak_mode.dart';
import 'package:mental_math_trainer_app/models/timed_mode.dart';

class FirebaseFirestoreHelper {
  String userId = FirebaseAuthService().currentUser?.uid ?? "";
  User? user = FirebaseAuthService().currentUser;
  final _db = FirebaseFirestore.instance;
  final userCollection = "users";
  final gameDataCollection = "GameData";
  final streakModeDocument = "StreakMode";
  final timedModeDocument = "timedMode";

  Future<void> sendStreakData(StreakMode data) async {
    try {
      final collectionRef = _db.collection(userCollection);
      final documentRef = collectionRef
          .doc(userId)
          .collection(gameDataCollection)
          .doc(streakModeDocument);

      final doc = await documentRef.get();

      if (!doc.exists) {
        print("Document not found");
        await documentRef.set(data.toMap());
        print("New document created with ID: ${documentRef.id}");
      } else {
        // If the document exists, update Document
        await documentRef.update(data.toMap());
      }

      print('Data written to document ID: ${documentRef.id}');
    } catch (e) {
      throw Exception('Error setting data: $e');
    }
  }

  Future<String?> getStreakData() async {
    final documentRef = _db
        .collection(userCollection)
        .doc(userId)
        .collection(gameDataCollection)
        .doc(streakModeDocument);

    final doc = await documentRef.get();

    if (doc.exists) {
      StreakMode streak = StreakMode.fromJson(doc.data()!);
      return streak.streak;
    } else {
      return null;
    }
  }

  Future<void> sendTimedData(
      TimedMode data, String difficulty, String duration) async {
    try {
      final collectionRef = _db.collection(userCollection);
      final documentRef = collectionRef
          .doc(userId)
          .collection(gameDataCollection)
          .doc(timedModeDocument)
          .collection("Type")
          .doc("$difficulty-$duration");

      final doc = await documentRef.get();

      if (!doc.exists) {
        print("Document not found");
        await documentRef.set(data.toMap());
        print("New document created with ID: ${documentRef.id}");
      } else {
        // If the document exists, update Document
        await documentRef.update(data.toMap());
      }

      print('Data written to document ID: ${documentRef.id}');
    } catch (e) {
      throw Exception('Error setting data: $e');
    }
  }

  Future<TimedMode?> getTimedData(String difficulty, String duration) async {
    final documentRef = _db
        .collection(userCollection)
        .doc(userId)
        .collection(gameDataCollection)
        .doc(timedModeDocument)
        .collection("Type")
        .doc("$difficulty-$duration");

    final doc = await documentRef.get();

    if (doc.exists) {
      TimedMode timed = TimedMode.fromJson(doc.data()!);
      return timed;
    } else {
      return null;
    }
  }
}
