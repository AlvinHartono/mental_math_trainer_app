import 'package:flutter/material.dart';

class Leaderboards extends StatefulWidget {
  const Leaderboards({super.key});

  @override
  State<Leaderboards> createState() => _LeaderboardsState();
}

class _LeaderboardsState extends State<Leaderboards> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Leaderboards"),
      ),
      body: const Center(
        child: Text("Coming Soon"),
      ),
    );
  }
}
