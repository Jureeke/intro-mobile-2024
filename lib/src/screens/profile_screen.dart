import 'package:flutter/material.dart';
import 'package:playtomic/src/screens/activities_screen.dart';
import 'package:playtomic/src/screens/edit_profile_screen.dart';
import 'package:playtomic/src/screens/posts_screen.dart';

class ProfileScreen extends StatefulWidget {
  static const routeName = '/home/profile';
  const ProfileScreen({super.key});

  @override
  ProfileScreenState createState() => ProfileScreenState();
}

class ProfileScreenState extends State<ProfileScreen> {
  final List<Widget> _screens = [
    const ActivitiesScreen(),
    const PostsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      animationDuration: Duration.zero,
      length: _screens.length,
      child: Scaffold(
        body: NestedScrollView(
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
              return [
                SliverAppBar(
                  surfaceTintColor: Colors.white,
                  toolbarHeight: 250.0,
                  title: Column(
                    children: [
                      const Row(
                        children: [
                          CircleAvatar(
                            backgroundImage: NetworkImage(
                                'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRw6CURm0X8IN4G7dKWPwO7AI9l9dV61vZZYeGT-Huytw&s'),
                            radius: 35,
                          ),
                          SizedBox(width: 15),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Username',
                                  style: TextStyle(
                                      fontSize: 21,
                                      fontWeight: FontWeight.bold)),
                              SizedBox(height: 5),
                              Text('Location', style: TextStyle(fontSize: 14)),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 30),
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Column(children: [
                            Text('0'),
                            Text(
                              'Matches',
                              style: TextStyle(fontSize: 14.0),
                            ),
                          ]),
                          SizedBox(height: 25, child: VerticalDivider()),
                          Column(children: [
                            Text('0'),
                            Text(
                              'Followers',
                              style: TextStyle(fontSize: 14.0),
                            ),
                          ]),
                          SizedBox(height: 25, child: VerticalDivider()),
                          Column(children: [
                            Text('0'),
                            Text(
                              'Following',
                              style: TextStyle(fontSize: 14.0),
                            ),
                          ]),
                        ],
                      ),
                      const SizedBox(height: 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                            child: Container(
                              height: 35,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.black),
                                borderRadius: BorderRadius.circular(50),
                              ),
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const EditProfileScreen()),
                                  );
                                },
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.transparent),
                                  elevation:
                                      MaterialStateProperty.all<double>(0),
                                  shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(50),
                                    ),
                                  ),
                                ),
                                child: const Text(
                                  "Edit profile",
                                  style: TextStyle(color: Colors.black),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Container(
                              height: 35,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.black),
                                borderRadius: BorderRadius.circular(50),
                              ),
                              child: ElevatedButton(
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: const Text('Premium unlocked'),
                                      content: const Text(
                                          "Congratulations! You've unlocked the invisible premium package! Enjoy the premium features... that you can't see! 🎉"),
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
                                },
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          const Color.fromARGB(255, 5, 14, 21)),
                                  elevation:
                                      MaterialStateProperty.all<double>(0),
                                  shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(50),
                                    ),
                                  ),
                                ),
                                child: const Text(
                                  "Go Premium",
                                  style: TextStyle(
                                      color: Color.fromARGB(255, 255, 210, 98)),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ];
            },
            body: Scaffold(
              appBar: AppBar(
                toolbarHeight: 0,
                surfaceTintColor: Colors.white,
                bottom: const TabBar(
                  tabs: [
                    Tab(text: 'Activities'),
                    Tab(text: 'Posts'),
                  ],
                  overlayColor: MaterialStatePropertyAll(Colors.transparent),
                  indicatorSize: TabBarIndicatorSize.tab,
                  indicatorColor: Colors.black,
                  labelStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontSize: 15.0),
                  unselectedLabelStyle: TextStyle(
                      fontWeight: FontWeight.normal,
                      color: Colors.black,
                      fontSize: 15.0),
                ),
              ),
              body: TabBarView(
                physics: const NeverScrollableScrollPhysics(),
                children: _screens,
              ),
            )),
      ),
    );
  }
}
