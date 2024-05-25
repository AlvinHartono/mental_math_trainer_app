import 'package:flutter/material.dart';
import 'package:mental_math_trainer_app/firebase/firebase_auth_services.dart';
import 'package:mental_math_trainer_app/widgets/loading_screen.dart';

class EmailLoginScreen extends StatefulWidget {
  const EmailLoginScreen({super.key});

  @override
  State<EmailLoginScreen> createState() => _EmailLoginScreenState();
}

class _EmailLoginScreenState extends State<EmailLoginScreen> {
  bool isLogin = true;
  bool isLoading = false;
  final _formKey = GlobalKey<FormState>();
  final emailTextEditingController = TextEditingController();
  final passwordTextEditingController = TextEditingController();
  final confirmPasswordTextEditingController = TextEditingController();
  final FirebaseAuthService _authService = FirebaseAuthService();

  void _toggleFormType() {
    setState(() {
      isLogin = !isLogin;
    });
  }

  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      final email = emailTextEditingController.text.trim();
      final password = passwordTextEditingController.text.trim();

      setState(() {
        isLoading = true; // Show loading screen
      });

      try {
        if (isLogin) {
          final user = await _authService.signInWithEmail(email, password);
          if (user != null) {
            print('User signed in: ${user.email}');
            // Navigate to home screen or another appropriate screen
          } else {
            print('Sign in failed');
          }
        } else {
          if (password == confirmPasswordTextEditingController.text.trim()) {
            final user = await _authService.signUpWithEmail(email, password);
            if (user != null) {
              print('User registered: ${user.email}');
              // Navigate to home screen or another appropriate screen
            } else {
              print('Sign up failed');
            }
          } else {
            print('Passwords do not match');
          }
        }
      } finally {
        setState(() {
          isLoading = false; // Hide loading screen
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            title: isLogin ? const Text("Login") : const Text("Register"),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    isLogin
                        ? "Login With Email and Password"
                        : "Register With Email and Password",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  TextFormField(
                    controller: emailTextEditingController,
                    decoration: const InputDecoration(labelText: 'Email'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter an email';
                      }
                      if (!RegExp(
                              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                          .hasMatch(value)) {
                        return 'Please enter a valid email address';
                      }

                      return null;
                    },
                  ),
                  TextFormField(
                    controller: passwordTextEditingController,
                    decoration: const InputDecoration(labelText: 'Password'),
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a password';
                      } else if (value.length <= 8) {
                        return 'Password must be 8 characters or longer';
                      }
                      return null;
                    },
                  ),
                  if (!isLogin)
                    TextFormField(
                      controller: confirmPasswordTextEditingController,
                      decoration:
                          const InputDecoration(labelText: 'Confirm Password'),
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please confirm your password';
                        } else if (value.length <= 8) {
                          return 'Password must be 8 characters or longer';
                        } else if (confirmPasswordTextEditingController.text !=
                            passwordTextEditingController.text) {
                          return 'Password don\'t match';
                        }
                        return null;
                      },
                    ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _submit,
                    child: Text(isLogin ? "Login" : "Register"),
                  ),
                  TextButton(
                    onPressed: _toggleFormType,
                    child: Text(isLogin
                        ? "Don't have an account? Register"
                        : "Already have an account? Login"),
                  ),
                ],
              ),
            ),
          ),
        ),
        if (isLoading) const LoadingScreen(),
      ],
    );
  }
}
