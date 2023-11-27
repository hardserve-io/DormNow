import 'package:dormnow/features/auth/screens/login_screen.dart';
import 'package:dormnow/features/home/screens/bottom_nav.dart';
import 'package:dormnow/features/posts/screens/add_post_screen.dart';
import 'package:dormnow/models/post_model.dart';
import 'package:flutter/material.dart';
import 'package:routemaster/routemaster.dart';
import 'package:dormnow/features/posts/screens/post_full_screen.dart';

final loggedOutRoute = RouteMap(routes: {
  '/': (_) => const MaterialPage(child: LoginScreen()),
});

final loggedInRoute = RouteMap(routes: {
  '/': (_) => const MaterialPage(child: BottomNavigator()),
  '/add-post': (_) => const MaterialPage(child: AddPostScreen()),
  //'/view-post': (route) => MaterialPage(child: OrderPage(order:),),
});
