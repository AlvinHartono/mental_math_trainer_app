import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mental_math_trainer_app/providers/auth_provider.dart';
import 'package:mental_math_trainer_app/screens/home_screen.dart';
import 'package:mental_math_trainer_app/screens/authentication_screens/login_screen.dart';
import 'package:mental_math_trainer_app/widgets/loading_screen.dart';

class AuthCheck extends ConsumerWidget {
  const AuthCheck({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    return authState.when(
      data: (data) {
        if (data != null) {
          return const HomeScreen();
        } else {
          return const LoginScreen();
        }
      },
      error: (error, stackTrace) => const LoginScreen(),
      loading: () => const LoadingScreen(),
    );
  }
}
