import 'package:flutter/material.dart';

class ActivitiesScreen extends StatelessWidget {
  static const routeName = '/home/profile/activities';
  const ActivitiesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: const Center(
        child: Text('Activities Screen'),
      ),
    );
  }
}
