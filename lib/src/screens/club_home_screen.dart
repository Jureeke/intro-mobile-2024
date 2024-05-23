import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ClubHomeScreen extends StatefulWidget {
  static const routeName = '/home/profile/posts';

  final Map<String?, dynamic> clubData;
  const ClubHomeScreen({Key? key, required this.clubData}) : super(key: key);

  @override
  _ClubHomeScreenState createState() => _ClubHomeScreenState();
}

class _ClubHomeScreenState extends State<ClubHomeScreen> {
  late int opens;
  late int closes;
  late GeoPoint location;
  late String name;
  late Map<String, dynamic> addressData; 

  //Adress
  late GoogleMapController mapController;

  late LatLng _center; // Your specified coordinates
  final Set<Marker> _markers = {};

    @override
  void initState() {
    super.initState();
    opens = widget.clubData['opens'];
    closes = widget.clubData['closes'];
    location = widget.clubData['location'];
    _center = LatLng(location.latitude, location.longitude);
    name = widget.clubData['name'];
    var address = widget.clubData['address'] as Map<String, dynamic>;
    addressData = {
      'city': address['city'],
      'street': address['street'],
      'zipcode': address['zipcode'],
    };
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    _addMarker();
  }

  void _addMarker() {
    setState(() {
      _markers.add(
        Marker(
          markerId: MarkerId(name),
          position: _center,
          infoWindow: InfoWindow(
            title: name,
            snippet: '${addressData['street']}<br> ${addressData['city']} ${addressData['zipcode']}'
        ),
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 245, 245, 245),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Club information',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            const Row(
              children: [
                Icon(Icons.sports_tennis, size: 25),
                SizedBox(width: 10),
                Text(
                  'Padel',
                  style: TextStyle(fontSize: 15),
                ),
              ],
            ),
            SizedBox(height: 25),
            Text(
              '1 court(s) available',
              style: TextStyle(fontSize: 15),
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildCircleIcon(Icons.turn_right, 'ROUTE'),
                _buildCircleIcon(Icons.public, 'WEB'),
                _buildCircleIcon(Icons.call, 'CALL'),
              ],
            ),
            const SizedBox(height: 20),
            Container(
              height: 300,
              width: double.infinity,
              color: Colors.grey[300],
              child: GoogleMap(
                onMapCreated: _onMapCreated,
                initialCameraPosition: CameraPosition(
                  target: _center,
                  zoom: 12.0,
                ),
                markers: _markers,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Opening Hours',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Monday - Sunday:',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
                Text(
                  '${_formatTime(opens)} - ${_formatTime(closes)}',
                  style: const TextStyle(fontSize: 15),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCircleIcon(IconData iconData, String text) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
            border: Border.all(color: Colors.black, width: 1),
          ),
          padding: const EdgeInsets.all(16),
          child: Icon(iconData, size: 25, color: Colors.black),
        ),
        const SizedBox(height: 5),
        Text(text),
      ],
    );
  }

  String _formatTime(int time) {
    String hour = time.toString().padLeft(2, '0');
    return '$hour:00';
  }
}
