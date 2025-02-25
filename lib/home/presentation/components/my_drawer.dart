import 'package:flutter/material.dart';
import 'package:pickup/games/presentation/pages/game_list.dart';
import 'package:pickup/home/presentation/components/my_drawer_tile.dart';
import 'package:pickup/history/presentation/pages/journey_history_screen.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.black,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: Column(
            children: [
              //logo
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 50.0),
                child: Icon(
                  Icons.person,
                  size: 80,
                  color: Colors.white,
                ),
              ),
              //divider line
              Divider(
                color: Theme.of(context).colorScheme.secondary,
              ),
              //home title
              MyDrawerTile(
                title: "H O M E",
                icon: Icons.home,
                ontap: () {
                  Navigator.of(context).pop();
                },
              ),
              //profile tile
              MyDrawerTile(
                title: "H I S T O R Y",
                icon: Icons.local_taxi,
                ontap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const JourneyHistoryScreen()));
                },
              ),
              MyDrawerTile(
                title: "G A M E S",
                icon: Icons.gamepad,
                ontap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const GameList()));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
