import 'package:flutter/material.dart';

class EditPreferencesScreen extends StatelessWidget {
  static const routeName = '/home/profile/edit/preferences';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Edit Preferences'),
        ),
        body: Center(
          child: Text(
            'Edit Preferences Screen',
            style: TextStyle(fontSize: 24),
          ),
        ));
  }
}
