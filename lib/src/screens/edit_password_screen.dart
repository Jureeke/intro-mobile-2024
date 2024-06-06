import 'package:flutter/material.dart';

class EditPasswordScreen extends StatelessWidget {
  static const routeName = '/home/profile/edit/preferences';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Edit Password'),
        ),
        body: const Center(
          child: Text(
            'Edit Password Screen',
            style: TextStyle(fontSize: 24),
          ),
        ));
  }
}
