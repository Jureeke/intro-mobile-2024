import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:playtomic/src/services/auth_service.dart';
import 'package:intl/intl.dart';

class ClubBookScreen extends StatefulWidget {
  final Map<String?, dynamic> clubData;
  final bool isPublic;
  const ClubBookScreen(
      {super.key, required this.clubData, required this.isPublic});

  @override
  ClubBookScreenState createState() => ClubBookScreenState();
}

class ClubBookScreenState extends State<ClubBookScreen> {
  AuthService authService = AuthService();
  late List<DocumentSnapshot<Map<String, dynamic>>> _reservations;
  late DateTime _selectedDate;
  String? _selectedTime;
  late int opens;
  late int closes;
  bool isReservationsLate = true;

  @override
  void initState() {
    super.initState();
    _fetchReservations();
    opens = widget.clubData['opens'];
    closes = widget.clubData['closes'] - 1;
    _selectedDate = DateTime.now();
    _selectedTime = '${opens.toString().padLeft(2, '0')}:00';
    _handleDateTap(_selectedDate, true);
    _handleTimeTap('${(_selectedDate.hour + 1).toString().padLeft(2, '0')}:00');
  }

  void _fetchReservations() async {
    List<DocumentSnapshot<Map<String, dynamic>>> reservations =
        await authService.getClubReservations(widget.clubData["id"]);
    setState(() {
      _reservations = reservations;
      isReservationsLate = false;
    });
  }

  bool hasReservation(DateTime date, String timeSlot) {
    if (isReservationsLate) {
      return false;
    }
    if (DateTime(
            date.year,
            date.month,
            date.day,
            int.parse(timeSlot.split(':')[0]),
            int.parse(timeSlot.split(':')[0]))
        .isBefore(DateTime.now())) {
      return true;
    }
    return _reservations.any((reservation) {
      DateTime reservationDate =
          (reservation.data()!['reservationDateTime'] as Timestamp).toDate();
      if (reservationDate.year == date.year &&
          reservationDate.month == date.month &&
          reservationDate.day == date.day) {
        if ('${reservationDate.hour.toString().padLeft(2, '0')}:${reservationDate.minute.toString().padLeft(2, '0')}' ==
            timeSlot) {
          return true;
        }
        reservationDate = reservationDate.add(const Duration(minutes: 30));
        if ('${reservationDate.hour.toString().padLeft(2, '0')}:${reservationDate.minute.toString().padLeft(2, '0')}' ==
            timeSlot) {
          return true;
        }
        reservationDate = reservationDate.add(const Duration(minutes: 30));
        if ('${reservationDate.hour.toString().padLeft(2, '0')}:${reservationDate.minute.toString().padLeft(2, '0')}' ==
            timeSlot) {
          return true;
        }
        reservationDate = reservationDate.add(const Duration(minutes: 30));
        if ('${reservationDate.hour.toString().padLeft(2, '0')}:${reservationDate.minute.toString().padLeft(2, '0')}' ==
            timeSlot) {
          return true;
        }
        reservationDate =
            reservationDate.subtract(const Duration(minutes: 120));
        if ('${reservationDate.hour.toString().padLeft(2, '0')}:${reservationDate.minute.toString().padLeft(2, '0')}' ==
            timeSlot) {
          return true;
        }
        reservationDate = reservationDate.subtract(const Duration(minutes: 30));
        if ('${reservationDate.hour.toString().padLeft(2, '0')}:${reservationDate.minute.toString().padLeft(2, '0')}' ==
            timeSlot) {
          return true;
        }
      }
      return false;
    });
  }

  void _handleDateTap(DateTime date, bool changeTime) {
    DateTime now = DateTime.now();
    if (opens < now.hour &&
        date.year == now.year &&
        date.month == now.month &&
        date.day == now.day) {
      opens = now.hour + 1;
    } else {
      opens = widget.clubData['opens'];
    }
    setState(() {
      _selectedDate = date;
      if (changeTime) {
        _selectedTime = '${opens.toString().padLeft(2, '0')}:00';
      }
    });
  }

