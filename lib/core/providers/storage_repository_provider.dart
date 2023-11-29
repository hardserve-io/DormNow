import 'dart:io';

import 'package:dormnow/core/failure.dart';
import 'package:dormnow/core/providers/firebase_providers.dart';
import 'package:dormnow/core/type_defs.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';

final storageRepositoryProvider = Provider(
  (ref) => StorageRepository(
    firebaseStorage: ref.watch(storageProvider),
  ),
);

class StorageRepository {
  final FirebaseStorage _firebaseStorage;

  StorageRepository({required FirebaseStorage firebaseStorage}) : _firebaseStorage = firebaseStorage;

  FutureEither<String> storeFile({
    required String path,
    required String id,
    required File? file,
  }) async {
    try {
      print(file!.path);
      final ref = _firebaseStorage.ref().child(path).child(id);

      UploadTask uploadTask = ref.putFile(file);

      final snapshot = await uploadTask;
      return right(await snapshot.ref.getDownloadURL());
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  Future<List<Either<Failure, String>>> uploadFiles({
    required String path,
    required List<String> id,
    required List<File> images,
  }) async {
    var imageUrls = await Future.wait(
        images.asMap().entries.map((image) => storeFile(path: path, file: image.value, id: id[image.key])));
    print(imageUrls);
    return imageUrls;
  }
}
