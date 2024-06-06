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
    loadUserPreferences();
  }

  void loadUserPreferences() async {
    List<String>? userPreferences = await AuthService()
        .loadUserPreferences();
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
        padding: const EdgeInsets.all(20),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CustomCheckboxGroupWithLabel(
                label: 'Best hand',
                options: ['Right-handed', 'Left-handed', 'Both hands'],
                preferenceKey: 'best-hand',
                selectedValue: selectedBestHand,
                onChanged: (value) {
                  setState(() {
                    selectedBestHand = value;
                  });
                },
              ),
              const SizedBox(height: 0),
              CustomCheckboxGroupWithLabel(
                label: 'Court side',
                options: ['Backend', 'Forehand', 'Both sides'],
                preferenceKey: 'baanpositie',
                selectedValue: selectedBaanPositie,
                onChanged: (value) {
                  setState(() {
                    selectedBaanPositie = value;
                  });
                },
              ),
              const SizedBox(height: 30),
              CustomCheckboxGroupWithLabel(
                label: 'Match type',
                options: ['Competitive', 'Friendly', 'Both'],
                preferenceKey: 'type-partij',
                selectedValue: selectedTypePartij,
                onChanged: (value) {
                  setState(() {
                    selectedTypePartij = value;
                  });
                },
              ),
              const SizedBox(height: 10),
              const Text(
                  'The result of the match will count for your level progress if you make it competitive')
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
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 20),
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
                const SizedBox(width: 10),
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
        authService
            .saveUserPreferences({preferenceKey!: isSelected ? null : text});
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
        padding: const EdgeInsets.all(10),
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
