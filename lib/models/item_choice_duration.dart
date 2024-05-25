import 'package:mental_math_trainer_app/models/item_choice.dart';

class ItemChoiceDuration extends ItemChoice {
  ItemChoiceDuration({
    required super.index,
    required super.name,
    required this.duration,
  });
  final int duration;
}