  void _handleTimeTap(String time) {
    setState(() {
      _selectedTime = time;
    });
  }

  @override
  Widget build(BuildContext context) {
    DateTime currentDate = DateTime.now();
    DateTime threeMonthsLater = DateTime.now().add(const Duration(days: 100));

    List<Widget> dateWidgets = [];

    if (closes <= DateTime.now().hour + 1) {
      currentDate = DateTime.now().add(const Duration(days: 1));
      if (_selectedDate.isBefore(currentDate)) {
        _handleDateTap(currentDate, false);
      }
    }

    while (currentDate.isBefore(threeMonthsLater)) {
      DateTime date = currentDate;
      dateWidgets.add(
        GestureDetector(
          onTap: () {
            setState(() {
              _selectedDate = date;
            });
            _handleDateTap(date, true);
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: Column(
                children: [
                  Text(
                    DateFormat.E().format(date),
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: date.year == _selectedDate.year &&
                              date.month == _selectedDate.month &&
                              date.day == _selectedDate.day
                          ? Colors.black
                          : Colors.transparent,
                      shape: BoxShape.circle,
                    ),
                    padding: const EdgeInsets.all(10),
                    child: Text(
                      DateFormat.d().format(date),
                      style: TextStyle(
                        fontSize: 14,
                        color: date.year == _selectedDate.year &&
                                date.month == _selectedDate.month &&
                                date.day == _selectedDate.day
                            ? Colors.white
                            : Colors.black,
                      ),
                    ),
                  ),
                  Text(
                    DateFormat.MMM().format(date),
                    style: const TextStyle(
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
      currentDate = currentDate.add(const Duration(days: 1));
    }

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 245, 245, 245),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                height: 125,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: dateWidgets,
                ),
              ),
              Wrap(
                spacing: 5.0,
                runSpacing: 5.0,
                children: List.generate(
                  (closes - opens) * 2,
                  (index) {
                    int hour = opens + (index ~/ 2);
                    int minute = (index % 2) * 30;
                    String time =
                        '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedTime = time;
                        });
                        _handleTimeTap(time);
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5.0),
                              border: hasReservation(_selectedDate, time)
                                  ? null
                                  : Border.all(color: Colors.black38),
                              color: _selectedTime != null &&
                                      time == _selectedTime
                                  ? Colors.black
                                  : hasReservation(_selectedDate, time)
                                      ? const Color.fromARGB(240, 255, 255, 255)
                                      : Colors.white,
                            ),
                            padding: const EdgeInsets.all(10),
                            child: Text(
                              time,
                              style: TextStyle(
                                decoration: hasReservation(_selectedDate, time)
                                    ? TextDecoration.lineThrough
                                    : TextDecoration.none,
                                fontSize: 14,
                                color: _selectedTime != null &&
                                        time == _selectedTime
                                    ? Colors.white
                                    : hasReservation(_selectedDate, time)
                                        ? const Color.fromARGB(150, 0, 0, 0)
                                        : Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 15.0),
              ElevatedButton(
                onPressed: hasReservation(_selectedDate, _selectedTime!)
                    ? null
                    : () async {
                        try {
                          await authService.bookCourt(
                              widget.clubData["id"],
                              1,
                              widget.isPublic,
                              DateTime(
                                  _selectedDate.year,
                                  _selectedDate.month,
                                  _selectedDate.day,
                                  int.parse(_selectedTime!.split(':')[0]),
                                  int.parse(_selectedTime!.split(':')[1])));
                          _fetchReservations();
                        } catch (error) {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('booking court Error'),
                              content: Text(error.toString()),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text('OK'),
                                ),
                              ],
                            ),
                          );
                        }
                      },
                child: const Text("Book Court"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
