import 'package:dormnow/core/common/loader.dart';
import 'package:dormnow/core/common/sign_in_button.dart';
import 'package:dormnow/features/auth/controller/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref.watch(authControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('DormNow'),
        actions: [
          TextButton(
            onPressed: () {},
            child: const Text(
              'Skip',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
      body: isLoading
          ? const Loader()
          : Column(
              children: [
                Center(
                  child: const SignInButton()
                ),
              ],
            ),
    );
  }
}
