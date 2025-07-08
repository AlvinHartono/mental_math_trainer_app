import 'package:flutter/material.dart';
import 'package:mental_math_trainer_app/widgets/leaderboard_shimmer.dart'; // Import the new shimmer widget

class Leaderboards extends StatefulWidget {
  const Leaderboards({super.key});

  @override
  State<Leaderboards> createState() => _LeaderboardsState();
}

class _LeaderboardsState extends State<Leaderboards> {
  bool _isLoading = true; // Set to true initially to show shimmer
  List<Map<String, dynamic>> _leaderboardData = [];

  @override
  void initState() {
    super.initState();
    _loadLeaderboardData();
  }

  Future<void> _loadLeaderboardData() async {
    // Simulate a network delay
    await Future.delayed(const Duration(seconds: 3));
    if (mounted) {
      setState(() {
        _leaderboardData = [
          {'rank': 1, 'name': 'PlayerOne', 'score': 1500},
          {'rank': 2, 'name': 'PlayerTwo', 'score': 1200},
          {'rank': 3, 'name': 'PlayerThree', 'score': 1000},
          {'rank': 4, 'name': 'PlayerFour', 'score': 950},
          {'rank': 5, 'name': 'PlayerFive', 'score': 800},
        ];
        _isLoading = false; // Hide shimmer once data is loaded
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? const LeaderboardShimmer() // Show shimmer while loading
        : Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: const Text(
                "Leaderboards",
                style: TextStyle(color: Colors.white),
              ),
              backgroundColor: const Color.fromARGB(255, 52, 103, 178),
            ),
            backgroundColor: const Color.fromARGB(255, 52, 103, 178),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // Example of a top player card (you can customize this)
                  _leaderboardData.isNotEmpty
                      ? Card(
                          color: Colors.yellow[700],
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              children: [
                                Text(
                                  '🏆 Top Player 🏆',
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.deepOrange[900],
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  '${_leaderboardData[0]['name']} - ${_leaderboardData[0]['score']}',
                                  style: const TextStyle(
                                    fontSize: 20,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      : Container(),
                  const SizedBox(height: 20),
                  Expanded(
                    child: ListView.builder(
                      itemCount: _leaderboardData.length,
                      itemBuilder: (context, index) {
                        final entry = _leaderboardData[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          elevation: 3,
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Theme.of(context).primaryColor,
                              child: Text('${entry['rank']}', //
                                  style: const TextStyle(color: Colors.white)),
                            ),
                            title: Text(
                              entry['name'], //
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                            trailing: Text(
                              'Score: ${entry['score']}', //
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Colors.green),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}
