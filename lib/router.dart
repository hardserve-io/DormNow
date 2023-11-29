import 'package:dormnow/features/auth/screens/login_screen.dart';
import 'package:dormnow/features/home/screens/bottom_nav.dart';
import 'package:dormnow/features/posts/screens/add_post_screen.dart';
import 'package:dormnow/features/user_profile/screens/edit_profile_screen.dart';
import 'package:dormnow/features/user_profile/screens/user_profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:routemaster/routemaster.dart';
import 'package:dormnow/features/posts/screens/post_full_screen.dart';

final loggedOutRoute = RouteMap(routes: {
  '/': (_) => const MaterialPage(child: LoginScreen()),
});

final loggedInRoute = RouteMap(routes: {
  '/': (_) => const MaterialPage(
        child: BottomNavigator(),
      ),
  '/add-post': (_) => const MaterialPage(
        child: AddPostScreen(),
      ),
  '/post/:postId': (route) => MaterialPage(
        child: OrderPage(
          postId: route.pathParameters['postId']!,
        ),
      ),
  '/user/:uid': (route) => MaterialPage(
        child: UserProfileScreen(
          uid: route.pathParameters['uid']!,
        ),
      ),
  '/edit-profile': (route) => const MaterialPage(
        child: EditProfileScreen(),
      ),
});
