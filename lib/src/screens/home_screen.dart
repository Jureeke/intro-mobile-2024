import 'package:flutter/material.dart';
import 'package:playtomic/src/screens/community_screen.dart';
import 'package:playtomic/src/screens/discovery_screen.dart';
import 'package:playtomic/src/screens/play_screen.dart';
import 'package:playtomic/src/screens/profile_screen.dart';
import 'package:playtomic/src/services/auth_service.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = '/home';

  const HomeScreen({super.key});
  @override
  RegisterScreenState createState() => RegisterScreenState();
}

class RegisterScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  AuthService authService = AuthService();

  final List<Widget> _screens = [
    PlayScreen(),
    DiscoveryScreen(),
    CommunityScreen(),
    const ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.white,
        title: const Text(
          'Playtomic',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
              onPressed: () {
                authService.signOut();
                Navigator.of(context).pushNamedAndRemoveUntil(
                    '/start', (Route<dynamic> route) => false);
              },
              icon: Icon(Icons.logout, color: Colors.red))
        ],
      ),
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.sports_baseball_outlined),
            activeIcon: Icon(Icons.sports_baseball),
            label: 'Play',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.explore_outlined,
            ),
            activeIcon: Icon(Icons.explore),
            label: 'Discovery',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Community',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outlined),
            activeIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.black,
        selectedIconTheme: const IconThemeData(color: Colors.black, size: 30.0),
        unselectedIconTheme:
            const IconThemeData(color: Colors.grey, size: 30.0),
        showUnselectedLabels: true,
        selectedLabelStyle:
            const TextStyle(fontSize: 13.0, fontWeight: FontWeight.bold),
        unselectedLabelStyle: const TextStyle(fontSize: 13.0),
        onTap: _onItemTapped,
      ),
    );
  }
}
