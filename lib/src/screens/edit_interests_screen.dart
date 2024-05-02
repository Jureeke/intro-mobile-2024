import 'package:flutter/material.dart';

class EditInterestsScreen extends StatefulWidget {
  static const routeName = '/home/profile/edit/interests';

  @override
  _EditInterestsScreenState createState() => _EditInterestsScreenState();
}

class _EditInterestsScreenState extends State<EditInterestsScreen> {
  late List<bool> selectedIndices;

  final List<Option> options = [
    Option(name: 'Mijn voortgang bijhouden', icon: Icons.accessibility),
    Option(name: 'Mijn speelniveau kennen', icon: Icons.favorite_border),
    Option(name: 'Ontdek de gemeenschap', icon: Icons.access_time),
    Option(name: 'Reserveer een baan', icon: Icons.airplanemode_active),
    Option(name: 'Concurreren met anderen', icon: Icons.attach_money),
    Option(name: 'Spelen met mijn vrienden', icon: Icons.heat_pump_rounded),
    Option(name: 'Zoek mensen om mee te spelen', icon: Icons.cake),
  ];

  @override
  void initState() {
    super.initState();
    selectedIndices = List.generate(options.length, (index) => false);
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
            Text(
              'Je interesse',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Wat zoek je in Playtomic',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: GridView.count(
                crossAxisCount: 1,
                childAspectRatio: 7.5, // Hoogte van de kaders
                children: List.generate(options.length, (index) {
                  return InkWell(
                    onTap: () {
                      setState(() {
                        selectedIndices[index] = !selectedIndices[index];
                      });
                    },
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: 5),
                      decoration: BoxDecoration(
                        color: Colors.white, // Achtergrondkleur wit
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: selectedIndices[index]
                              ? Colors.blue // Blauwe rand als geselecteerd
                              : Colors.grey[300]!, // Lichtgrijze rand
                        ),
                      ),
                      padding: EdgeInsets.all(10), // Padding toevoegen
                      child: Row(
                        children: [
                          SizedBox(width: 10),
                          Icon(options[index].icon), // Pictogram toevoegen
                          SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              options[index].name, // Naam toevoegen
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                          SizedBox(width: 10),
                          if (selectedIndices[index])
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
              width: double.infinity, // Neemt volledige breedte in
              child: ElevatedButton(
                onPressed: () {
                  // Voeg hier de actie toe die moet worden uitgevoerd wanneer de knop wordt ingedrukt
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue, // Achtergrondkleur blauw
                ),
                child: Text(
                  'Opslaan',
                  style: TextStyle(color: Colors.white, fontSize: 20), // Tekst wit
                ),
              ),
            ),
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
