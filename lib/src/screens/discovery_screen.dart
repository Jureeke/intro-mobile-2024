import 'package:flutter/widgets.dart';

class DiscoveryScreen extends StatelessWidget {
  static const routeName = '/home/discovery';
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Discover Screen',
        style: TextStyle(fontSize: 24),
      ),
    );
  }
}
