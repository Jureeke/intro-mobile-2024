import 'package:flutter/material.dart';
import 'package:playtomic/src/screens/book_a_court_screen.dart';
import 'package:playtomic/src/screens/play_open_match_screen.dart';

class PlayScreen extends StatelessWidget {
  const PlayScreen({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              "Find your perfect match",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10.0),
            Row(
              children: [
                _buildGestureDetector(
                  context: context,
                  imagePath: 'assets/images/book_a_court.jpg',
                  title: 'Book a court',
                  subtitle: 'If you already know who you are playing with',
                  icon: const Icon(Icons.search, color: Colors.white),
                  screen: const BookACourtScreen(isPublic: false),
                ),
                const SizedBox(width: 10.0),
                _buildGestureDetector(
                  context: context,
                  imagePath: 'assets/images/play_open_match.jpg',
                  title: 'Play an open match',
                  subtitle: 'If you are looking for players at your level',
                  icon: const Icon(Icons.sports_baseball_outlined,
                      color: Colors.white),
                  screen: const PlayOpenMatchScreen(),
                ),
              ],
            ),
            const SizedBox(
                height: 20.0),
            Expanded(
              child: Image.asset(
                'assets/images/padel-player.png',
                fit: BoxFit.contain,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGestureDetector({
    required BuildContext context,
    required String imagePath,
    required String title,
    required String subtitle,
    required Widget icon,
    required Widget screen,
  }) {
    return Expanded(
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => screen),
          );
        },
        splashFactory: NoSplash.splashFactory,
        splashColor: Colors.grey,
        borderRadius: BorderRadius.circular(10.0),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            border: Border.all(
              color: const Color.fromARGB(52, 0, 0, 0),
              width: 1.0,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: 100,
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(10.0),
                    topRight: Radius.circular(10.0),
                  ),
                  child: Image.asset(
                    imagePath,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsetsDirectional.all(10.0),
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 30.0),
                        Text(
                          title,
                          style: const TextStyle(
                            fontSize: 15.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 5.0),
                        Text(
                          subtitle,
                          style: const TextStyle(
                            fontSize: 13.0,
                          ),
                        ),
                      ],
                    ),
                    Positioned(
                      top: -32.5,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        padding: const EdgeInsets.all(10.0),
                        child: icon,
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
