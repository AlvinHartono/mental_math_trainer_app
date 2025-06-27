import 'dart:ui';

import 'package:flutter/material.dart';

class PauseMenu extends StatelessWidget {
  final VoidCallback onContinue;
  final VoidCallback onRestart;
  final VoidCallback onHome;

  const PauseMenu(
      {super.key,
      required this.onContinue,
      required this.onRestart,
      required this.onHome});

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Paused',
              style: TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 40),
            _buildMenuButton('Continue', onContinue),
            const SizedBox(height: 20),
            _buildMenuButton('Restart', onRestart),
            const SizedBox(height: 20),
            _buildMenuButton('Home', onHome),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuButton(String text, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.black.withAlpha(120),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 24,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
