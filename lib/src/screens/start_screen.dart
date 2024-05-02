import 'package:flutter/material.dart';
import 'package:playtomic/src/services/auth_service.dart';
import 'register_screen.dart';
import 'login_screen.dart';

class StartScreen extends StatelessWidget {
  static const routeName = '/start';

  StartScreen({super.key, Key? keyy});

  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/startscreen-bg.png"),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
                Colors.grey.withOpacity(0.9), BlendMode.darken),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.only(
              left: 15.0, right: 16.0, top: 0.0, bottom: 28.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Image.asset(
                      "assets/images/playtomic-logo.png",
                      height: 40,
                    ),
                    const SizedBox(height: 25.0),
                    const Text(
                      "Join the biggest racket \nsports players community",
                      style: TextStyle(
                          fontSize: 20.7, height: 1.25, color: Colors.white),
                    ),
                    const SizedBox(height: 6.0),
                    const Text(
                      "And find your perfect match",
                      style: TextStyle(fontSize: 14.0, color: Colors.white),
                    ),
                    const SizedBox(height: 29.0),
                    SizedBox(
                      height: 41,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamed(
                              context, RegisterScreen.routeName);
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              const Color.fromARGB(255, 74, 93, 249)),
                          elevation: MaterialStateProperty.all<double>(0),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50),
                            ),
                          ),
                        ),
                        child: const Text(
                          "Register",
                          style: TextStyle(color: Colors.white, fontSize: 16.0),
                        ),
                      ),
                    ),
                    const SizedBox(height: 7.0),
                    Container(
                      height: 41,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamed(context, LoginScreen.routeName);
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              Colors.transparent),
                          elevation: MaterialStateProperty.all<double>(0),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50),
                            ),
                          ),
                        ),
                        child: const Text(
                          "Log In",
                          style: TextStyle(color: Colors.white, fontSize: 16.0),
                        ),
                      ),
                    ),
                    const SizedBox(height: 29.0),
                    const Text(
                      "Or continue with:",
                      style: TextStyle(fontSize: 12.0, color: Colors.white),
                    ),
                    const SizedBox(height: 7.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          onPressed: () async {
                            try {
                              await _authService.signInWithFacebook();
                              if (!context.mounted) return;
                              Navigator.of(context)
                                  .pushReplacementNamed('/home');
                            } catch (error) {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text('signInWithFacebook Error'),
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
                          highlightColor: Colors.transparent,
                          icon: Image.asset(
                            "assets/images/FB_Icon_Rounded.png",
                            scale: 4.8,
                          ),
                        ),
                        const SizedBox(width: 15.0),
                        IconButton(
                          onPressed: () async {
                            try {
                              await _authService.signInWithGoogle();
                              if (!context.mounted) return;
                              Navigator.of(context)
                                  .pushReplacementNamed('/home');
                            } catch (error) {
                              print(error.toString());
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text('signInWithGoogle Error'),
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
                          highlightColor: Colors.transparent,
                          icon: Image.asset(
                            "assets/images/Google_Icon_Rounded.png",
                            scale: 4.8,
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 13.5),
                    const Text(
                      "By registering you are accepting our terms of use and \nprivacy policy",
                      style: TextStyle(fontSize: 12.0, color: Colors.white),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
