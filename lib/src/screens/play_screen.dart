import 'package:flutter/widgets.dart';

class PlayScreen extends StatelessWidget {
  static const routeName = '/home/play';
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Play Screen',
        style: TextStyle(fontSize: 24),
      ),
    );
  }
}
