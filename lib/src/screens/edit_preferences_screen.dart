import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class EditPreferencesScreen extends StatelessWidget {
  static const routeName = '/home/profile/edit/preferences';
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
                options: ['Right hand', 'Left hand', 'Both']),
              SizedBox(height: 0),
              CustomCheckboxGroupWithLabel(
                label: 'Baanpositie', 
                options: ['Backend', 'Forehand', 'Beide helften']),
              SizedBox(height: 30),
              CustomCheckboxGroupWithLabel(
                label: 'Type partij', 
                options: ['Concurrederen', 'Vriendschappelijk', 'Beide']),
              SizedBox(height: 10),
              Text('Competitief betekent dat de resultaten van de open wedstrijden meetellen voor de beoordeling van het niveau')
            ],
          )),
        ));
  }
}

class CustomCheckboxGroupWithLabel extends StatelessWidget {
  final String label;
  final List<String> options;

  CustomCheckboxGroupWithLabel({required this.label, required this.options});

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
                CustomCheckbox(text: options[index]),
                SizedBox(width: 10), // Extra ruimte tussen de checkboxen
              ],
            );
          }),
        ),
      ],
    );
  }
}

class CustomCheckbox extends StatefulWidget {
  final String text;

  CustomCheckbox({required this.text});

  @override
  _CustomCheckboxState createState() => _CustomCheckboxState();
}

class _CustomCheckboxState extends State<CustomCheckbox> {
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          isChecked = !isChecked;
        });
      },
      child: Container(
        decoration: BoxDecoration(
          color: isChecked ? Colors.black : Colors.white,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: Colors.black,
            width: 1,
          ),
        ),
        padding: EdgeInsets.all(10),
        child: Text(
          widget.text,
          style: TextStyle(color: isChecked ? Colors.white : Colors.black, fontSize: 12),
        ),
      ),
    );
  }
}