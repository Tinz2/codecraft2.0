import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'auth.dart';
import 'home_page.dart';
import 'profilesetup.dart';

class LoginPage extends StatefulWidget {
  static const String routeName = '/login';
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final AuthService _auth = AuthService();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String _email = '';
  String _password = '';
  bool _isLoading = false;

  void _setLoading(bool value) {
    setState(() {
      _isLoading = value;
    });
  }

  Future<void> _saveUserData(String uid, String email) async {
    try {
      await _firestore.collection('userscodecraft').doc(uid).set({
        'email': email,
        'createdAt': Timestamp.now(),
      });
      print('🔥 User data saved successfully!');
    } catch (e) {
      print('❌ Error saving user data: $e');
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error saving user data: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircleAvatar(
                radius: 50,
                backgroundColor: Colors.transparent,
                backgroundImage: AssetImage('assets/profile.png'),
              ),
              const SizedBox(height: 20),
              const Text(
                'Sign in to your account',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: 'Email',
                        labelStyle: const TextStyle(color: Colors.white),
                        filled: true,
                        fillColor: Colors.white24,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                      ),
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
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: 'Password',
                        labelStyle: const TextStyle(color: Colors.white),
                        filled: true,
                        fillColor: Colors.white24,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                      ),
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
                  ],
                ),
              ),
              const SizedBox(height: 20),
              if (_isLoading)
                const CircularProgressIndicator(color: Colors.white)
              else
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 12),
                        textStyle: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.blueAccent,
                      ),
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          _setLoading(true);
                          try {
                            UserCredential? userCredential =
                                await _auth.signInWithEmailAndPassword(
                                    _email, _password, context);
                            if (userCredential != null) {
                              Navigator.pushReplacementNamed(
                                  context, HomePage.routeName);
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content: Text(
                                        'Login failed: UserCredential is null')),
                              );
                            }
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Login failed: $e')),
                            );
                          } finally {
                            _setLoading(false);
                          }
                        }
                      },
                      child: const Text('Sign In'),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 12),
                        textStyle: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.blueAccent,
                      ),
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          _setLoading(true);
                          try {
                            UserCredential? userCredential =
                                await _auth.registerWithEmailAndPassword(
                                    _email, _password, context);
                            if (userCredential != null) {
                              await _saveUserData(
                                  userCredential.user!.uid, _email);
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      profilesetup(userData: {'email': _email}),
                                ),
                              );
                            }
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Sign up failed: $e')),
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
            ],
          ),
        ),
      ),
    );
  }
}
