import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:playtomic/src/screens/club_screen.dart';
import 'package:playtomic/src/services/auth_service.dart';

class BookACourtScreen extends StatefulWidget {
  const BookACourtScreen({super.key});

  @override
  BookACourtScreenState createState() => BookACourtScreenState();
}

class BookACourtScreenState extends State<BookACourtScreen> {
  AuthService authService = AuthService();
  late Future<List<DocumentSnapshot<Map<String, dynamic>>>> _clubsFuture;

  @override
  void initState() {
    super.initState();
    _clubsFuture = authService.getClubs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Book a Court'),
      ),
      body: FutureBuilder<List<DocumentSnapshot<Map<String, dynamic>>>>(
        future: _clubsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          List<DocumentSnapshot<Map<String, dynamic>>> clubs = snapshot.data!;
          return ListView.builder(
            itemCount: clubs.length,
            itemBuilder: (context, index) {
              Map<String, dynamic> clubData = {
                'id': clubs[index].id,
                ...clubs[index].data()!,
              };
              String clubName = clubData['name'];
              String imageUrl = clubData['image'];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ClubScreen(clubData: clubData),
                    ),
                  );
                },
                child: Column(
                  children: [
                    Container(
                      height: 15,
                      decoration: BoxDecoration(color: Colors.grey[300]),
                    ),
                    MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: Stack(
                        alignment: Alignment.bottomLeft,
                        children: [
                          Container(
                            height: 200,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: NetworkImage(imageUrl),
                                fit: BoxFit.cover,
                              ),
                            ),
                            child: Container(
                              color: Colors.black.withOpacity(0.3),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  clubName,
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
