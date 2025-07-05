import 'dart:math';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mental_math_trainer_app/firebase/firebase_auth_services.dart';
import 'package:mental_math_trainer_app/providers/device_provider.dart';
import 'package:mental_math_trainer_app/screens/authentication_screens/email_login.dart';
import 'package:mental_math_trainer_app/widgets/loading_screen.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final Random rng1 = Random();
  final Random rng2 = Random();
  bool isLoading = false;

  TextStyle randomTextTheme = GoogleFonts.exo2(
    textStyle: const TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 80,
      color: Colors.white,
    ),
  );

  final ButtonStyle _buttonStyle = ElevatedButton.styleFrom(
    backgroundColor: Colors.white,
    shape: RoundedRectangleBorder(
      // Changed to BorderRadius.circular for standard rounded corners.
      // If you want a perfectly pill-shaped button for height 50, use BorderRadius.circular(25).
      borderRadius: BorderRadius.circular(10),
    ),
    padding: const EdgeInsets.symmetric(horizontal: 16),
    textStyle: const TextStyle(fontSize: 16),
  );

  @override
  Widget build(BuildContext context) {
    final Size? deviceSize = ref.watch(deviceSizeProvider);
    final deviceHeight = deviceSize!.height;
    final deviceWidth = deviceSize.width;

    List<TyperAnimatedText> animatedTexts = [
      TyperAnimatedText("${rng1.nextInt(100)} + ${rng2.nextInt(100)}",
          textStyle: randomTextTheme),
      TyperAnimatedText("${rng1.nextInt(100)} - ${rng2.nextInt(100)}",
          textStyle: randomTextTheme),
      TyperAnimatedText("${rng1.nextInt(100)} / ${rng2.nextInt(10)}",
          textStyle: randomTextTheme),
      TyperAnimatedText("${rng1.nextInt(100)} * ${rng2.nextInt(10)}",
          textStyle: randomTextTheme),
    ];

    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Stack(
        children: [
          Center(
            child: SizedBox(
              width: deviceWidth,
              height: deviceHeight,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Spacer(flex: 2),

                  // Logo and Animated Text Section
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: deviceWidth * 0.05),
                        child: const SizedBox(
                          width: 100,
                          height: 100,
                          child: Image(
                            image: AssetImage('assets/logo.png'),
                          ),
                        ),
                      ),
                      Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: deviceHeight * 0.03),
                        child: AnimatedTextKit(animatedTexts: animatedTexts),
                      ),
                    ],
                  ),

                  // This Spacer creates space between the top section and the branding/buttons section
                  const Spacer(flex: 3),

                  // Branding and Buttons Section (IMPORTANT: Ensure no Spacer or Expanded here)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "FlexMath",
                        style: GoogleFonts.exo2(
                          textStyle: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 36,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Train and Flex Your Mental Mathematics.",
                        style: GoogleFonts.exo2(
                          textStyle: const TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 18,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),

                      // Google Sign in button
                      SizedBox(
                        width: deviceWidth * 0.9,
                        height: 50,
                        child: ElevatedButton.icon(
                          onPressed: () async {
                            setState(() {
                              isLoading = true;
                            });
                            try {
                              UserCredential userCredential =
                                  await FirebaseAuthService.signInWithGoogle();
                              print(userCredential);
                            } catch (e) {
                              print("Google Sign-in failed: $e");
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text(
                                        'Google Sign-in failed. Please try again.')),
                              );
                            } finally {
                              if (mounted) {
                                setState(() {
                                  isLoading = false;
                                });
                              }
                            }
                          },
                          icon: const ImageIcon(
                            AssetImage('assets/google.png'),
                          ),
                          label: const Text(
                            "Sign in with Google",
                            style: TextStyle(color: Colors.black),
                          ),
                          style: _buttonStyle, // Apply the common style
                        ),
                      ),
                      // Spacing between buttons
                      const SizedBox(height: 20),

                      // Email Sign-in Button
                      SizedBox(
                        width: deviceWidth * 0.9,
                        height: 50,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const EmailLoginScreen(),
                            ));
                          },
                          icon: const Icon(Icons.email,
                              color: Colors.black), // Icon color to match text
                          label: const Text(
                            "Sign in with email and password",
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                          style: _buttonStyle, // Apply the common style
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
          if (isLoading) const LoadingScreen()
        ],
      ),
    );
  }
}
