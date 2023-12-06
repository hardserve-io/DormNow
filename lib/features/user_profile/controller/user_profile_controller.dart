import 'dart:io';

// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dormnow/core/providers/storage_repository_provider.dart';
import 'package:dormnow/core/utils.dart';
import 'package:dormnow/features/auth/controller/auth_controller.dart';
import 'package:dormnow/features/user_profile/repository/user_profile_repository.dart';
import 'package:dormnow/models/post_model.dart';
import 'package:dormnow/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';

final userProfileControllerProvider = StateNotifierProvider<UserProfileController, bool>((ref) {
  final userProfileRepository = ref.watch(userProfileRepositoryProvider);
  final storageRepository = ref.watch(storageRepositoryProvider);
  return UserProfileController(
    userProfileRepository: userProfileRepository,
    ref: ref,
    storageRepository: storageRepository,
  );
});

class UserProfileController extends StateNotifier<bool> {
  final UserProfileRepository _userProfileRepository;
  final Ref _ref;
  final StorageRepository _storageRepository;

  UserProfileController(
      {required UserProfileRepository userProfileRepository,
      required Ref ref,
      required StorageRepository storageRepository})
      : _userProfileRepository = userProfileRepository,
        _ref = ref,
        _storageRepository = storageRepository,
        super(false);

  void editProfile(
      {required File? profileFile,
      required BuildContext context,
      required String name,
      required String address,
      required String contact}) async {
    state = true;
    UserModel user = _ref.read(userProvider)!;
    if (profileFile != null) {
      final res = await _storageRepository.storeFile(path: 'users/profile', id: user.uid, file: profileFile);
      res.fold(
        (l) => showSnackBar(context, l.message),
        (r) => user = user.copyWith(profilePicture: r),
      );
    }

    user = user.copyWith(name: name, dfAddress: address, dfContact: contact);
    final res = await _userProfileRepository.editProfile(user);
    state = false;
    res.fold(
      (l) => showSnackBar(context, l.message),
      (r) {
        _ref.read(userProvider.notifier).update((state) => user);
        Routemaster.of(context).pop();
      },
    );
  }

  void addOrRemoveFromFavorites(BuildContext context, String postId) async {
    UserModel user = _ref.read(userProvider)!;
    final res = await _userProfileRepository.addOrRemoveFromFavorites(postId, user);
    res.fold((l) => showSnackBar(context, l.message), (r) {
      if (user.likedMarketAdverts.contains(postId)) {
        user = user.copyWith(likedMarketAdverts: List.of(user.likedMarketAdverts)..remove(postId));
      } else {
        user = user.copyWith(likedMarketAdverts: List.of(user.likedMarketAdverts)..add(postId));
      }
      _ref.read(userProvider.notifier).update((state) => user);
    });
  }

  void addToCreatedPosts(BuildContext context, String postId) async {
    UserModel user = _ref.read(userProvider)!;
    final res = await _userProfileRepository.addToCreatedPosts(postId, user);
    res.fold((l) => showSnackBar(context, l.message), (r) {
      user = user.copyWith(marketAdverts: List.of(user.marketAdverts)..add(postId));
      _ref.read(userProvider.notifier).update((state) => user);
    });
  }

  void removeFromCreatedPosts(BuildContext context, String postId) async {
    UserModel user = _ref.read(userProvider)!;
    final res = await _userProfileRepository.addToCreatedPosts(postId, user);
    res.fold((l) => showSnackBar(context, l.message), (r) {
      user = user.copyWith(marketAdverts: List.of(user.marketAdverts)..remove(postId));
      _ref.read(userProvider.notifier).update((state) => user);
    });
  }

  void repoRemoveFromFavorites(String postId) async {
    UserModel user = _ref.read(userProvider)!;
    final res = await _userProfileRepository.addOrRemoveFromFavorites(postId, user);
    res.fold((l) => debugPrint(l.message), (r) {
      if (user.likedMarketAdverts.contains(postId)) {
        user = user.copyWith(likedMarketAdverts: List.of(user.likedMarketAdverts)..remove(postId));
      } else {
        user = user.copyWith(likedMarketAdverts: List.of(user.likedMarketAdverts)..add(postId));
      }
      _ref.read(userProvider.notifier).update((state) => user);
    });
  }

  // Future<(List<Post>, int)> getPosts(int startAfter) async {
  //   UserModel user = _ref.read(userProvider)!;

  //   const docLimit = 2;
  //   final a = user.likedMarketAdverts.sublist(startAfter, startAfter + docLimit);
  //   print("cont: $a, $startAfter, $docLimit");
  //   try {
  //     final snap = await _userProfileRepository.getPosts(
  //       limit: docLimit,
  //       postIds: user.likedMarketAdverts.sublist(startAfter, startAfter + docLimit),
  //       startAfter: startAfter,
  //     );
  //     print(snap.docs);
  //     return (
  //       snap.docs.map((e) => Post.fromMap(e.data() as Map<String, dynamic>)).toList(),
  //       startAfter + docLimit,
  //     );
  //   } on RangeError catch (e) {
  //     return (<Post>[], -1);
  //   }
  // }

  Future<List<Post>> getFavPosts(int start, int end) async {
    List<String> favList = _ref.read(userProvider)!.likedMarketAdverts.reversed.toList();
    print(favList);
    List<String> postIds;
    if (favList.length > start) {
      if (end >= favList.length + 1) end = favList.length;
    } else {
      return <Post>[];
    }
    //print("$start :: $end :: ${favList.length}");
    postIds = favList.sublist(start, end);
    final res = await _userProfileRepository.getFavMyPosts(postIds: postIds);
    List<Post> favPosts = [];
    for (final r in res) {
      r.fold(
        (l) => {
          //_ref.read(userProfileControllerProvider.notifier).repoRemoveFromFavorites(l.message),
          print('left')
        },
        (r) => {
          favPosts.add(r),
        },
      );
    }
    return favPosts;
  }

  // Future<(List<Post>, List<QueryDocumentSnapshot<Object?>>?)> getMyPosts(DocumentSnapshot? startAfter) async {
  //   final uid = _ref.read(userProvider)!.uid;
  //   const docLimit = 5;
  //   final snap = await _userProfileRepository.getMyPosts(limit: docLimit, startAfter: startAfter, uid: uid);
  //   final lastEL = snap.docs;
  //   return (snap.docs.map((e) => Post.fromMap(e.data() as Map<String, dynamic>)).toList(), lastEL);
  // }

  Future<List<Post>> getMyPosts(int start, int end) async {
    List<String> myList = _ref.read(userProvider)!.marketAdverts.reversed.toList();
    print(myList);
    List<String> postIds;
    if (myList.length > start) {
      if (end >= myList.length + 1) end = myList.length;
    } else {
      return <Post>[];
    }
    //print("$start :: $end :: ${favList.length}");
    postIds = myList.sublist(start, end);
    final res = await _userProfileRepository.getFavMyPosts(postIds: postIds);
    List<Post> favPosts = [];
    for (final r in res) {
      r.fold(
        (l) => {
          _ref.read(userProfileControllerProvider.notifier).repoRemoveFromFavorites(l.message),
        },
        (r) => {
          favPosts.add(r),
        },
      );
    }
    return favPosts;
  }
}
