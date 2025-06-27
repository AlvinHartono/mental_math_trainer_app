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

  @override
  Widget build(BuildContext context) {
    final Size? deviceSize = ref.watch(deviceSizeProvider);
    final deviceHeight = deviceSize!.height;
    final deviceWidth = deviceSize.width;

    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Stack(
        children: [
          Center(
            child: SizedBox(
              width: deviceWidth,
              height: deviceHeight,
              child: Column(
                children: [
                  SizedBox(
                    width: deviceWidth,
                    height: deviceHeight * 0.5,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: deviceHeight * 0.6 * 0.2,
                        ),
                        const SizedBox(
                          width: 100,
                          height: 100,
                          child: Image(
                            image: AssetImage('assets/logo.png'),
                          ),
                        ),
                        SizedBox(
                          height: deviceHeight * 0.6 * 0.15,
                        ),
                        AnimatedTextKit(
                          repeatForever: true,
                          animatedTexts: [
                            TyperAnimatedText(
                                "${rng1.nextInt(100)} + ${rng2.nextInt(100)}",
                                textStyle: randomTextTheme),
                            TyperAnimatedText(
                                "${rng1.nextInt(100)} - ${rng2.nextInt(100)}",
                                textStyle: randomTextTheme),
                            TyperAnimatedText(
                                "${rng1.nextInt(100)} / ${rng2.nextInt(10)}",
                                textStyle: randomTextTheme),
                            TyperAnimatedText(
                                "${rng1.nextInt(100)} * ${rng2.nextInt(10)}",
                                textStyle: randomTextTheme),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: deviceWidth,
                    height: deviceHeight * 0.3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: (deviceHeight * 0.4 * 0.05),
                        ),
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
                        SizedBox(
                          height: (deviceHeight * 0.4 * 0.15),
                        ),
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
                                    await FirebaseAuthService
                                        .signInWithGoogle();
                                print(userCredential);
                              } catch (e) {
                                // Handle the error appropriately
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
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        SizedBox(
                          width: deviceWidth * 0.9,
                          height: 50,
                          child: ElevatedButton.icon(
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => const EmailLoginScreen(),
                              ));
                            },
                            icon: const Icon(Icons.email),
                            label: const Text(
                              "Sign in with email and password",
                              style: TextStyle(
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
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

//https://youtu.be/VCrXSFqdsoA?feature=shared
//https://fonts.google.com/specimen/Exo+2
