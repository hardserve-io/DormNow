import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dormnow/core/failure.dart';
import 'package:dormnow/core/providers/storage_repository_provider.dart';
import 'package:dormnow/core/utils.dart';
import 'package:dormnow/features/auth/controller/auth_controller.dart';
import 'package:dormnow/features/posts/repository/post_repository.dart';
import 'package:dormnow/models/post_model.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fuzzywuzzy/fuzzywuzzy.dart';
import 'package:routemaster/routemaster.dart';
import 'package:uuid/uuid.dart';

final postContollerProvider = StateNotifierProvider<PostContoller, bool>((ref) {
  final postRepository = ref.watch(postRepositoryProvider);
  final storageRepository = ref.watch(storageRepositoryProvider);
  return PostContoller(
    postRepository: postRepository,
    ref: ref,
    storageRepository: storageRepository,
  );
});

final getPostByIdProvider = StreamProvider.autoDispose.family((ref, String postId) {
  final postConctoller = ref.watch(postContollerProvider.notifier);
  return postConctoller.getPostById(postId);
});

final refreshNotifier = StateProvider<bool>((ref) => false);

class PostContoller extends StateNotifier<bool> {
  final PostRepository _postRepository;
  final Ref _ref;
  final StorageRepository _storageRepository;

  PostContoller({
    required PostRepository postRepository,
    required Ref ref,
    required StorageRepository storageRepository,
  })  : _ref = ref,
        _storageRepository = storageRepository,
        _postRepository = postRepository,
        super(false);

  void createPost({
    required BuildContext context,
    required String title,
    required String description,
    required List<String> files,
    required double? price,
    required bool isFree,
    required String contacts,
    required String? address,
    required String? dorm,
    required int? floor,
    required String? room,
  }) async {
    state = true;
    List<String> filesId = [];
    String postId = Uuid().v1();
    final user = _ref.read(userProvider)!;
    List<String> pictures = [];
    int fails = 0;
    String failMessages = "";
    final List<File> filesForFirebase = [];

    for (final file in files) {
      filesForFirebase.add(File(file));
      filesId.add(Uuid().v1());
      // imageResult.fold((l) {
      //   fails++;
      //   failMessages += l.message;
      // }, (r) => pictures.add(r));
    }

    final imageResult =
        await _storageRepository.uploadFiles(path: 'posts/$postId', id: filesId, images: filesForFirebase);

    for (final res in imageResult) {
      res.fold((l) {
        fails++;
        failMessages += l.message;
      }, (r) => pictures.add(r));
    }

    if (fails == 0) {
      final Post post = Post(
        id: postId,
        title: title,
        description: description,
        price: price,
        isFree: isFree,
        contacts: contacts,
        authorUsername: user.name,
        authorUid: user.uid,
        createdAt: DateTime.now(),
        pictures: pictures,
      );

      final res = await _postRepository.addPost(post);
      state = false;
      res.fold(
        (l) => showSnackBar(context, l.message),
        (r) {
          showSnackBar(context, 'Posted successfully');
          Routemaster.of(context).pop();
        },
      );
    } else {
      if (context.mounted) {
        showSnackBar(context, "There were $fails errors. Details: $failMessages");
      } else {
        print('Error: context not mounted @create_post() @PostController');
      }
    }
  }

  void editPost({
    required Post oldPost,
    required BuildContext context,
    required String title,
    required String description,
    required List<String> files,
    required double? price,
    required bool isFree,
    required String contacts,
    required String? address,
    required String? dorm,
    required int? floor,
    required String? room,
  }) async {
    state = true;
    List<String> filesId = [];
    final user = _ref.read(userProvider)!;
    //List<String> pictures = [];
    int fails = 0;
    String failMessages = "";
    final List<File> filesForFirebase = [];
    List<String> deletedUrls = [];
    List<String> keptUrls = [];
    List<String> newUrls = [];
    for (final url in oldPost.pictures) {
      if (files.contains(url)) {
        keptUrls.add(url);
      } else {
        deletedUrls.add(url);
      }
    }
    for (final url in files) {
      if (!url.startsWith('http')) {
        filesForFirebase.add(File(url));
        filesId.add(Uuid().v1());
      }
    }
    // for (final file in files) {
    //   filesForFirebase.add(File(file));
    //   filesId.add(Uuid().v1());
    //   // imageResult.fold((l) {
    //   //   fails++;
    //   //   failMessages += l.message;
    //   // }, (r) => pictures.add(r));
    // }

    final imageResult =
        await _storageRepository.uploadFiles(path: 'posts/${oldPost.id}', id: filesId, images: filesForFirebase);

    for (final res in imageResult) {
      res.fold((l) {
        fails++;
        failMessages += l.message;
      }, (r) => keptUrls.add(r));
    }

    if (fails == 0) {
      final Post post = Post(
        id: oldPost.id,
        title: title,
        description: description,
        price: price,
        isFree: isFree,
        contacts: contacts,
        authorUsername: oldPost.authorUsername,
        authorUid: user.uid,
        address: address,
        createdAt: oldPost.createdAt,
        pictures: keptUrls,
      );

      final res = await _postRepository.editPost(post);
      state = false;
      res.fold(
        (l) => showSnackBar(context, l.message),
        (r) {
          showSnackBar(context, 'Updated successfully');
          Routemaster.of(context).history.back();
        },
      );
    } else {
      if (context.mounted) {
        showSnackBar(context, "There were $fails errors. Details: $failMessages");
      } else {
        print('Error: context not mounted @create_post() @PostController');
      }
    }
  }

  Future<(List<Post>, List<QueryDocumentSnapshot<Object?>>?)> getPosts(DocumentSnapshot? startAfter) async {
    const docLimit = 5;
    final snap = await _postRepository.getPosts(limit: docLimit, startAfter: startAfter);
    final lastEL = snap.docs;
    return (snap.docs.map((e) => Post.fromMap(e.data() as Map<String, dynamic>)).toList(), lastEL);
  }

  Stream<Post> getPostById(String postId) {
    return _postRepository.getPostById(postId);
  }

  void deletePost(String postId, BuildContext context) async {
    Routemaster.of(context).pop();
    final res = await _postRepository.deletePost(postId);
    res.fold((l) => null, (r) {
      _ref.read(refreshNotifier.notifier).update((state) => true);
    });
  }

  Future<bool> doesPostExist(String postId) async {
    return await _postRepository.doesPostExist(postId);
  }

  // Future<(List<Post>, List<QueryDocumentSnapshot<Object?>>?)> searchPosts(
  //     String query, DocumentSnapshot? startAfter) async {
  //   const docLimit = 5;
  //   final snap = await _postRepository.searchPosts(query: query, limit: docLimit, startAfter: startAfter);
  //   final lastEL = snap.docs;
  //   print(snap.docs.map((e) => Post.fromMap(e.data() as Map<String, dynamic>)).toList());
  //   return (snap.docs.map((e) => Post.fromMap(e.data() as Map<String, dynamic>)).toList(), lastEL);
  // }

  Future<List<Post>> searchPosts(String query) async {
    final res = await _postRepository.searchPosts(query);
    List<Post> resMatch = [];
    res.forEach((element) {
      final result = extractOne(
        query: query,
        choices: [element.title],
      );
      if (result.score >= 80) {
        resMatch.add(element);
      }
    });
    print('??');
    print(res.map((e) => e.title));
    return resMatch;
  }
}
