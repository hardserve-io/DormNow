import 'package:dormnow/core/constants/fade_indexed_stack.dart';
import 'package:dormnow/features/home/screens/home_screen.dart';
import 'package:dormnow/features/posts/screens/marketplace_screen.dart';
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
  List<Post> posts = [
    Post(
      authorUid: "1",
      id: "1",
      title: "Timur",
      description: '',
      isFree: true,
      contacts: "@quw1",
      authorUsername: "Biba",
      createdAt: DateTime(2023, 11, 20, 1, 1),
      pictures: [],
    ),
  ];

  static List<Widget> _widgetOptions = <Widget>[
    //HomeScreen(),
    MarketplacePage(
      orders: [
        Post(
          authorUid: "1",
          id: "1",
          title: "Timur1",
          description: '',
          isFree: true,
          contacts: "@quw1",
          authorUsername: "Biba",
          createdAt: DateTime(2023, 11, 20, 1, 1),
          pictures: [
            "https://firebasestorage.googleapis.com/v0/b/dormnow-46dee.appspot.com/o/posts%2Fb7c43bb0-27b3-1d97-b3aa-c37b6dca40ab%2Fb8a43b70-27b3-1d97-b3aa-c37b6dca40ab?alt=media&token=a6790d32-bc28-4c74-ad1d-c8635698b365"
          ],
        ),
        Post(
          authorUid: "1",
          id: "1",
          title: "Timur2",
          description: '',
          isFree: true,
          contacts: "@quw1",
          authorUsername: "Biba",
          createdAt: DateTime(2023, 11, 20, 1, 1),
          pictures: [
            "https://firebasestorage.googleapis.com/v0/b/dormnow-46dee.appspot.com/o/posts%2Fb7c43bb0-27b3-1d97-b3aa-c37b6dca40ab%2Fb8a43b70-27b3-1d97-b3aa-c37b6dca40ab?alt=media&token=a6790d32-bc28-4c74-ad1d-c8635698b365"
          ],
        ),
        Post(
          authorUid: "1",
          id: "1",
          title: "Timur3",
          description: '',
          isFree: true,
          contacts: "@quw1",
          authorUsername: "Biba",
          createdAt: DateTime(2023, 11, 20, 1, 1),
          pictures: [
            "https://firebasestorage.googleapis.com/v0/b/dormnow-46dee.appspot.com/o/posts%2Fb7c43bb0-27b3-1d97-b3aa-c37b6dca40ab%2Fb8a43b70-27b3-1d97-b3aa-c37b6dca40ab?alt=media&token=a6790d32-bc28-4c74-ad1d-c8635698b365"
          ],
        ),
        Post(
          authorUid: "1",
          id: "1",
          title: "Timur4",
          description: '',
          isFree: true,
          contacts: "@quw1",
          authorUsername: "Biba",
          createdAt: DateTime(2023, 11, 20, 1, 1),
          pictures: [
            "https://firebasestorage.googleapis.com/v0/b/dormnow-46dee.appspot.com/o/posts%2Fb7c43bb0-27b3-1d97-b3aa-c37b6dca40ab%2Fb8a43b70-27b3-1d97-b3aa-c37b6dca40ab?alt=media&token=a6790d32-bc28-4c74-ad1d-c8635698b365"
          ],
        ),
        Post(
          authorUid: "1",
          id: "1",
          title: "Timur",
          description: '',
          isFree: true,
          contacts: "@quw1",
          authorUsername: "Biba",
          createdAt: DateTime(2023, 11, 20, 1, 1),
          pictures: [
            "https://firebasestorage.googleapis.com/v0/b/dormnow-46dee.appspot.com/o/posts%2Fb7c43bb0-27b3-1d97-b3aa-c37b6dca40ab%2Fb8a43b70-27b3-1d97-b3aa-c37b6dca40ab?alt=media&token=a6790d32-bc28-4c74-ad1d-c8635698b365"
          ],
        ),
      ],
    ),
    HomeScreen(),
    HomeScreen(),
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
              // border: const GradientBoxBorder(
              //   gradient: LinearGradient(
              //     colors: [
              //       Colors.white54,
              //       Colors.white54,
              //       //Colors.black,
              //     ],
              //     begin: Alignment.topCenter,
              //     end: Alignment.bottomCenter,
              //   ),
              //   width: 1.2,
              // ),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.r),
                topRight: Radius.circular(20.r),
              ),
            ),
            child: Padding(
              padding: EdgeInsets.only(bottom: 0.h, top: 3.h),
              child: BottomNavigationBar(
                elevation: 0,
                //unselectedItemColor: Color.fromRGBO(126, 123, 123, 1),
                //selectedItemColor: Colors.white,
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
