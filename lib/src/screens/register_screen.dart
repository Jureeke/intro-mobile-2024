import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:playtomic/src/services/auth_service.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key, Key? keyy});

  static const routeName = '/register';

  @override
  RegisterScreenState createState() => RegisterScreenState();
}

class RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final AuthService _authService = AuthService();

  bool _allFieldsFilled = false;
  bool _isObscured = true;
  bool _acceptTerms = false;
  bool _receivePromotions = false;

  @override
  void initState() {
    super.initState();
    _updateAllFieldsFilled();
    _isObscured = true;
  }

  void _updateAllFieldsFilled() {
    setState(() {
      _allFieldsFilled = _usernameController.text.isNotEmpty &&
          _emailController.text.isNotEmpty &&
          _mobileController.text.isNotEmpty &&
          _passwordController.text.isNotEmpty &&
          _acceptTerms;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(35.0),
        child: AppBar(
          iconTheme: const IconThemeData(size: 20),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(
            left: 16.0, right: 16.0, top: 0.0, bottom: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              "Sign Up",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 30),
                    TextField(
                      controller: _usernameController,
                      onChanged: (_) => _updateAllFieldsFilled(),
                      decoration: const InputDecoration(
                        labelText: 'Name and last name',
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        labelStyle: TextStyle(color: Colors.black, height: 1.0),
                        hintText: 'Carolina Valera',
                        hintStyle:
                            TextStyle(color: Color.fromARGB(100, 0, 0, 0)),
                        contentPadding: EdgeInsets.only(top: 7),
                      ),
                      style: const TextStyle(height: 1.2),
                    ),
                    const SizedBox(height: 25),
                    TextField(
                      keyboardType: TextInputType.emailAddress,
                      controller: _emailController,
                      onChanged: (_) => _updateAllFieldsFilled(),
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        labelStyle: TextStyle(color: Colors.black, height: 1.0),
                        hintText: 'hola@playtomic.io',
                        hintStyle:
                            TextStyle(color: Color.fromARGB(100, 0, 0, 0)),
                        contentPadding: EdgeInsets.only(top: 7),
                      ),
                      style: const TextStyle(height: 1.2),
                    ),
                    const SizedBox(height: 25),
                    TextField(
                      controller: _mobileController,
                      onChanged: (_) => _updateAllFieldsFilled(),
                      decoration: const InputDecoration(
                        labelText: 'Mobile',
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        labelStyle: TextStyle(color: Colors.black, height: 1.0),
                        hintText: '600123456',
                        hintStyle:
                            TextStyle(color: Color.fromARGB(100, 0, 0, 0)),
                        contentPadding: EdgeInsets.only(top: 7),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors
                                  .indigo), // Change this color to suit your design
                        ),
                      ),
                      style: const TextStyle(height: 1.2),
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                    ),
                    const SizedBox(height: 25),
                    TextField(
                      controller: _passwordController,
                      onChanged: (_) => _updateAllFieldsFilled(),
                      decoration: InputDecoration(
                          labelText: 'Password',
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          labelStyle:
                              const TextStyle(color: Colors.black, height: 1.0),
                          hintText: '*************',
                          hintStyle: const TextStyle(
                              color: Color.fromARGB(100, 0, 0, 0)),
                          contentPadding: const EdgeInsets.only(top: 7),
                          suffixIcon: IconButton(
                            icon: Icon(_isObscured
                                ? Icons.visibility
                                : Icons.visibility_off),
                            onPressed: () {
                              setState(() {
                                _isObscured = !_isObscured;
                              });
                            },
                          )),
                      style: const TextStyle(height: 1.2),
                      obscureText: _isObscured,
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        SizedBox(
                          //height: 0.0,
                          width: 15.0,
                          child: Checkbox(
                            side: MaterialStateBorderSide.resolveWith(
                                (states) => const BorderSide(
                                    width: 1.5, color: Colors.indigo)),
                            value: _receivePromotions,
                            onChanged: (value) {
                              setState(() {
                                _receivePromotions = value!;
                              });
                            },
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(left: 20.0),
                          child: Text(
                            "Marketing communications from Playtomic",
                            style: TextStyle(wordSpacing: -1.5),
                          ),
                        ),
                      ],
                    ),
                    const Padding(
                        padding: EdgeInsets.only(left: 41.0),
                        child: Text(
                          "I consent to the processing of my personal \ndata for the purpose of sending me marketing \ncommunications as indicated in the privacy policy \nthat i have read",
                          style: TextStyle(fontSize: 12.0, height: 1.25),
                        )),
                    const SizedBox(height: 17),
                    Row(
                      children: [
                        SizedBox(
                          width: 15.0,
                          child: Checkbox(
                            side: MaterialStateBorderSide.resolveWith(
                                (states) => const BorderSide(
                                    width: 1.5, color: Colors.indigo)),
                            value: _acceptTerms,
                            onChanged: (value) {
                              setState(() {
                                _acceptTerms = value!;
                                _updateAllFieldsFilled();
                              });
                            },
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(left: 20.0),
                          child: Text(
                            "Terms and conditions and Privacy policy",
                            style: TextStyle(wordSpacing: -1.5),
                          ),
                        ),
                      ],
                    ),
                    const Padding(
                        padding: EdgeInsets.only(left: 41.0),
                        child: Text(
                          "I confirm that I accept the terms and \nconditions and that I have read the privacy policy",
                          style: TextStyle(fontSize: 12.0, height: 1.25),
                        )),
                  ],
                ),
              ),
            ),
            ElevatedButton(
              onPressed: _allFieldsFilled
                  ? () async {
                      try {
                        await _authService.registerUser(
                          _emailController.text,
                          _passwordController.text,
                          _usernameController.text,
                          _mobileController.text,
                        );
                        // Navigate to home page after successful registration
                        if (!context.mounted) return;
                        Navigator.of(context).pushReplacementNamed('/login');
                      } catch (error) {
                        // Handle registration error
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Registration Error'),
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
                    }
                  : null,
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                  _allFieldsFilled
                      ? const Color.fromARGB(255, 14, 36, 50)
                      : const Color.fromARGB(100, 14, 36, 50),
                ),
              ),
              child: const Padding(
                padding: EdgeInsets.all(12.0),
                child: Text(
                  'Create an account',
                  style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
