import 'package:flutter/material.dart';

class ClubCompetitionsScreen extends StatelessWidget {
  static const routeName = '/home/profile/posts';
  const ClubCompetitionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Image.asset('assets/images/oops.png'),
            const SizedBox(height: 10),
            const Text('Oops, It seems there are no competitions at this club'),
          ],
        ),
      ),
    );
  }
}
