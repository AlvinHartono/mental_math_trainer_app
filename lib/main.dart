import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mental_math_trainer_app/firebase_options.dart';
import 'package:mental_math_trainer_app/providers/device_provider.dart';
import 'package:mental_math_trainer_app/screens/authentication_screens/auth_check.dart';
// import 'package:riverpod_annotation/riverpod_annotation.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            primary: const Color.fromRGBO(52, 103, 178, 1),
            seedColor: const Color.fromRGBO(52, 103, 178, 1)),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
            backgroundColor: Color.fromRGBO(52, 103, 178, 1),
            iconTheme: IconThemeData(color: Colors.white),
            titleTextStyle: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold)),
        navigationBarTheme: NavigationBarThemeData(
          backgroundColor: const Color.fromRGBO(52, 103, 178, 1),
          height: 65,
          indicatorColor: Colors.white,
          iconTheme: WidgetStateProperty.resolveWith<IconThemeData>(
              (Set<WidgetState> states) {
            if (states.contains(WidgetState.selected)) {
              return const IconThemeData(
                  color:
                      Color.fromRGBO(52, 103, 178, 1)); // Selected icon color
            } else {
              return const IconThemeData(
                  color: Colors.white); // Unselected icon color
            }
          }),
          labelTextStyle: WidgetStateProperty.resolveWith<TextStyle>(
              (Set<WidgetState> states) {
            // Check if the 'selected' state is present
            if (states.contains(WidgetState.selected)) {
              return const TextStyle(
                  color: Colors.white); // White text for selected item
            } else {
              return TextStyle(
                  color: Colors
                      .grey[300]); // Gray text for unselected items (optional)
            }
          }),
        ),
        textTheme: GoogleFonts.exo2TextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      home: const DeviceSizeReader(
        child: AuthCheck(),
      ),
    );
  }
}

class DeviceSizeReader extends ConsumerWidget {
  const DeviceSizeReader({super.key, required this.child});

  final Widget child;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Future.microtask(() {
      final deviceSize = MediaQuery.of(context).size;
      ref.read(deviceSizeProvider.notifier).state = deviceSize;
    });
    return child;
  }
}
