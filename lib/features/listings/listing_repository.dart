// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:lakbay/core/constants/firebase_constants.dart';
import 'package:lakbay/core/failure.dart';
import 'package:lakbay/core/providers/firebase_providers.dart';
import 'package:lakbay/core/typdef.dart';
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

  // Read all listings by owner
  Stream<List<ListingModel>> readListingsByOwner(String ownerId) {
    return _listings
        .where('publisherId', isEqualTo: ownerId)
        .snapshots()
        .map((snapshot) {
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

  // Read room by properties
  Stream<List<ListingModel>> readListingsByProperties(Query query) {
    return query.snapshots().map((querySnapshot) {
      return querySnapshot.docs.map((doc) {
        return ListingModel.fromJson(doc.data()! as Map<String, dynamic>);
      }).toList();
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

      booking = booking.copyWith(id: doc.id);

      await doc.set(booking.toJson());

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

  // read task
  Stream<List<BookingTask>> readBookingTasks(String listingId) {
    return bookingTasksCollection(listingId).snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return BookingTask.fromJson(doc.data() as Map<String, dynamic>);
      }).toList();
    });
  }

// read booking by id
  Stream<ListingBookings> readBookingById(listingId, bookingId) {
    return bookings(listingId).doc(bookingId).snapshots().map((snapshot) {
      return ListingBookings.fromJson(snapshot.data() as Map<String, dynamic>);
    });
  }

  // Read all bookings by cooperativeId
  Stream<List<ListingBookings>> readBookingsByCoopId(String coopId) {
    return FirebaseFirestore.instance
        .collectionGroup(
            'bookings') // Perform collection group query for 'bookings'
        .where('cooperativeId', isEqualTo: coopId) // Filter by cooperativeId
        .snapshots()
        .map((querySnapshot) {
      // Convert each document snapshot to a ListingBookings object
      return querySnapshot.docs.map((doc) {
        return ListingBookings.fromJson(doc.data());
      }).toList();
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

  // Read bookings by customer ID
  Stream<List<ListingBookings>> readBookingsByCustomerId(String customerId) {
    return FirebaseFirestore.instance
        .collectionGroup(
            'bookings') // Perform collection group query for 'bookings'
        .where('customerId', isEqualTo: customerId) // Filter by customerId
        .snapshots()
        .map((querySnapshot) {
      // Convert each document snapshot to a ListingBookings object
      return querySnapshot.docs.map((doc) {
        return ListingBookings.fromJson(doc.data());
      }).toList();
    });
  }

  // Read bookings by category and only gets bookings where the endDate is less than my startDate
  Stream<List<ListingBookings>> readBookingsByProperties(Query query) {
    return query.snapshots().map((querySnapshot) {
      // Convert each document snapshot to a ListingBookings object
      return querySnapshot.docs.map((doc) {
        return ListingBookings.fromJson(doc.data() as Map<String, dynamic>);
      }).toList();
    });
  }

  CollectionReference bookingTasksCollection(String listingId) {
    return _listings
        .doc(listingId)
        .collection(FirebaseConstants.bookingTasksSubCollection);
  }

  FutureEither<String> addBookingTask(
      String listingId, BookingTask bookingTask) async {
    try {
      var doc = bookingTasksCollection(listingId).doc();

      // Update the uid of the booking task
      bookingTask = bookingTask.copyWith(uid: doc.id);

      await doc.set(bookingTask.toJson());

      return right(doc.id);
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  // Update booking task
  FutureVoid updateBookingTask(
      String listingId, BookingTask bookingTask) async {
    try {
      return right(await bookingTasksCollection(listingId)
          .doc(bookingTask.uid)
          .update(bookingTask.toJson()));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

// read bookingtask by bookingId
  Stream<List<BookingTask>> readBookingTasksByBookingId(
      String listingId, String bookingUid) {
    Query query = FirebaseFirestore.instance.collectionGroup('bookingTasks');
    return query
        .where('bookingId', isEqualTo: bookingUid)
        .snapshots()
        .map((querySnapshot) {
      return querySnapshot.docs.map((doc) {
        return BookingTask.fromJson(doc.data() as Map<String, dynamic>);
      }).toList();
    });
  }

// read bookingtask by user id
  Stream<List<BookingTask>> readBookingTasksByMemberId(String userId) {
    Query query = FirebaseFirestore.instance.collectionGroup('bookingTasks');
    return query
        .where('assignedIds', arrayContains: userId)
        .snapshots()
        .map((querySnapshot) {
      return querySnapshot.docs.map((doc) {
        return BookingTask.fromJson(doc.data() as Map<String, dynamic>);
      }).toList();
    });
  }

  Stream<List<BookingTask>> readBookingTasksByContributorId(String userId) {
    Query query = FirebaseFirestore.instance.collectionGroup('bookingTasks');
    return query
        .where('contributorsIds', arrayContains: userId)
        .snapshots()
        .map((querySnapshot) {
      return querySnapshot.docs.map((doc) {
        return BookingTask.fromJson(doc.data() as Map<String, dynamic>);
      }).toList();
    });
  }

  // Read bookingtask by

// read bookingtask by user id
  Stream<BookingTask?> readBookingTaskByTaskId(String bookingTaskId) {
    Query query = FirebaseFirestore.instance.collectionGroup('bookingTasks');
    return query
        .where('uid', isEqualTo: bookingTaskId)
        .snapshots()
        .map((querySnapshot) {
      final doc = querySnapshot.docs.firstOrNull; // Get the first document

      return doc != null
          ? BookingTask.fromJson(doc.data() as Map<String, dynamic>)
          : null;
    });
  }

  CollectionReference roomsCollection(String listingId) {
    return _listings
        .doc(listingId)
        .collection(FirebaseConstants.roomsSubCollection);
  }

  FutureEither<String> addRoom(
      String listingId, ListingModel listing, AvailableRoom room) async {
    try {
      // Generate a new document ID based on the user's ID
      var doc = roomsCollection(listingId).doc();

      // Update the uid of the room
      room = room.copyWith(
          uid: doc.id, listingId: listingId, listingName: listing.title);

      // Add the cooperative to the database
      await doc.set(room.toJson());

      // Return the uid of the newly added room
      return right(doc.id);
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  // Update Room
  FutureVoid updateRoom(AvailableRoom room) async {
    try {
      return right(await roomsCollection(room.listingId!)
          .doc(room.uid!)
          .update(room.toJson()));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

// read room by listingId
  Stream<List<AvailableRoom>> readRoomsByListingId(listingId) {
    return roomsCollection(listingId).snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return AvailableRoom.fromJson(doc.data() as Map<String, dynamic>);
      }).toList();
    });
  }

// read room by roomId
  Stream<AvailableRoom> readRoomById(listingId, roomId) {
    return roomsCollection(listingId).doc(roomId).snapshots().map((snapshot) {
      return AvailableRoom.fromJson(snapshot.data() as Map<String, dynamic>);
    });
  }

  // Read room by properties
  Stream<List<AvailableRoom>> readRoomByProperties(
      List<String> unavailableRoomIds, num guests) {
    Query query = FirebaseFirestore.instance.collectionGroup('availableRooms');

    if (unavailableRoomIds.isNotEmpty) {
      query = query.where('uid', whereNotIn: unavailableRoomIds);
    }
    return query.snapshots().map((querySnapshot) {
      return querySnapshot.docs.map((doc) {
        return AvailableRoom.fromJson(doc.data()! as Map<String, dynamic>);
      }).toList();
    });
  }

  CollectionReference transportCollection(String listingId) {
    return _listings
        .doc(listingId)
        .collection(FirebaseConstants.transportSubcollection);
  }

  FutureEither<String> addTransport(String listingId, ListingModel listing,
      AvailableTransport transport) async {
    try {
      // Generate a new document ID based on the user's ID
      var doc = transportCollection(listingId).doc();

      // Update the uid of the transport
      transport = transport.copyWith(
          uid: doc.id, listingId: listingId, listingName: listing.title);

      // Add the cooperative to the database
      await doc.set(transport.toJson());

      // Return the uid of the newly added transport
      return right(doc.id);
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

// Update transport
  FutureVoid updateTransport(AvailableTransport transport) async {
    try {
      return right(await transportCollection(transport.listingId!)
          .doc(transport.uid!)
          .update(transport.toJson()));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

// read transport by transportId
  Stream<AvailableTransport> readTransportById(listingId, transportId) {
    return transportCollection(listingId)
        .doc(transportId)
        .snapshots()
        .map((snapshot) {
      return AvailableTransport.fromJson(
          snapshot.data() as Map<String, dynamic>);
    });
  }

// Read room by properties
  Stream<List<AvailableTransport>> readTransportByProperties(Query query) {
    return query.snapshots().map((querySnapshot) {
      return querySnapshot.docs.map((doc) {
        return AvailableTransport.fromJson(doc.data() as Map<String, dynamic>);
      }).toList();
    });
  }

  CollectionReference departureCollection(String listingId) {
    return _listings
        .doc(listingId)
        .collection(FirebaseConstants.departuresSubCollection);
  }

// Read room by properties
  Stream<List<DepartureModel>> readDeparturesByPoperties(Query query) {
    return query.snapshots().map((querySnapshot) {
      return querySnapshot.docs.map((doc) {
        return DepartureModel.fromJson(doc.data() as Map<String, dynamic>);
      }).toList();
    });
  }

  FutureEither<String> addDeparture(
      ListingModel listing, DepartureModel departure) async {
    try {
      // Generate a new document ID based on the user's ID
      var doc = departureCollection(listing.uid!).doc();

      // Update the uid of the entertainment
      departure = departure.copyWith(
          uid: doc.id, listingId: listing.uid, listingName: listing.title);

      // Add the cooperative to the database
      await doc.set(departure.toJson());

      // Return the uid of the newly added entertainment
      return right(doc.id);
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  FutureVoid updateDeparture(DepartureModel departure) async {
    try {
      return right(await departureCollection(departure.listingId!)
          .doc(departure.uid!)
          .update(departure.toJson()));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  CollectionReference entertainmentCollection(String listingId) {
    return _listings
        .doc(listingId)
        .collection(FirebaseConstants.entertainmentSubcollection);
  }

  FutureEither<String> addEntertainment(String listingId, ListingModel listing,
      EntertainmentService entertainment) async {
    try {
      // Generate a new document ID based on the user's ID
      var doc = entertainmentCollection(listingId).doc();

      // Update the uid of the entertainment
      entertainment = entertainment.copyWith(
          uid: doc.id, listingId: listing.uid, listingName: listing.title);

      // Add the cooperative to the database
      await doc.set(entertainment.toJson());

      // Return the uid of the newly added entertainment
      return right(doc.id);
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

// Update entertainment
  FutureVoid updateEntertainment(EntertainmentService entertainment) async {
    try {
      return right(await entertainmentCollection(entertainment.listingId!)
          .doc(entertainment.uid!)
          .update(entertainment.toJson()));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

// read entertainment by entertainmentId
  Stream<EntertainmentService> readEntertainmentById(
      listingId, entertainmentId) {
    return entertainmentCollection(listingId)
        .doc(entertainmentId)
        .snapshots()
        .map((snapshot) {
      return EntertainmentService.fromJson(
          snapshot.data() as Map<String, dynamic>);
    });
  }

// Read room by properties
  Stream<List<EntertainmentService>> readEntertainmentByProperties(
      {num? guests}) {
    return FirebaseFirestore.instance
        .collectionGroup('entertainment')
        .where('guests', isEqualTo: guests)
        .snapshots()
        .map((querySnapshot) {
      return querySnapshot.docs.map((doc) {
        return EntertainmentService.fromJson(doc.data());
      }).toList();
    });
  }
}
