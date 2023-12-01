import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dormnow/core/common/lazy_load.dart';
import 'package:dormnow/core/common/lazy_load_scrollview.dart';
import 'package:dormnow/core/common/loader.dart';
import 'package:dormnow/features/auth/controller/auth_controller.dart';
import 'package:dormnow/features/posts/controller/post_controller.dart';
import 'package:dormnow/features/posts/screens/post_miniature.dart';
import 'package:dormnow/models/post_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:routemaster/routemaster.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  void navigateToCreatePost(BuildContext context) {
    Routemaster.of(context).push('/add-post');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => navigateToCreatePost(context),
        heroTag: null,
        child: const Icon(Icons.add),
      ),
      body: NestedScrollView(
        physics: BouncingScrollPhysics(),
        headerSliverBuilder: (_, __) => [
          SliverAppBar(
            pinned: true,
            floating: false,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 250.w,
                  alignment: Alignment.center,
                  /*child: SvgPicture.asset(
                      './assets/images/barahoholka.svg',
                      alignment: Alignment.centerLeft,
                    ),*/
                ),
                // Icon(Icons.search),
              ],
            ),
            expandedHeight: 200.h,
            flexibleSpace: FlexibleSpaceBar(
              background: SvgPicture.asset(
                fit: BoxFit.cover,
                'assets/images/green_marketplace_banner.svg',
              ),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    padding: EdgeInsets.only(left: 20),
                    width: 190.w,
                    alignment: Alignment.bottomLeft,
                    child: SvgPicture.asset(
                      'assets/images/barahoholka.svg',
                      alignment: Alignment.bottomLeft,
                      width: 200.w,
                      //alignment: Alignment.bottomLeft,
                    ),
                  ),
                  Container(
                    width: 40.w,
                    child: SvgPicture.asset('assets/images/lupa.svg'),
                    alignment: Alignment.bottomLeft,
                  ),
                ],
              ),
              //centerTitle: true,
              titlePadding: EdgeInsets.only(bottom: 20),
            ),
            //bottom:
          ),
        ],
        body: NotificationListener<ScrollNotification>(
          onNotification: (notification) {
            if (notification is ScrollEndNotification) {
              if (notification.metrics.pixels ==
                  notification.metrics.maxScrollExtent) {
                loadPosts();
              }
            }
            return true;
          },
          child: RefreshIndicator(
            onRefresh: refresh,
            child: Padding(
              padding: EdgeInsets.only(left: 25, right: 25),
              child: ListView.builder(
                physics: BouncingScrollPhysics(),
                shrinkWrap: true,
                itemCount: listDocument.length + 1,
                itemBuilder: (context, index) {
                  if (index < listDocument.length) {
                    final Post post = listDocument[index];
                    final key = UniqueKey();
                    return OrderMiniature(order: post, key: key);
                  } else {
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 32),
                      child: Loader(),
                    );
                  }
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
