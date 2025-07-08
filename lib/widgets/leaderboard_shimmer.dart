import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class LeaderboardShimmer extends StatelessWidget {
  const LeaderboardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 52, 103, 178),
      appBar: AppBar(
        title: const Text(
          "Leaderboards",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 52, 103, 178),
      ),
      body: Shimmer.fromColors(
        baseColor: Colors.grey[200]!,
        highlightColor: Colors.grey[400]!,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 120,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                ),
                margin: const EdgeInsets.only(bottom: 20),
              ),
              // Shimmer for Leaderboard List Items
              Expanded(
                  child: ListView.builder(
                itemCount: 8,
                itemBuilder: (context, index) {
                  return Container(
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    margin: const EdgeInsets.only(bottom: 10),
                  );
                },
              ))
            ],
          ),
        ),
      ),
    );
  }
}
