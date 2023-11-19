import 'dart:io';

import 'package:dormnow/core/utils.dart';
import 'package:dormnow/features/posts/controller/post_controller.dart';
import 'package:dormnow/models/post_model.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'post_miniature.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MarketplacePage extends StatefulWidget {
  const MarketplacePage({super.key, required this.orders});
  final List<Post> orders;

  @override
  State<MarketplacePage> createState() => _MarketplacePageState();
}

class _MarketplacePageState extends State<MarketplacePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade900,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: <Widget>[
          SliverAppBar(
            pinned: true,
            floating: false,
            backgroundColor: const Color(0xff001535),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 250.w,
                  alignment: Alignment.center,
                  child: SvgPicture.asset(
                    './assets/images/barahoholka.svg',
                    alignment: Alignment.centerLeft,
                  ),
                ),
                // Icon(Icons.search),
              ],
            ),
            expandedHeight: 200.h,
            flexibleSpace: FlexibleSpaceBar(
              background: SvgPicture.asset(
                fit: BoxFit.cover,
                './assets/images/noText.svg',
              ),
            ),
            //bottom:
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                Padding(
                  padding: EdgeInsets.only(left: 25, right: 25),
                  child: ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: widget.orders.length,
                    itemBuilder: (context, index) =>
                        OrderMiniature(order: widget.orders[index]),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
