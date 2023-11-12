import 'dart:io';

import 'package:dormnow/core/failure.dart';
import 'package:dormnow/core/providers/storage_repository_provider.dart';
import 'package:dormnow/core/utils.dart';
import 'package:dormnow/features/auth/controller/auth_controller.dart';
import 'package:dormnow/features/posts/repository/post_repository.dart';
import 'package:dormnow/models/post_model.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
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
    required List<PlatformFile> files,
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
      filesForFirebase.add(File(file.path!));
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
}
