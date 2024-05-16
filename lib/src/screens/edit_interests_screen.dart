import 'package:flutter/material.dart';
import 'package:playtomic/src/services/auth_service.dart';

class EditInterestsScreen extends StatefulWidget {
  static const routeName = '/home/profile/edit/interests';

  @override
  _EditInterestsScreenState createState() => _EditInterestsScreenState();
}

class _EditInterestsScreenState extends State<EditInterestsScreen> {
  late List<String> selectedInterests;
  final AuthService _authService = AuthService();
  bool isLoading = true;
  String errorMessage = '';

  final List<Option> options = [
    Option(name: 'Discover the community', icon: Icons.chat),
    Option(name: 'Compete with others', icon: Icons.emoji_events),
    Option(name: 'Play with my friends', icon: Icons.favorite),
    Option(name: 'Find out my level of play', icon: Icons.signal_cellular_alt),
    Option(name: 'Track my progress', icon: Icons.trending_up),
    Option(name: 'Book a court', icon: Icons.search),
    Option(name: 'Find people to play with', icon: Icons.group),
  ];

  @override
  void initState() {
    super.initState();
    selectedInterests = [];
    _loadInterests();
  }

  Future<void> _loadInterests() async {
    try {
      List<String>? interests = await _authService.loadUserInterests();
      if (interests != null) {
        setState(() {
          selectedInterests = interests;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage =
            'Er is een fout opgetreden bij het laden van de interesses: $e';
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _saveInterests() async {
    setState(() {
      isLoading = true;
    });

    try {
      await _authService.saveUserInterests(selectedInterests);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Interesses succesvol opgeslagen!'),
      ));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
            'Er is een fout opgetreden bij het opslaan van de interesses: $e'),
      ));
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (isLoading) const Center(child: CircularProgressIndicator()),
            if (!isLoading) ...[
              const Text(
                'Your interests',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              const Text(
                'What are you looking for in Playtomic?',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 20),
              Expanded(
                child: GridView.count(
                  crossAxisCount: 1,
                  childAspectRatio: 7.5,
                  children: List.generate(options.length, (index) {
                    return InkWell(
                      onTap: () {
                        setState(() {
                          if (selectedInterests.contains(options[index].name)) {
                            selectedInterests.remove(options[index].name);
                          } else {
                            selectedInterests.add(options[index].name);
                          }
                        });
                      },
                      child: Container(
                        margin: EdgeInsets.symmetric(vertical: 5),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color:
                                selectedInterests.contains(options[index].name)
                                    ? Colors.blue
                                    : Colors.grey[300]!,
                          ),
                        ),
                        padding: EdgeInsets.all(10),
                        child: Row(
                          children: [
                            SizedBox(width: 10),
                            Icon(options[index].icon),
                            SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                options[index].name,
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                            SizedBox(width: 10),
                            if (selectedInterests.contains(options[index].name))
                              Icon(Icons.check, color: Colors.blue),
                          ],
                        ),
                      ),
                    );
                  }),
                ),
              ),
              SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _saveInterests,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                  ),
                  child: const Text(
                    'Save',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
              ),
              if (errorMessage.isNotEmpty) ...[
                SizedBox(height: 20),
                Text(
                  errorMessage,
                  style: TextStyle(color: Colors.red),
                ),
              ]
            ]
          ],
        ),
      ),
    );
  }
}

class Option {
  final String name;
  final IconData icon;

  Option({required this.name, required this.icon});
}
