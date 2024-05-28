import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:playtomic/src/screens/edit_interests_screen.dart';
import 'package:playtomic/src/screens/edit_password_screen.dart';
import 'package:playtomic/src/screens/edit_preferences_screen.dart';
import 'package:playtomic/src/services/auth_service.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  static const routeName = '/home/profile/edit';

  @override
  EditProfileScreenState createState() => EditProfileScreenState();
}

class EditProfileScreenState extends State<EditProfileScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();

  final AuthService _authService = AuthService();

  @override
  void initState() {
    super.initState();
    populateControllers();
  }

  void populateControllers() async {
    DocumentSnapshot<Map<String, dynamic>>? userInfo =
        await _authService.getUserInfo();
    if (userInfo != null) {
      setState(() {
        _nameController.text = userInfo.data()?['username'] ?? '';
        _emailController.text = userInfo.data()?['email'] ?? '';
        _phoneController.text = userInfo.data()?['mobile'] ?? '';
        _genderController.text = userInfo.data()?['gender'] ?? '';
        _dateController.text = userInfo.data()?['dateOfBirth'] ?? '';
        _descriptionController.text = userInfo.data()?['description'] ?? '';
        _locationController.text = userInfo.data()?['location'] ?? '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Center(child: Text('Edit profile')),
          actions: [
            TextButton(
              onPressed: () async {
                try {
                  await _authService.updateUserInfo(
                      _nameController.text,
                      _emailController.text,
                      _phoneController.text,
                      _genderController.text,
                      _dateController.text,
                      _descriptionController.text,
                      _locationController.text);
                } catch (error) {
                  // Handle any errors
                }
              },
              child: const Text(
                'Save',
                style: TextStyle(color: Colors.indigo, fontSize: 16.0),
              ),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const CircleAvatar(
                        backgroundImage: NetworkImage(
                            'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRw6CURm0X8IN4G7dKWPwO7AI9l9dV61vZZYeGT-Huytw&s'),
                        radius: 32,
                      ),
                      TextButton(
                        onPressed: () async {
                          // Call your function here
                          try {
                            await null;
                          } catch (error) {
                            // Handle any errors
                          }
                        },
                        child: const Text(
                          'Change profile picture',
                          style:
                              TextStyle(color: Colors.indigo, fontSize: 13.0),
                        ),
                      ),
                    ]),
                const SizedBox(height: 16),
                const Text(
                  "Personal information",
                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 26),
                TextField(
                  keyboardType: TextInputType.text,
                  controller: _nameController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: const Color.fromARGB(12, 0, 0, 0),
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.transparent),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.indigo, width: 1.5),
                    ),
                    labelText: 'Name and Surname',
                    contentPadding: const EdgeInsets.only(
                        left: 12, right: 12, top: 20, bottom: 20),
                    suffixIcon: IconButton(
                      onPressed: _nameController.clear,
                      icon: Icon(
                        Icons.cancel,
                        color: Colors.grey[700],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  keyboardType: TextInputType.emailAddress,
                  controller: _emailController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: const Color.fromARGB(12, 0, 0, 0),
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.transparent),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.indigo, width: 1.5),
                    ),
                    labelText: 'Email',
                    contentPadding: const EdgeInsets.only(
                        left: 12, right: 12, top: 20, bottom: 20),
                    suffixIcon: IconButton(
                      onPressed: _emailController.clear,
                      icon: Icon(
                        Icons.cancel,
                        color: Colors.grey[700],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  controller: _phoneController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: const Color.fromARGB(12, 0, 0, 0),
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.transparent),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.indigo, width: 1.5),
                    ),
                    labelText: 'Phone',
                    contentPadding: const EdgeInsets.only(
                        left: 12, right: 12, top: 20, bottom: 20),
                    suffixIcon: IconButton(
                      onPressed: _phoneController.clear,
                      icon: Icon(
                        Icons.cancel,
                        color: Colors.grey[700],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextButton(
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(3.0),
                      ),
                    ),
                    backgroundColor: MaterialStateProperty.all(
                      const Color.fromARGB(12, 0, 0, 0),
                    ),
                    padding:
                        MaterialStateProperty.all(const EdgeInsets.all(10.0)),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Gender',
                              style: TextStyle(
                                  fontSize: 12, color: Colors.grey[600]),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _genderController.text,
                              style: TextStyle(
                                  fontSize: 16, color: Colors.grey[700]),
                            ),
                          ],
                        ),
                      ),
                      Icon(
                        Icons.keyboard_arrow_down,
                        color: Colors.grey[700],
                        size: 30.0,
                      ),
                    ],
                  ),
                  onPressed: () {
                    showModalBottomSheet<void>(
                      context: context,
                      builder: (BuildContext context) {
                        return SingleChildScrollView(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Padding(
                                padding: EdgeInsets.all(32.0),
                                child: Text(
                                  'Choose your gender',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18.0,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Column(
                                  children: [
                                    ListTile(
                                      title: const Text('Male'),
                                      onTap: () {
                                        setState(() {
                                          _genderController.text = 'Male';
                                        });
                                        Navigator.pop(context);
                                      },
                                    ),
                                    ListTile(
                                      title: const Text('Female'),
                                      onTap: () {
                                        setState(() {
                                          _genderController.text = 'Female';
                                        });
                                        Navigator.pop(context);
                                      },
                                    ),
                                    ListTile(
                                      title: const Text('I prefer not to say'),
                                      onTap: () {
                                        setState(() {
                                          _genderController.text =
                                              'I prefer not to say';
                                        });
                                        Navigator.pop(context);
                                      },
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
                const SizedBox(height: 16),
                TextButton(
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(3.0),
                      ),
                    ),
                    backgroundColor: MaterialStateProperty.all(
                      const Color.fromARGB(12, 0, 0, 0),
                    ),
                    padding:
                        MaterialStateProperty.all(const EdgeInsets.all(10.0)),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Date of birth',
                              style: TextStyle(
                                  fontSize: 12, color: Colors.grey[600]),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _dateController.text.isNotEmpty
                                  ? "${DateTime.parse(_dateController.text).day}/${DateTime.parse(_dateController.text).month}/${DateTime.parse(_dateController.text).year}"
                                  : "No Date Selected",
                              style: TextStyle(
                                  fontSize: 16, color: Colors.grey[700]),
                            ),
                          ],
                        ),
                      ),
                      Icon(
                        Icons.calendar_today_outlined,
                        color: Colors.grey[700],
                        size: 30.0,
                      ),
                    ],
                  ),
                  onPressed: () async {
                    DateTime initialDateValue = DateTime.now();
                    if (_dateController.text.isNotEmpty) {
                      initialDateValue = DateTime.parse(_dateController.text);
                    }
                    final DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: initialDateValue,
                      firstDate: DateTime(1900),
                      lastDate: DateTime.now(),
                    );
                    if (pickedDate != null) {
                      setState(() {
                        _dateController.text = pickedDate.toString();
                      });
                    }
                  },
                ),
                const SizedBox(height: 16),
                TextField(
                  keyboardType: TextInputType.multiline,
                  controller: _descriptionController,
                  maxLength: 160,
                  minLines: 5,
                  maxLines: null,
                  decoration: const InputDecoration(
                    filled: true,
                    fillColor: Color.fromARGB(12, 0, 0, 0),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.transparent),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.indigo, width: 1.5),
                    ),
                    labelText: 'Description',
                    alignLabelWithHint: true,
                    contentPadding: EdgeInsets.only(
                        left: 12, right: 12, top: 20, bottom: 20),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  keyboardType: TextInputType.text,
                  controller: _locationController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: const Color.fromARGB(12, 0, 0, 0),
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.transparent),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.indigo, width: 1.5),
                    ),
                    labelText: 'Where do you play?',
                    contentPadding: const EdgeInsets.only(
                        left: 12, right: 12, top: 20, bottom: 20),
                    suffixIcon: IconButton(
                      onPressed: null,
                      icon: Icon(
                        Icons.near_me_outlined,
                        color: Colors.grey[700],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                const Text(
                  "Player preferences",
                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 26),
                TextButton(
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        side: const BorderSide(
                            color: Color.fromARGB(255, 214, 209, 209)),
                      ),
                    ),
                    backgroundColor: MaterialStateProperty.all(Colors.white),
                    padding:
                        MaterialStateProperty.all(const EdgeInsets.all(10.0)),
                    elevation: MaterialStateProperty.all(10),
                    shadowColor: MaterialStateProperty.all(
                        const Color.fromARGB(100, 255, 255, 255)),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        // Add your icon here
                        Icons.sports_baseball_outlined,
                        color: Colors.grey[700],
                        size: 25.0,
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Edit your preferences',
                              style: TextStyle(
                                  fontSize: 16, color: Colors.grey[800]),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "Best hand, court side, match type, best time...",
                              style: TextStyle(
                                  fontSize: 13, color: Colors.grey[700]),
                            ),
                          ],
                        ),
                      ),
                      Icon(
                        Icons.chevron_right,
                        color: Colors.grey[700],
                        size: 30.0,
                      ),
                    ],
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => EditPreferencesScreen()),
                    );
                  },
                ),
                const SizedBox(height: 40),
                const Text(
                  "Interests",
                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 26),
                TextButton(
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        side: const BorderSide(
                            color: Color.fromARGB(255, 214, 209, 209)),
                      ),
                    ),
                    backgroundColor: MaterialStateProperty.all(Colors.white),
                    padding:
                        MaterialStateProperty.all(const EdgeInsets.all(10.0)),
                    elevation: MaterialStateProperty.all(10),
                    shadowColor: MaterialStateProperty.all(
                        const Color.fromARGB(100, 255, 255, 255)),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        // Add your icon here
                        Icons.sports_tennis,
                        color: Colors.grey[700],
                        size: 25.0,
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Edit your interests',
                              style: TextStyle(
                                  fontSize: 16, color: Colors.grey[800]),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "Play with friends, competitions, challenges",
                              style: TextStyle(
                                  fontSize: 13, color: Colors.grey[700]),
                            ),
                          ],
                        ),
                      ),
                      Icon(
                        Icons.chevron_right,
                        color: Colors.grey[700],
                        size: 30.0,
                      ),
                    ],
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => EditInterestsScreen()),
                    );
                  },
                ),
                const SizedBox(height: 40),
                const Text(
                  "Your password",
                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 26),
                TextButton(
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(3.0),
                      ),
                    ),
                    backgroundColor: MaterialStateProperty.all(
                      const Color.fromARGB(12, 0, 0, 0),
                    ),
                    padding:
                        MaterialStateProperty.all(const EdgeInsets.all(10.0)),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Password',
                              style: TextStyle(
                                  fontSize: 12, color: Colors.grey[600]),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              "* * * * * * * * * *",
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      const Icon(
                        Icons.edit,
                        color: Colors.indigo,
                        size: 30.0,
                      ),
                    ],
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => EditPasswordScreen()),
                    );
                  },
                ),
                const SizedBox(height: 100),
              ],
            ),
          ),
        ));
  }
}
