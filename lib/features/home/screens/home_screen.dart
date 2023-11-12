import 'package:dormnow/features/auth/controller/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  void navigateToCreatePost(BuildContext context) {
    Routemaster.of(context).push('/add-post');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider)!;

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => navigateToCreatePost(context),
        heroTag: null,
        child: const Icon(Icons.add),
      ),
      body: Center(
        child: Text(user.name),
      ),
    );
  }
}
