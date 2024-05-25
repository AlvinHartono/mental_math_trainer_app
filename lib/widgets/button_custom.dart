import 'package:flutter/material.dart';

class AnswerButton extends StatelessWidget {
  // comment
  const AnswerButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.red,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: const Text("69"),
    );
  }
}
