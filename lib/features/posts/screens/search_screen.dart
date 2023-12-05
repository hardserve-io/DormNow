import 'package:dormnow/features/posts/screens/post_miniature.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});
  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _textController = TextEditingController();
  String searchQuery = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(
          //padding: EdgeInsets.symmetric(horizontal: 15),
          width: 300.w,
          height: 40.h,
          padding: EdgeInsets.only(
            left: 10,
            right: 10,
            top: 3,
            bottom: 5,
          ),
          decoration: BoxDecoration(
            color: Color(0xff16382B),
            borderRadius: BorderRadius.all(
              Radius.circular(20),
            ),
          ),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  height: 30.h,
                  width: 30.w,
                  child: SvgPicture.asset(
                    'assets/images/lupa.svg',
                    fit: BoxFit.contain,
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(right: 10),
                  height: 40.h,
                  width: 250.w,
                  child: TextField(
                    controller: _textController,
                    decoration: InputDecoration(
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Color(0xffFFCE0C)),
                      ),
                      suffixIconColor: Color(0xffFFCE0C),
                      suffixIcon: IconButton(
                        padding: EdgeInsets.zero,
                        constraints: BoxConstraints(),
                        icon: Icon(Icons.clear),
                        onPressed: () {
                          _textController.clear();
                        },
                      ),
                    ),
                    onSubmitted: (text) {
                      setState(
                        () {
                          searchQuery = text;
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: 10,
        itemBuilder: (context, index) => Container(
          child: Text(
            searchQuery,
            style: TextStyle(
              fontSize: 20,
              color: Colors.blueAccent,
            ),
          ),
          color: Colors.amber,
          width: 362.w,
          height: 200.h,
          margin: EdgeInsets.symmetric(vertical: 20),
          padding: EdgeInsets.symmetric(horizontal: 25),
        ),
      ),
    );
  }
}