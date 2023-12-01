import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dormnow/core/common/loader.dart';
import 'package:dormnow/features/posts/controller/post_controller.dart';
import 'package:dormnow/features/posts/screens/post_miniature.dart';
import 'package:dormnow/models/post_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LazyLoadWidget extends ConsumerStatefulWidget {
  final Future<(List<Post>, List<QueryDocumentSnapshot<Object?>>?)> Function(QueryDocumentSnapshot<Object?>?) loadFrom;
  const LazyLoadWidget({super.key, required this.loadFrom});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LazyLoadWidgetState();
}

class _LazyLoadWidgetState extends ConsumerState<LazyLoadWidget> {
  bool moreToLoad = true;
  bool isLoadingList = false;
  List<Post> listDocument = [];
  QueryDocumentSnapshot<Object?>? lastEl;

  void loadPosts([bool refresh = false]) async {
    print('Loading posts...');

    if (!refresh) {
      setState(() {
        isLoadingList = true;
      });
    }
    final (newDocs, lastElement) = await widget.loadFrom(lastEl);

    if (newDocs.isNotEmpty) {
      lastEl = lastElement!.last;
      listDocument.addAll(newDocs);
    }

    setState(() {
      isLoadingList = false;
    });
  }

  Future<void> refresh() {
    listDocument = [];
    lastEl = null;
    loadPosts(true);
    return Future(() => null);
  }

  @override
  void initState() {
    loadPosts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        if (notification is ScrollEndNotification) {
          if (notification.metrics.pixels == notification.metrics.maxScrollExtent) {
            loadPosts();
          }
        }
        return true;
      },
      child: RefreshIndicator(
        onRefresh: refresh,
        child: Padding(
          padding: const EdgeInsets.only(left: 25, right: 25),
          child: ListView.builder(
            physics: const BouncingScrollPhysics(),
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
    );
  }
}
