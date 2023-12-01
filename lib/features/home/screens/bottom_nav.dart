import 'package:dormnow/core/constants/fade_indexed_stack.dart';
import 'package:dormnow/features/home/screens/home_screen.dart';
import 'package:dormnow/features/posts/repository/post_repository.dart';
import 'package:dormnow/features/posts/screens/marketplace_screen.dart';
import 'package:dormnow/features/user_profile/screens/user_profile_screen.dart';
import 'package:dormnow/models/post_model.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';

class BottomNavigator extends StatefulWidget {
  const BottomNavigator({super.key});

  @override
  State<BottomNavigator> createState() => _BottomNavigatorState();
}

class _BottomNavigatorState extends State<BottomNavigator> {
  int _selectedIndex = 0;

  static List<Widget> _widgetOptions = <Widget>[
    //HomeScreen(),
    MarketPlaceScreen(),
    HomeScreen(),
    UserProfileScreen(uid: null)
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedIndexedStack(
        index: _selectedIndex,
        children: _widgetOptions,
      ),
      bottomNavigationBar: SafeArea(
        child: Theme(
          data: ThemeData(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
          ),
          child: Container(
            decoration: BoxDecoration(
              color: Color(0xff121212),
              /*border: const GradientBoxBorder(
                gradient: LinearGradient(
                  colors: [
                    Colors.white,
                    Colors.black,
                    Colors.black,
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                width: 1.2,
              ),*/
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.r),
                topRight: Radius.circular(20.r),
              ),
            ),
            child: Padding(
              padding: EdgeInsets.only(bottom: 5.h, top: 3.h),
              child: BottomNavigationBar(
                elevation: 0,
                // unselectedItemColor: Color.fromRGBO(126, 123, 123, 100),
                // selectedItemColor: Colors.white,
                enableFeedback: false,
                backgroundColor: Colors.transparent,
                //changes background of Botton Navigation Bar
                showSelectedLabels: true,
                showUnselectedLabels: false,
                selectedLabelStyle: const TextStyle(fontSize: 15),
                items: const [
                  BottomNavigationBarItem(
                    icon: Icon(
                      Icons.store_mall_directory_rounded,
                      color: Colors.white,
                    ),
                    label: "",
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(
                      Icons.room_service,
                      color: Colors.white,
                    ),
                    label: "",
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(
                      Icons.person,
                      color: Colors.white,
                    ),
                    label: "",
                  )
                ],
                currentIndex: _selectedIndex,
                onTap: (index) {
                  setState(() {
                    _selectedIndex = index;
                  });
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
