import 'package:flutter/material.dart';

class CommunityScreen extends StatelessWidget {
  static const routeName = '/home/community';
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/under-construction-padel.png'),
            const SizedBox(height: 10),
            const Text('Oops!', style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold)),
            const SizedBox(height: 15),
            const Text(
              "Exciting news! We're currently working on one of our new features.\nStay tuned for more updates!",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
