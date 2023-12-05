import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dormnow/core/constants/firebase_constants.dart';
import 'package:dormnow/core/failure.dart';
import 'package:dormnow/core/providers/firebase_providers.dart';
import 'package:dormnow/core/type_defs.dart';
// import 'package:dormnow/features/user_profile/controller/user_profile_controller.dart';
import 'package:dormnow/models/post_model.dart';
import 'package:dormnow/models/user_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
// import 'package:quiver/iterables.dart';
// import 'package:rxdart/transformers.dart';

final userProfileRepositoryProvider = Provider((ref) {
  return UserProfileRepository(firestore: ref.watch(firestoreProvider));
});

class UserProfileRepository {
  final FirebaseFirestore _firestore;
  UserProfileRepository({required FirebaseFirestore firestore})
      : _firestore = firestore;

  CollectionReference get _users =>
      _firestore.collection(FirebaseConstants.usersCollection);
  CollectionReference get _posts =>
      _firestore.collection(FirebaseConstants.postsCollection);

  FutureVoid editProfile(UserModel user) async {
    try {
      return right(_users.doc(user.uid).update(user.toMap()));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  FutureVoid addOrRemoveFromFavorites(String postId, UserModel user) async {
    try {
      if (user.likedMarketAdverts.contains(postId)) {
        return right(_users.doc(user.uid).update({
          'likedMarketAdverts': FieldValue.arrayRemove([postId])
        }));
      } else {
        return right(_users.doc(user.uid).update({
          'likedMarketAdverts': FieldValue.arrayUnion([postId])
        }));
      }
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  // Future<List<Post>> getPosts({required List<String> postIds}) async {
  //   print(1);
  //   final fetchedPosts =
  //       _posts.where('id', whereIn: postIds.isEmpty ? [0] : postIds).orderBy('createdAt', descending: true);
  //   print("repo: $postIds");
  //   final res = await fetchedPosts.get();
  //   return res.docs.map((e) => Post.fromMap(e.data() as Map<String, dynamic>)).toList();
  // }

  FutureEither<Post> getFavPost({required String postIds}) async {
    final fetchedPosts = _posts.where("id", isEqualTo: postIds);

    final res = await fetchedPosts.get();

    final resDone = res.docs
        .map((e) => Post.fromMap(e.data() as Map<String, dynamic>))
        .toList();
    if (resDone.isEmpty) {
      return left(Failure(postIds));
    }
    return right(resDone.first);
  }

  Future<List<Either<Failure, Post>>> getFavPosts({
    required List<String> postIds,
  }) async {
    var posts = await Future.wait(postIds
        .asMap()
        .entries
        .map((postId) => getFavPost(postIds: postId.value)));
    print(posts.length);
    return posts;
  }

  // Future<List<QueryDocumentSnapshot>> listItems(List<dynamic> itemIds) async {
  //   final chunks = partition(itemIds, 10);
  //   final querySnapshots = await Future.wait(chunks.map((chunk) {
  //     Query itemsQuery =_posts.where("id", whereIn: chunk);
  //     return itemsQuery.get();
  //   }).toList());
  //   return querySnapshots == null
  //       ? []
  //       : await Stream.fromIterable(querySnapshots).flatMap((qs) => Stream.fromIterable(qs.docs)).toList();
  // }
}
