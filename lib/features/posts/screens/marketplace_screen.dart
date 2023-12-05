import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dormnow/core/common/lazy_load.dart';
import 'package:dormnow/core/common/lazy_load_scrollview.dart';
import 'package:dormnow/core/common/loader.dart';
import 'package:dormnow/features/auth/controller/auth_controller.dart';
import 'package:dormnow/features/posts/controller/post_controller.dart';
import 'package:dormnow/features/posts/screens/post_miniature.dart';
import 'package:dormnow/features/posts/screens/search_screen.dart';
import 'package:dormnow/models/post_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:routemaster/routemaster.dart';

class MarketPlaceScreen extends ConsumerStatefulWidget {
  const MarketPlaceScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MarketPlaceScreenState();
}

class _MarketPlaceScreenState extends ConsumerState<MarketPlaceScreen> {
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
    final loading = ref.watch(refreshNotifier);
    print('!!');
    print(loading);
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xffFFCE0C),
        onPressed: () => navigateToCreatePost(context),
        heroTag: null,
        //color: Color(519872),
        child: const Icon(
          Icons.add,
        ),
      ),
      body: NestedScrollView(
        physics: BouncingScrollPhysics(),
        headerSliverBuilder: (_, __) => [
          SliverAppBar(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            pinned: true,
            floating: false,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 250.w,
                  alignment: Alignment.center,
                ),
              ],
            ),
            expandedHeight: 200.h,
            flexibleSpace: FlexibleSpaceBar(
              background: SvgPicture.asset(
                fit: BoxFit.cover,
                'assets/images/marketplace_banner.svg',
              ),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    padding: EdgeInsets.only(left: 20),
                    width: 190.w,
                    height: 12.h,
                    alignment: Alignment.bottomLeft,
                    child: SvgPicture.asset(
                      'assets/images/marketplace_text.svg',
                      alignment: Alignment.bottomLeft,
                    ),
                  ),
                  Container(
                    width: 40.w,
                    height: 20.h,
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      constraints: BoxConstraints(),
                      icon: SvgPicture.asset(
                        'assets/images/lupa.svg',
                        fit: BoxFit.contain,
                      ),
                      onPressed: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => SearchScreen(),
                        ),
                      ),
                      alignment: Alignment.bottomLeft,
                    ),
                  ),
                ],
              ),
              titlePadding: EdgeInsets.only(bottom: 20),
            ),
          ),
        ],
        body: LazyLoadWidget(
          loadFrom: ref.watch(postContollerProvider.notifier).getPosts,
        ),
      ),
    );
  }
}
