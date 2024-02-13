// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:lakbay/core/constants/firebase_constants.dart';
import 'package:lakbay/core/failure.dart';
import 'package:lakbay/core/providers/firebase_providers.dart';
import 'package:lakbay/core/typdef.dart';
import 'package:lakbay/core/util/utils.dart';
import 'package:lakbay/models/listing_model.dart';
import 'package:lakbay/models/subcollections/listings_bookings_model.dart';

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

  // Update
  FutureVoid updateListing(ListingModel listing) async {
    debugPrintJson(listing);
    try {
      return right(await _listings.doc(listing.uid!).update(listing.toJson()));
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

  // Read all listing by CoopID
  Stream<List<ListingModel>> readListingsByCoopId(String coopId) {
    return _listings
        .where('cooperative.cooperativeId', isEqualTo: coopId)
        .snapshots()
        .map((snapshot) {
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

  CollectionReference bookings(String listingId) {
    return _listings
        .doc(listingId)
        .collection(FirebaseConstants.bookingsSubCollection);
  }

  // Add a booking in bookingss subcollection
  FutureEither<String> addBooking(
      String listingId, ListingBookings booking) async {
    try {
      // Generate a new document ID based on the user's ID
      var doc = bookings(listingId).doc();

      // Update the uid of the cooperative
      booking = booking.copyWith(id: doc.id);

      // Add the cooperative to the database
      await doc.set(booking.toJson());

      // Return the uid of the newly added cooperative
      return right(doc.id);
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

// Update
  FutureVoid updateBooking(String listingId, ListingBookings booking) async {
    try {
      return right(
          await bookings(listingId).doc(booking.id).update(booking.toJson()));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

// read bookings
  Stream<List<ListingBookings>> readBookings(listingId) {
    return bookings(listingId).snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return ListingBookings.fromJson(doc.data() as Map<String, dynamic>);
      }).toList();
    });
  }

  // read booking by id
  Stream<ListingBookings> readBookingById(listingId, bookingId) {
    return bookings(listingId).doc(bookingId).snapshots().map((snapshot) {
      return ListingBookings.fromJson(snapshot.data() as Map<String, dynamic>);
    });
  }
  

  // Read a bookings with certain RoomId in subcollection
  Stream<List<ListingBookings>> readBookingsByRoomId(
      String listingId, String roomId) {
    return bookings(listingId)
        .where("roomId", isEqualTo: roomId)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return ListingBookings.fromJson(doc.data() as Map<String, dynamic>);
      }).toList();
    });
  }
}
