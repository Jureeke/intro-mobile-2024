import 'package:flutter/material.dart';
import 'package:playtomic/src/services/auth_service.dart';

class HomeScreen extends StatelessWidget {
  final AuthService _authService = AuthService();
  static const routeName = '/';

  HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: _authService.getCurrentUserUsername(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Show a loading indicator while fetching data
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          // Show an error message if an error occurs
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          // Display the home page with the fetched username
          String welcomeText = "";
          if (snapshot.hasData) {
            welcomeText = 'Welcome, ${snapshot.data}';
          } else {
            welcomeText = 'you are not logged in';
          }
          return Scaffold(
            appBar: AppBar(
              title: const Text('Flutter Firebase Auth Demo'),
            ),
            body: Center(
              child: Text(
                welcomeText,
                style: const TextStyle(fontSize: 24),
              ),
            ),
          );
        }
      },
    );
  }
}
