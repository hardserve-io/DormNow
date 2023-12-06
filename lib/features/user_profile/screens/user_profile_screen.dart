import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dormnow/core/common/error_text.dart';
// import 'package:dormnow/core/common/lazy_load.dart';
import 'package:dormnow/core/common/loader.dart';
import 'package:dormnow/features/auth/controller/auth_controller.dart';
import 'package:dormnow/features/posts/screens/post_miniature.dart';
import 'package:dormnow/features/user_profile/controller/user_profile_controller.dart';
import 'package:dormnow/models/post_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:routemaster/routemaster.dart';
import 'package:autoscale_tabbarview/autoscale_tabbarview.dart';

class UserProfileScreen extends ConsumerStatefulWidget {
  final String? uid;
  const UserProfileScreen({super.key, required this.uid});

  @override
  ConsumerState<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends ConsumerState<UserProfileScreen> {
  late String uid;
  void navigateToEditUser(BuildContext context) {
    Routemaster.of(context).push('/edit-profile');
  }

  void logout(WidgetRef ref) {
    ref.read(authControllerProvider.notifier).logOut();
  }

  bool moreToLoad = true;
  bool isLoadingList = false;
  List<Post> listDocument = [];
  QueryDocumentSnapshot<Object?>? lastEl;

  final int step = 5;
  late int startPost;
  late int endPost;

  void loadPosts([bool refresh = false]) async {
    if (moreToLoad) {
      print('Loading posts...');

      if (!refresh) {
        setState(() {
          isLoadingList = true;
        });
      }

      final newDocs = await ref
          .read(userProfileControllerProvider.notifier)
          .getPosts(startPost, endPost);

      startPost = endPost;
      endPost += step;

      if (newDocs.isNotEmpty) {
        listDocument.addAll(newDocs);
        moreToLoad = true;
      } else {
        moreToLoad = false;
      }

      setState(() {
        isLoadingList = false;
      });
    }
  }

  Future<void> refresh() {
    listDocument = [];
    startPost = 0;
    endPost = step;
    lastEl = null;
    moreToLoad = true;
    loadPosts(true);
    return Future(() => null);
  }

  @override
  void initState() {
    startPost = 0;
    endPost = step;
    loadPosts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider)!;
    uid = widget.uid ?? user.uid;
    return Scaffold(
      body: ref.watch(getUserDataProvider(uid)).when(
            data: (user) => NestedScrollView(
              physics: const BouncingScrollPhysics(),
              headerSliverBuilder: (_, __) => [
                SliverAppBar(
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
                  ),
                  pinned: true,
                  floating: false,
                  expandedHeight: 200.h,
                  flexibleSpace: FlexibleSpaceBar(
                    background: SvgPicture.asset(
                      fit: BoxFit.cover,
                      'assets/images/user_profile_banner.svg',
                    ),
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          padding: const EdgeInsets.only(left: 20),
                          width: 190.w,
                          height: 15.h,
                          alignment: Alignment.bottomLeft,
                          child: SvgPicture.asset(
                            'assets/images/user_profile_text.svg',
                            alignment: Alignment.bottomLeft,
                            width: 200.w,
                          ),
                        ),
                        Container(
                          width: 40.w,
                          height: 20.h,
                          alignment: Alignment.bottomLeft,
                          // child: SvgPicture.asset('assets/images/lupa.svg'),
                        ),
                      ],
                    ),
                    titlePadding: const EdgeInsets.only(bottom: 20),
                  ),
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
                  color: const Color(0xff519872),
                  onRefresh: refresh,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 25, right: 25),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                height: 80.h,
                                width: 80.w,
                                margin:
                                    const EdgeInsets.only(top: 20, right: 10),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(80),
                                  child: Image.network(
                                    user.profilePicture,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(top: 20),
                                height: 150.h,
                                width: 245.w,
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      alignment: Alignment.bottomLeft,
                                      margin: const EdgeInsets.only(bottom: 5),
                                      child: Text(
                                        "${user.name}",
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        maxLines: 2,
                                      ),
                                    ),
                                    Container(
                                      alignment: Alignment.bottomLeft,
                                      margin: const EdgeInsets.only(bottom: 5),
                                      child: Text(
                                        "Адреса: ${user.dfAddress}",
                                        style: const TextStyle(
                                          fontSize: 14,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        maxLines: 2,
                                      ),
                                    ),
                                    Container(
                                      alignment: Alignment.bottomLeft,
                                      margin: const EdgeInsets.only(bottom: 10),
                                      child: Text(
                                        "Контакти: ${user.dfContact}",
                                        style: const TextStyle(
                                          fontSize: 14,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        maxLines: 2,
                                      ),
                                    ),
                                    Container(
                                      //margin: EdgeInsets.only(top: 40),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            margin:
                                                const EdgeInsets.only(right: 5),
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                width: 1,
                                                color: const Color(0xffFFCE0C),
                                              ),
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(20)),
                                            ),
                                            child: TextButton(
                                              onPressed: () =>
                                                  navigateToEditUser(context),
                                              child: const Text(
                                                'Редагувати профіль',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Container(
                                            //margin: EdgeInsets.only(top: 15),
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                width: 1,
                                                color: const Color(0xffFFCE0C),
                                              ),
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(20)),
                                            ),
                                            child: TextButton(
                                              onPressed: () => logout(ref),
                                              child: const Text(
                                                'Вийти',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 30),
                            child: DefaultTabController(
                              length: 2,
                              child: Column(
                                children: [
                                  const TabBar(
                                    indicatorColor: Color(0xffFFCE0C),
                                    tabs: [
                                      Tab(text: "Власні"),
                                      Tab(text: "Уподобані"),
                                    ],
                                  ),
                                  AutoScaleTabBarView(
                                    children: [
                                      ListView.builder(
                                        physics: const BouncingScrollPhysics(),
                                        shrinkWrap: true,
                                        itemCount: listDocument.length + 1,
                                        itemBuilder: (context, index) {
                                          if (index < listDocument.length) {
                                            final Post post =
                                                listDocument[index];
                                            final key = UniqueKey();
                                            return OrderMiniature(
                                              order: post,
                                              key: key,
                                              refreshParent: refresh,
                                            );
                                          } else {
                                            return Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 32),
                                              child: moreToLoad
                                                  ? const Loader()
                                                  : Container(),
                                            );
                                          }
                                        },
                                      ),
                                      ListView.builder(
                                        physics: const BouncingScrollPhysics(),
                                        shrinkWrap: true,
                                        itemCount: listDocument.length + 1,
                                        itemBuilder: (context, index) {
                                          if (index < listDocument.length) {
                                            final Post post =
                                                listDocument[index];
                                            final key = UniqueKey();
                                            return OrderMiniature(
                                              order: post,
                                              key: key,
                                              refreshParent: refresh,
                                            );
                                          } else {
                                            return Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 32),
                                              child: moreToLoad
                                                  ? const Loader()
                                                  : Container(),
                                            );
                                          }
                                        },
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            error: (error, stackTrace) => ErrorText(error: error.toString()),
            loading: () => const Loader(),
          ),
    );
  }
}
