import 'package:flutter/material.dart';
import 'package:playtomic/src/services/auth_service.dart';

class EditPreferencesScreen extends StatefulWidget {
  static const routeName = '/home/profile/edit/preferences';

  @override
  _EditPreferencesScreenState createState() => _EditPreferencesScreenState();
}

class _EditPreferencesScreenState extends State<EditPreferencesScreen> {
  String? selectedBestHand;
  String? selectedBaanPositie;
  String? selectedTypePartij;

  @override
  void initState() {
    super.initState();
    // Laad de voorkeuren van de gebruiker bij het initialiseren van de state
    loadUserPreferences();
  }

  void loadUserPreferences() async {
    List<String>? userPreferences = await AuthService().loadUserPreferences(); // Roep de functie aan via de AuthService
    setState(() {
      selectedBestHand = userPreferences?[0];
      selectedBaanPositie = userPreferences?[1];
      selectedTypePartij = userPreferences?[2];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Preferences of player'),
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CustomCheckboxGroupWithLabel(
                label: 'Best hand',
                options: ['Right hand', 'Left hand', 'Both'],
                preferenceKey: 'best-hand',
                selectedValue: selectedBestHand,
                onChanged: (value) {
                  setState(() {
                    selectedBestHand = value;
                  });
                },
              ),
              SizedBox(height: 0),
              CustomCheckboxGroupWithLabel(
                label: 'Baanpositie',
                options: ['Backend', 'Forehand', 'Beide helften'],
                preferenceKey: 'baanpositie',
                selectedValue: selectedBaanPositie,
                onChanged: (value) {
                  setState(() {
                    selectedBaanPositie = value;
                  });
                },
              ),
              SizedBox(height: 30),
              CustomCheckboxGroupWithLabel(
                label: 'Type partij',
                options: ['Concurrederen', 'Vriendschappelijk', 'Beide'],
                preferenceKey: 'type-partij',
                selectedValue: selectedTypePartij,
                onChanged: (value) {
                  setState(() {
                    selectedTypePartij = value;
                  });
                },
              ),
              SizedBox(height: 10),
              Text(
                  'Competitief betekent dat de resultaten van de open wedstrijden meetellen voor de beoordeling van het niveau')
            ],
          ),
        ),
      ),
    );
  }
}

class CustomCheckboxGroupWithLabel extends StatelessWidget {
  final String label;
  final List<String> options;
  final String? preferenceKey;
  final String? selectedValue;
  final ValueChanged<String?> onChanged;

  CustomCheckboxGroupWithLabel({
    required this.label,
    required this.options,
    required this.preferenceKey,
    required this.selectedValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 20),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: List.generate(options.length, (index) {
            return Row(
              children: [
                CustomCheckbox(
                  text: options[index],
                  isSelected: options[index] == selectedValue,
                  onChanged: onChanged,
                  preferenceKey: preferenceKey,
                ),
                SizedBox(width: 10), // Extra ruimte tussen de checkboxen
              ],
            );
          }),
        ),
      ],
    );
  }
}

class CustomCheckbox extends StatelessWidget {
  final String text;
  final bool isSelected;
  final ValueChanged<String?> onChanged;
  final String? preferenceKey;
  final AuthService authService = AuthService();

  CustomCheckbox({
    required this.text,
    required this.isSelected,
    required this.onChanged,
    required this.preferenceKey,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onChanged(isSelected ? null : text);
        authService.saveUserPreferences({preferenceKey!: isSelected ? null : text});
      },
      child: Container(
        decoration: BoxDecoration(
          color: isSelected ? Colors.black : Colors.white,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: Colors.black,
            width: 1,
          ),
        ),
        padding: EdgeInsets.all(10),
        child: Text(
          text,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black,
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}
