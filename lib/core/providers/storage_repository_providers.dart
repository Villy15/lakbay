import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:lakbay/core/failure.dart';
import 'package:lakbay/core/providers/firebase_providers.dart';
import 'package:lakbay/core/typdef.dart';

final storageRepositoryProvider = Provider(
  (ref) => StorageRepository(
    firebaseStorage: ref.watch(storageProvider),
  ),
);

class StorageRepository {
  final FirebaseStorage _firebaseStorage;

  StorageRepository({required FirebaseStorage firebaseStorage})
      : _firebaseStorage = firebaseStorage;

  // Retrieve single file from firebase storage
  FutureEither<File> retrieveFile({
    required String path,
    required String id,
  }) async {
    try {
      final ref = _firebaseStorage.ref().child(path).child(id);

      final url = await ref.getDownloadURL();

      return right(File(url));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }


  // Store single file to firebase storage
  FutureEither<String> storeFile({
    required String path,
    required String id,
    required File? file,
  }) async {
    try {
      final ref = _firebaseStorage.ref().child(path).child(id);

      UploadTask uploadTask = ref.putFile(file!);

      final snapshot = await uploadTask;

      return right(await snapshot.ref.getDownloadURL());
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  // Store multiple files to firebase storage
  FutureEither<List<String>> storeFiles({
    required String path,
    required List<String> ids,
    required List<File?> files,
  }) async {
    try {
      List<UploadTask> uploadTasks = [];

      for (var i = 0; i < files.length; i++) {
        final ref = _firebaseStorage.ref().child(path).child(ids[i]);
        uploadTasks.add(ref.putFile(files[i]!));
      }

      final snapshot = await Future.wait(uploadTasks);

      List<String> urls = [];

      for (var task in snapshot) {
        urls.add(await task.ref.getDownloadURL());
      }

      return right(urls);
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  FutureEither<List<List<String>>> storeListNestedFiles({
    required String path,
    required List<String> ids,
    required List<List<File?>> filesLists,
  }) async {
    try {
      List<List<String>> allUrls = [];

      for (var i = 0; i < filesLists.length; i++) {
        List<UploadTask> uploadTasks = [];
        List<String> urls = [];

        for (var j = 0; j < filesLists[i].length; j++) {
          final ref = _firebaseStorage.ref().child(path).child('${ids[i]}_$j');
          uploadTasks.add(ref.putFile(filesLists[i][j]!));
        }

        final snapshots = await Future.wait(uploadTasks);

        for (var task in snapshots) {
          urls.add(await task.ref.getDownloadURL());
        }

        allUrls.add(urls);
      }

      return right(allUrls);
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }
}
