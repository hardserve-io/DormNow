import 'package:dormnow/core/common/loader.dart';
import 'package:dormnow/core/common/sign_in_button.dart';
import 'package:dormnow/features/auth/controller/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref.watch(authControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'DormNow',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white
            ),
          ),
        backgroundColor: const Color(0xff16382B),
        elevation: 0,
        actions: [
            Container(
              width: 80,
              margin: EdgeInsets.only(top: 10, bottom: 10, right: 10),
              decoration: BoxDecoration(
                border: Border.all(
                  width: 1,
                  color: Color(0xffFFCE0C),
                ),
                borderRadius: BorderRadius.all(
                    Radius.circular(40)),
              ), 
              child: TextButton(
                onPressed: () {},
                child: Text(
                  'Skip',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white
                  ),
                ),
              )
            )
          ],
      ),
      body: isLoading
          ? const Loader()
          : Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: Svg('assets/images/login_background.svg'),
                fit: BoxFit.fill,
              ),
            ),
            child: Column(
              children: [Center(
                  child: const SignInButton()
              )]
            ),
          )
      );
  }
}
