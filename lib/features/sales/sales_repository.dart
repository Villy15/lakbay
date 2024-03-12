// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:lakbay/core/constants/firebase_constants.dart';
import 'package:lakbay/core/failure.dart';
import 'package:lakbay/core/providers/firebase_providers.dart';
import 'package:lakbay/core/typdef.dart';
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

  // Update
  FutureVoid updateSale(SaleModel sale) async {
    try {
      return right(await _sales.doc(sale.uid!).update(sale.toJson()));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  // Real all sales
  Stream<List<SaleModel>> readSales() {
    return _sales.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return SaleModel.fromJson(doc.data() as Map<String, dynamic>);
      }).toList();
    });
  }

  // Read all sales by CoopID
  Stream<List<SaleModel>> readSalesByCoopId(String coopId) {
    return _sales
        .where('cooperativeId', isEqualTo: coopId)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return SaleModel.fromJson(doc.data() as Map<String, dynamic>);
      }).toList();
    });
  }

  // Read sale by bookingId
  Stream<SaleModel> readSaleByBookingId(String bookingId) {
    return _sales
        .where('bookingId', isEqualTo: bookingId)
        .snapshots()
        .map((snapshot) {
      return SaleModel.fromJson(
          snapshot.docs.first.data() as Map<String, dynamic>);
    });
  }

  // Read sale
  Stream<SaleModel> readSale(String uid) {
    return _sales.doc(uid).snapshots().map((snapshot) {
      return SaleModel.fromJson(snapshot.data() as Map<String, dynamic>);
    });
  }

  CollectionReference get _sales =>
      _firestore.collection(FirebaseConstants.salesCollection);
}
