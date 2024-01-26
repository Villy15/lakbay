import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:lakbay/core/constants/firebase_constants.dart';
import 'package:lakbay/core/failure.dart';
import 'package:lakbay/core/providers/firebase_providers.dart';
import 'package:lakbay/core/typdef.dart';
import 'package:lakbay/models/wiki_model.dart';

final wikiRepositoryProvider = Provider((ref) {
  return WikiRepository(firestore: ref.watch(firestoreProvider));
});

class WikiRepository {
  final FirebaseFirestore _firestore;

  WikiRepository({
    required FirebaseFirestore firestore,
  }) : _firestore = firestore;

  FutureEither<String> addWiki(WikiModel wiki) async {
    try {
      var doc = _wikis.doc();
      wiki = wiki.copyWith(uid: doc.id);
      await doc.set(wiki.toJson());
      return right(wiki.uid!);
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  Stream<List<WikiModel>> readWikis() {
    return _wikis.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return WikiModel.fromJson(doc.data() as Map<String, dynamic>);
      }).toList();
    });
  }

  Stream<WikiModel> readWiki(String uid) {
    return _wikis.doc(uid).snapshots().map((snapshot) {
      return WikiModel.fromJson(snapshot.data() as Map<String, dynamic>);
    });
  }

  FutureVoid updateWiki(WikiModel wiki) async {
    try {
      return right(await _wikis.doc(wiki.uid).update(wiki.toJson()));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  CollectionReference get _wikis =>
      _firestore.collection(FirebaseConstants.wikisCollection);
}
