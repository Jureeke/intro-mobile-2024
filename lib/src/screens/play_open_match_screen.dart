import 'package:flutter/material.dart';
import 'package:playtomic/src/screens/available_matches_screen.dart';
import 'package:playtomic/src/screens/your_matches_screen.dart';

class PlayOpenMatchScreen extends StatelessWidget {
  final bool isPublic = true;

  const PlayOpenMatchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Widget> screens = [
      const AvailableMatchesScreen(),
      const YourMatchesScreen(),
    ];

    return DefaultTabController(
      length: screens.length,
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 245, 245, 245),
        appBar: AppBar(
          toolbarHeight: 50,
          title: Text("Matches"),
          surfaceTintColor: Colors.white,
          bottom: TabBar(
            tabs: const [
              Tab(text: 'Available'),
              Tab(text: 'Your matches'),
            ],
            overlayColor: MaterialStateProperty.all(Colors.transparent),
            indicatorSize: TabBarIndicatorSize.tab,
            indicatorColor: Colors.black,
            labelStyle: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black,
              fontSize: 15.0,
            ),
            unselectedLabelStyle: const TextStyle(
              fontWeight: FontWeight.normal,
              color: Colors.black,
              fontSize: 15.0,
            ),
          ),
        ),
        body: TabBarView(
          physics: const NeverScrollableScrollPhysics(),
          children: screens,
        ),
      ),
    );
  }
}
