import 'package:flutter/material.dart';

class PostsScreen extends StatelessWidget {
  static const routeName = '/home/profile/posts';
  const PostsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: const Center(
        child: Text('Posts Screen'),
      ),
    );
  }
}
