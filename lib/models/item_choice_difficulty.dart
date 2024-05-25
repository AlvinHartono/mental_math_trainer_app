import 'package:mental_math_trainer_app/models/item_choice.dart';

class ItemChoiceDifficulty extends ItemChoice {
  ItemChoiceDifficulty({
    required super.index,
    required super.name,
    required this.difficulty,
  });
  final int difficulty;
}
