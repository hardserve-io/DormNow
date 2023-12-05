import 'package:dormnow/features/auth/controller/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SignInButton extends ConsumerWidget {
  const SignInButton({Key? key}) : super(key: key);

  void signInWithGoogle(BuildContext context, WidgetRef ref) {
    ref.read(authControllerProvider.notifier).signInWithGoogle(context);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
        margin: const EdgeInsets.only(top: 200),
        width: 240,
        height: 60,
        decoration: BoxDecoration(
          border: Border.all(
            width: 1,
            color: const Color(0xffFFCE0C),
          ),
          borderRadius: const BorderRadius.all(Radius.circular(40)),
        ),
        child: TextButton(
          onPressed: () => signInWithGoogle(context, ref),
          child: const Text('Вхід через Google',
              style: TextStyle(fontSize: 20, color: Colors.white)),
        ));
  }
}
