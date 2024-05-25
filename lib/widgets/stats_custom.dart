import 'package:flutter/material.dart';

class StatsWidget extends StatelessWidget {
  const StatsWidget(
      {super.key, required this.correct, required this.incorrect});

  final int correct;
  final int incorrect;

  final TextStyle textStyle = const TextStyle(
    color: Colors.white,
  );

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(
          Icons.check,
          color: Colors.white,
        ),
        Text(
          ": $correct",
          style: textStyle,
        ),
        const SizedBox(
          width: 16,
        ),
        Text(
          "|",
          style: textStyle,
        ),
        const SizedBox(
          width: 16,
        ),
        const Icon(
          Icons.close,
          color: Colors.white,
        ),
        Text(
          ": $incorrect",
          style: textStyle,
        ),
      ],
    );
  }
}
