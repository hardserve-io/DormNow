import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dormnow/core/constants/firebase_constants.dart';
import 'package:dormnow/core/failure.dart';
import 'package:dormnow/core/providers/firebase_providers.dart';
import 'package:dormnow/core/type_defs.dart';
import 'package:dormnow/models/post_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';

final postRepositoryProvider = Provider((ref) {
  return PostRepository(firestore: ref.watch(firestoreProvider));
});

class PostRepository {
  final FirebaseFirestore _firestore;

  PostRepository({required FirebaseFirestore firestore}) : _firestore = firestore;

  CollectionReference get _posts => _firestore.collection(FirebaseConstants.postsCollection);

  FutureVoid addPost(Post post) async {
    try {
      return right(_posts.doc(post.id).set(post.toMap()));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  FutureVoid editPost(Post post) async {
    try {
      return right(_posts.doc(post.id).update(post.toMap()));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  Stream<List<Post>> fetchPosts() {
    return _posts
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((event) => event.docs.map((e) => Post.fromMap(e.data() as Map<String, dynamic>)).toList());
  }

  Future<QuerySnapshot<Object?>> getPosts({required int limit, DocumentSnapshot? startAfter}) async {
    final Query<Object?> fetchedPosts;
    if (startAfter != null) {
      fetchedPosts = _posts.orderBy('createdAt', descending: true).limit(limit).startAfterDocument(startAfter);
    } else {
      fetchedPosts = _posts.orderBy('createdAt', descending: true).limit(limit);
    }
    return fetchedPosts.get();
  }

  Stream<Post> getPostById(String postId) {
    return _posts.doc(postId).snapshots().map((event) => Post.fromMap(event.data() as Map<String, dynamic>));
  }

  Future<bool> doesPostExist(String postId) async {
    final res = await _posts.doc(postId).get().then((value) {
      return value.exists;
    });
    return res;
  }

  FutureVoid deletePost(String postId) async {
    try {
      return right(_posts.doc(postId).delete());
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }
}
