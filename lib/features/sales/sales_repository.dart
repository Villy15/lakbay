// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:lakbay/core/constants/firebase_constants.dart';
import 'package:lakbay/core/failure.dart';
import 'package:lakbay/core/providers/firebase_providers.dart';
import 'package:lakbay/core/typdef.dart';
import 'package:lakbay/models/listing_model.dart';
import 'package:lakbay/models/sale_model.dart';

final salesRepositoryProvider = Provider((ref) {
  return SalesRepository(firestore: ref.watch(firestoreProvider));
});

class SalesRepository {
  final FirebaseFirestore _firestore;
  SalesRepository({
    required FirebaseFirestore firestore,
  }) : _firestore = firestore;

  FutureEither<String> addSale(SaleModel sale) async {
    try {
      var doc = _sales.doc();

      sale = sale.copyWith(uid: doc.id);

      await doc.set(sale.toJson());

      return right(sale.uid!);
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  // Real all sales
  Stream<List<ListingModel>> readSales() {
    return _sales.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return ListingModel.fromJson(doc.data() as Map<String, dynamic>);
      }).toList();
    });
  }

  // Read all sales by CoopID
  Stream<List<ListingModel>> readSalesByCoopId(String coopId) {
    return _sales
        .where('cooperative.cooperativeId', isEqualTo: coopId)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return ListingModel.fromJson(doc.data() as Map<String, dynamic>);
      }).toList();
    });
  }

  // Read sale
  Stream<ListingModel> readSale(String uid) {
    return _sales.doc(uid).snapshots().map((snapshot) {
      return ListingModel.fromJson(snapshot.data() as Map<String, dynamic>);
    });
  }

  CollectionReference get _sales =>
      _firestore.collection(FirebaseConstants.listingsCollection);
}
