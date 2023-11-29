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
    MarketplacePage(
      orders: [
        Post(
          authorUid: "1",
          id: "1",
          title: "Холодильник",
          description: '',
          isFree: false,
          price: 1244,
          contacts: "@quw1",
          authorUsername: "Biba",
          createdAt: DateTime(2023, 11, 20, 01, 12),
          pictures: ['https://ireland.apollo.olxcdn.com/v1/files/umdyoglkd29p3-UA/image;s=1500x2000'],
        ),
        Post(
          authorUid: "1",
          id: "1",
          title: 'Засіб від плісняви',
          isFree: true,
          contacts: "@viktoriina",
          authorUsername: "Biba",
          createdAt: DateTime(2023, 11, 20, 1, 1),
          description:
              'Перевірено, коли мив всередині холодильник - працює.\nЯ купляв за під 80 грн., віддам за 50 грн.\nБонусом віддам перчатки латексно-бавовняні, щоб ваші ручки були в безпеці \n\nРед.: він практично повний, я лише рази два пшикнув',
          pictures: ['https://ireland.apollo.olxcdn.com/v1/files/ozmtmwa5ckl43-UA/image;s=810x1080'],
        ),
        Post(
          authorUid: "1",
          id: "1",
          title: "Wi-Fi роутер",
          description:
              'WiFi роутер Зухель 😎👍\nБлок живлення у подарунок ! 🎁\nХарактеристики:\n• 2.4GHz 😲\n• 3 (один згорів) порти 100 мб/с 🤯\n• Ровесник холодильника ДОНБАС 🤩\n• Країна виробник Китай (+99 social credit 🇨🇳)\n• Можна використовувати як пастку для тарганів 🦗🚫\nСтартова ціна 50 українських доларів UAH. 🤑 Крок 20 гривень \n\nP.S. Зібрані кошти підуть на підтримку бідних студентів 😢💸',
          isFree: false,
          price: 1488,
          contacts: "@quw1",
          authorUsername: "Biba",
          createdAt: DateTime(2023, 11, 20, 1, 1),
          pictures: [
            'https://cdn.thewirecutter.com/wp-content/media/2023/01/router-2048px-7075.jpg?auto=webp&quality=75&width=1024',
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
          title:
              "⇒→⊃�⇒��=2⇒�2=4�2=4⇒�=2�+5=�+2⇔�+3=�¬(¬�)⇔�≠�⇔¬(�=�)∨+∥↮⊕⊻≢∀�∈�:�2≥�.∃�∈�:∃!!�∈�:��.≔≡:⇔:=≡:⇔:�=��+�−�(~)⊢⊨",
          description: '',
          isFree: true,
          contacts: "@quw1",
          authorUsername: "Biba",
          createdAt: DateTime(2023, 11, 20, 1, 1),
          pictures: ['https://api.mytimetable.live/media/img/teacher/shkilniak_ss.jpg'],
        ),
      ],
    ),
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
              border: const GradientBoxBorder(
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
              ),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15.r),
                topRight: Radius.circular(15.r),
              ),
            ),
            child: Padding(
              padding: EdgeInsets.only(bottom: 20.h, top: 3.h),
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
