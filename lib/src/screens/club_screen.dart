import 'package:flutter/material.dart';
import 'package:playtomic/src/screens/club_book_screen.dart';
import 'package:playtomic/src/screens/club_competitions_screen.dart';
import 'package:playtomic/src/screens/club_home_screen.dart';

class ClubScreen extends StatelessWidget {
  final Map<String, dynamic> clubData;

  const ClubScreen({super.key, required this.clubData});

  @override
  Widget build(BuildContext context) {
    final List<Widget> screens = [
      const ClubHomeScreen(),
      ClubBookScreen(clubData: clubData, isPublic: false),
      const ClubCompetitionsScreen(),
    ];

    return DefaultTabController(
      initialIndex: 1,
      length: screens.length,
      child: Scaffold(
        body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return [
              SliverAppBar(
                toolbarHeight: 0,
                backgroundColor: const Color.fromARGB(255, 255, 255, 255),
                surfaceTintColor: const Color.fromARGB(255, 255, 255, 255),
                expandedHeight: 125,
                centerTitle: true,
                flexibleSpace: FlexibleSpaceBar(
                  background: Image.network(
                    clubData['image'],
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ];
          },
          body: Scaffold(
            backgroundColor: const Color.fromARGB(255, 245, 245, 245),
            appBar: AppBar(
              toolbarHeight: 50,
              title: Text(clubData['name']),
              surfaceTintColor: Colors.white,
              bottom: TabBar(
                tabs: const [
                  Tab(text: 'Home'),
                  Tab(text: 'Book'),
                  Tab(text: 'Competitions'),
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
        ),
      ),
    );
  }
}
