import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:playtomic/src/screens/book_a_court_screen.dart';
import 'package:playtomic/src/services/auth_service.dart';

class AvailableMatchesScreen extends StatefulWidget {
  const AvailableMatchesScreen({super.key});

  @override
  AvailableMatchesScreenState createState() => AvailableMatchesScreenState();
}

class AvailableMatchesScreenState extends State<AvailableMatchesScreen> {
  AuthService authService = AuthService();
  late Future<List<Map<String, dynamic>>> _reservations;

  @override
  void initState() {
    super.initState();
    _reservations = authService.getAllPublicReservations();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 245, 245, 245),
      floatingActionButton: SizedBox(
        height: 30.0,
        child: FloatingActionButton.extended(
          extendedPadding:
              const EdgeInsetsDirectional.only(start: 16.0, end: 20.0),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const BookACourtScreen(
                  isPublic: true,
                ),
              ),
            );
          },
          icon: const Icon(Icons.add, color: Colors.white, size: 20.0),
          label: const Text('Start a match',
              style: TextStyle(color: Colors.white)),
          backgroundColor: const Color.fromARGB(255, 0, 55, 255),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _reservations,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasData) {
            List<Map<String, dynamic>> reservations = snapshot.data!;
            return ListView.builder(
              itemCount: reservations.length,
              itemBuilder: (context, index) {
                Map<String, dynamic> reservation = reservations[index];
                DateTime reservationDate =
                    (reservation['reservationDateTime'] as Timestamp).toDate();
                String clubName = reservation['club']['name'];
                return Container(
                  margin:
                      const EdgeInsets.symmetric(vertical: 6, horizontal: 14),
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${DateFormat.E().format(reservationDate)} ${DateFormat.d().format(reservationDate)} ${DateFormat.MMM().format(reservationDate)} | ${DateFormat.Hm().format(reservationDate)}",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      ParentWidget(
                        reservation: reservation,
                      ),
                      const SizedBox(height: 10),
                      Text(clubName),
                    ],
                  ),
                );
              },
            );
          } else {
            return const Center(
              child: Text(
                "no matches available",
                style: TextStyle(fontSize: 24),
              ),
            );
          }
        },
      ),
    );
  }
}

class ParentWidget extends StatefulWidget {
  final Map<String, dynamic> reservation;
  const ParentWidget({super.key, required this.reservation});

  @override
  ParentWidgetState createState() => ParentWidgetState();
}

class ParentWidgetState extends State<ParentWidget> {
  AuthService authService = AuthService();
  late bool isUserInMatch; // Shared state among widgets

  @override
  void initState() {
    super.initState();
    isUserInMatch = amIinMatch();
  }

  void updateSharedState(bool newState) {
    setState(() {
      isUserInMatch = newState;
    });
  }

  bool amIinMatch() {
    User? user = authService.getUser();
    if (user != null) {
      DocumentReference? userHomeLeftRef =
          widget.reservation['userHomeLeftRef'];
      DocumentReference? userHomeRightRef =
          widget.reservation['userHomeRightRef'];
      DocumentReference? userAwayLeftRef =
          widget.reservation['userAwayLeftRef'];
      DocumentReference? userAwayRightRef =
          widget.reservation['userAwayRightRef'];
      if (userHomeLeftRef != null) {
        if (userHomeLeftRef.id == user.uid) {
          return true;
        }
      }
      if (userHomeRightRef != null) {
        if (userHomeRightRef.id == user.uid) {
          return true;
        }
      }
      if (userAwayLeftRef != null) {
        if (userAwayLeftRef.id == user.uid) {
          return true;
        }
      }
      if (userAwayRightRef != null) {
        if (userAwayRightRef.id == user.uid) {
          return true;
        }
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        InitialsAvatarWidget(
          reservation: widget.reservation,
          position: 'userHomeLeft',
          isUserInMatch: isUserInMatch,
          updateState: updateSharedState,
        ),
        InitialsAvatarWidget(
          reservation: widget.reservation,
          position: 'userHomeRight',
          isUserInMatch: isUserInMatch,
          updateState: updateSharedState,
        ),
        InitialsAvatarWidget(
          reservation: widget.reservation,
          position: 'userAwayLeft',
          isUserInMatch: isUserInMatch,
          updateState: updateSharedState,
        ),
        InitialsAvatarWidget(
          reservation: widget.reservation,
          position: 'userAwayRight',
          isUserInMatch: isUserInMatch,
          updateState: updateSharedState,
        ),
      ],
    );
  }
}

class InitialsAvatarWidget extends StatefulWidget {
  final Map<String, dynamic> reservation;
  final String position;
  final bool isUserInMatch;
  final Function(bool) updateState;

  const InitialsAvatarWidget({
    super.key,
    required this.reservation,
    required this.position,
    required this.isUserInMatch,
    required this.updateState,
  });

  @override
  InitialsAvatarWidgetState createState() => InitialsAvatarWidgetState();
}

class InitialsAvatarWidgetState extends State<InitialsAvatarWidget> {
  AuthService authService = AuthService();
  late String username;
  late bool isReserved;

  @override
  void initState() {
    super.initState();
    initializeData();
  }

  void initializeData() {
    isReserved = widget.reservation.containsKey(widget.position);
    if (isReserved) {
      username = widget.reservation[widget.position]['username'];
    } else {
      username = 'test123';
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isReserved || widget.isUserInMatch
          ? () {
              if (!isReserved) {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text("already joined"),
                      content: const Text(
                          "You cannot join this match because you have already joined this match"),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop(false);
                          },
                          child: const Text("Ok"),
                        ),
                      ],
                    );
                  },
                );
              }
            }
          : () async {
              bool joinConfirmed = await showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text("Join Match"),
                    content:
                        const Text("Are you sure you want to join this match?"),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(false);
                        },
                        child: const Text("Cancel"),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(true);
                        },
                        child: const Text("Join"),
                      ),
                    ],
                  );
                },
              );
              if (joinConfirmed == true) {
                try {
                  await authService.joinMatch(widget.reservation['id'],
                      {"${widget.position}Ref": authService.getUserRef()});
                  setState(() {
                    widget.updateState(true);
                    isReserved = true;
                    User? user = authService.getUser();
                    if (user != null) {
                      String? displayName = user.displayName;
                      if (displayName != null) {
                        username = displayName;
                      }
                    }
                  });
                } catch (error) {
                  null;
                }
              }
            },
      child: SizedBox(
        width: 60,
        child: Column(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isReserved ? Colors.black : Colors.white,
                border: Border.all(
                  color: const Color.fromARGB(90, 63, 81, 181),
                  width: 1.5,
                ),
              ),
              child: isReserved
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          extractInitials(username)[0],
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w200,
                          ),
                        ),
                        const SizedBox(width: 2.5),
                        Text(
                          extractInitials(username)[1],
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w200,
                          ),
                        ),
                      ],
                    )
                  : const Center(
                      child: Icon(
                        Icons.add,
                        size: 25,
                        color: Colors.indigo,
                      ),
                    ),
            ),
            const SizedBox(height: 2),
            isReserved
                ? Text(
                    username,
                    overflow: TextOverflow.ellipsis,
                  )
                : const Text(
                    'Available',
                    style: TextStyle(
                      color: Colors.indigo,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
          ],
        ),
      ),
    );
  }

  String extractInitials(String name) {
    String initials = '';

    if (name.isNotEmpty) {
      var nameParts = name.split(' ');
      if (nameParts.length > 1) {
        initials = nameParts[0][0] + nameParts[1][0];
      } else {
        initials = name.substring(0, 2);
      }
    }
    return initials.toUpperCase();
  }
}
