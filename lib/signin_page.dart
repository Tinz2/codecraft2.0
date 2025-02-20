import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'auth.dart';
import 'home_page.dart'; // เพิ่มการ import หน้า HomePage
import 'profilesetup.dart'; // เพิ่มการ import หน้า ProfileSetup

class LoginPage extends StatefulWidget {
  static const String routeName = '/login';
  const LoginPage({super.key});
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final AuthService _auth = AuthService();
  String _email = '';
  String _password = '';
  bool _isLoading = false;

  void _setLoading(bool value) {
    setState(() {
      _isLoading = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login / Sign Up'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(labelText: 'Email'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    _email = value.trim();
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  obscureText: true,
                  decoration: const InputDecoration(labelText: 'Password'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    if (value.length < 6) {
                      return 'Password must be at least 6 characters';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    _password = value.trim();
                  },
                ),
                const SizedBox(height: 16),
                if (_isLoading)
                  const CircularProgressIndicator()
                else
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            _setLoading(true);
                            try {
                              await _auth.signInWithEmailAndPassword(
                                  _email, _password, context);
                              Navigator.pushReplacementNamed(
                                  context, HomePage.routeName);
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Login failed: $e'),
                                ),
                              );
                            } finally {
                              _setLoading(false);
                            }
                          }
                        },
                        child: const Text('Sign In'),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            _setLoading(true);
                            try {
                              await _auth.registerWithEmailAndPassword(
                                  _email, _password, context);
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => profilesetup(
                                    userData: {'email': _email},
                                  ),
                                ),
                              );
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Sign up failed: $e'),
                                ),
                              );
                            } finally {
                              _setLoading(false);
                            }
                          }
                        },
                        child: const Text('Sign Up'),
                      ),
                    ],
                  ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () async {
                    if (_email.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please enter your email'),
                        ),
                      );
                    } else {
                      await _auth.resetPassword(_email, context);
                    }
                  },
                  child: const Text('Forgot Password?'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
