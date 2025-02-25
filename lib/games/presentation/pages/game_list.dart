import 'package:flutter/material.dart';
import 'package:pickup/games/presentation/pages/tic_tac_toe.dart';

class GameList extends StatelessWidget {
  const GameList({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Row(
          children: [
            Text(
              "Games",
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
            ),
            SizedBox(
              width: 5,
            ),
            Icon(
              Icons.games,
              color: Colors.white,
            ),
          ],
        ),
        backgroundColor: Colors.black,
      ),
      body: GestureDetector(
        onTap: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const TicTacToe()));
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              ListTile(
                  tileColor: Colors.amber[700],
                  title: const Text("Tic Tac Toe"),
                  trailing: const Icon(Icons.square)),
            ],
          ),
        ),
      ),
    );
  }
}
