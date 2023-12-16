// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:lakbay/core/constants/firebase_constants.dart';
import 'package:lakbay/core/failure.dart';
import 'package:lakbay/core/providers/firebase_providers.dart';
import 'package:lakbay/core/typdef.dart';
import 'package:lakbay/models/listing_model.dart';

final listingRepositoryProvider = Provider((ref) {
  return ListingRepository(firestore: ref.watch(firestoreProvider));
});

class ListingRepository {
  final FirebaseFirestore _firestore;
  ListingRepository({
    required FirebaseFirestore firestore,
  }) : _firestore = firestore;

  FutureEither<String> addListing(ListingModel listing) async {
    try {
      var doc = _listings.doc();

      listing = listing.copyWith(uid: doc.id);

      await doc.set(listing.toJson());

      return right(listing.uid!);
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  // Real all
  Stream<List<ListingModel>> readListings() {
    return _listings.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return ListingModel.fromJson(doc.data() as Map<String, dynamic>);
      }).toList();
    });
  }

  // Read
  Stream<ListingModel> readListing(String uid) {
    return _listings.doc(uid).snapshots().map((snapshot) {
      return ListingModel.fromJson(snapshot.data() as Map<String, dynamic>);
    });
  }

  // Update
  FutureVoid updateCoop(ListingModel coop) async {
    try {
      return right(await _listings.doc(coop.uid).update(coop.toJson()));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  CollectionReference get _listings =>
      _firestore.collection(FirebaseConstants.listingsCollection);
}
