import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dormnow/core/common/lazy_load_scrollview.dart';
import 'package:dormnow/features/auth/controller/auth_controller.dart';
import 'package:dormnow/features/posts/controller/post_controller.dart';
import 'package:dormnow/models/post_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  bool isLoadingList = false;
  bool moreToLoad = true;
  List<Post> listDocument = [];
  QueryDocumentSnapshot<Object?>? lastEl;
  final scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    print(2);
    loadPosts();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  void navigateToCreatePost(BuildContext context) {
    Routemaster.of(context).push('/add-post');
  }

  void loadPosts() async {
    print(1);

    if (moreToLoad) {
      setState(() {
        isLoadingList = true;
      });
      final (newDocs, lastElement) = await ref.read(postContollerProvider.notifier).getPosts(lastEl);

      if (lastElement == null || newDocs.isEmpty) {
        moreToLoad = false;
      } else {
        lastEl = lastElement.last;
        listDocument.addAll(newDocs);
      }
      print(newDocs.map((e) => e.title).toString());
      setState(() {
        isLoadingList = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider)!;

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => navigateToCreatePost(context),
        heroTag: null,
        child: const Icon(Icons.add),
      ),
      body: Container(
          child: Column(
        children: [
          Expanded(
            child: LazyLoadScrollView(
                isLoading: isLoadingList,
                onEndOfPage: loadPosts,
                child: ListView.builder(
                  physics: AlwaysScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: listDocument.length,
                  itemBuilder: (context, index) {
                    final Post post = listDocument[index];
                    return SizedBox(
                      height: 200,
                      child: Text(post.title),
                    );
                  },
                )),
          )
        ],
      )),
    );
  }
}
