import 'package:flutter/material.dart';

class PauseScreen extends StatelessWidget {
  final VoidCallback onResume;
  final VoidCallback onExit;

  const PauseScreen({super.key, required this.onResume, required this.onExit});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Game Paused'),
      content: const Text('What would you like to do?'),
      actions: [
        TextButton(
          onPressed: onResume,
          child: const Text('Resume'),
        ),
        TextButton(
          onPressed: onExit,
          child: const Text('Exit'),
        ),
      ],
    );
  }
}
