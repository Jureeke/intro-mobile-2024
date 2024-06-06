import 'package:flutter/material.dart';

class ActivitiesScreen extends StatefulWidget {
  static const routeName = '/home/profile/activities';

  final Map<String, dynamic>? preferences;
  const ActivitiesScreen({super.key, required this.preferences});

  @override
  _ActivitiesScreenState createState() => _ActivitiesScreenState();
}

class _ActivitiesScreenState extends State<ActivitiesScreen> {
  late String bestHand;
  late String courtPosition;
  late String matchType;

  @override
  void initState() {
    super.initState();
    bestHand = widget.preferences?['best-hand'] ?? 'Not known';
    courtPosition = widget.preferences?['baanpositie'] ?? 'Not known';
    matchType = widget.preferences?['type-partij'] ?? 'Not known';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 245, 245, 245),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              const Text(
                'Level Progression',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 20),
              Container(
                width: double.infinity,
                height: 400, 
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey), 
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Image.network(
                  'https://cdn.discordapp.com/attachments/1170165735306313811/1248409767190462577/IMG_2443.png?ex=66638fb2&is=66623e32&hm=1f1fed2e62416622cdb89030d6f9f7e2bca491fa92f736feb79fc6f6a05ce4d5&',
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 50),
              const Text(
                'Player Preferences',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 20),
              _buildPreferenceCard('👋', 'Best hand', bestHand),
              _buildPreferenceCard('📍', 'Court position', courtPosition),
              _buildPreferenceCard('🥇', 'Match type', matchType),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPreferenceCard(String emoji, String title, String subtitle) {
    return Card(
      color: Colors.white,
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 10),
      shape: RoundedRectangleBorder(
        side: BorderSide(color: Colors.grey[300]!, width: 1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              emoji,
              style: const TextStyle(fontSize: 28),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
