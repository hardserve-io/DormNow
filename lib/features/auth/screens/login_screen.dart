import 'package:dormnow/core/common/loader.dart';
import 'package:dormnow/core/common/sign_in_button.dart';
import 'package:dormnow/features/auth/controller/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
          backgroundColor: const Color(0xff16382B),
          elevation: 0,
          actions: [
            Container(
                width: 80,
                margin: const EdgeInsets.only(top: 10, bottom: 10, right: 10),
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 1,
                    color: const Color(0xffFFCE0C),
                  ),
                  borderRadius: const BorderRadius.all(Radius.circular(40)),
                ),
                child: TextButton(
                  onPressed: () {},
                  child: const Text(
                    'Skip',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ))
          ],
        ),
        body: Container(
          color: const Color(0xff16382B),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                alignment: Alignment.topLeft,
                padding: const EdgeInsets.only(left: 25),
                child: SvgPicture.asset('assets/images/gerb.svg'),
              ),
              Container(
                alignment: Alignment.center,
                child: isLoading ? const Loader() : const SignInButton(),
              ),
              const Spacer(),
              Container(
                width: double.infinity,
                alignment: Alignment.bottomCenter,
                child: SvgPicture.asset('assets/images/dorm.svg',
                    fit: BoxFit.cover),
              )
            ],
          ),
        ));
  }
}
