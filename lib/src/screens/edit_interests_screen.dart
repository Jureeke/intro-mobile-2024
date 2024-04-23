import 'package:flutter/material.dart';

class EditInterestsScreen extends StatelessWidget {
  static const routeName = '/home/profile/edit/interests';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Edit Interests'),
        ),
        body: Center(
          child: Text(
            'Edit Interests Screen',
            style: TextStyle(fontSize: 24),
          ),
        ));
  }
}
