import 'package:mental_math_trainer_app/models/item_choice.dart';

class ItemChoiceOperator extends ItemChoice {
  final String operator;
  ItemChoiceOperator({
    required super.index,
    required super.name,
    required this.operator,
  });
}
