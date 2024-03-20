import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lakbay/core/util/utils.dart';
import 'package:lakbay/features/listings/listing_controller.dart';
import 'package:lakbay/features/sales/sales_repository.dart';
import 'package:lakbay/features/trips/plan/plan_controller.dart';
import 'package:lakbay/models/plan_model.dart';
import 'package:lakbay/models/sale_model.dart';
import 'package:lakbay/models/subcollections/listings_bookings_model.dart';

// Stream Provider for get sales
final getSalesProvider = StreamProvider<List<SaleModel>>((ref) {
  final salesController = ref.watch(salesControllerProvider.notifier);
  return salesController.getSales();
});

// get saleByBookingId
final getSaleByBookingIdProvider =
    StreamProvider.autoDispose.family<SaleModel, String>((ref, bookingId) {
  final salesController = ref.watch(salesControllerProvider.notifier);
  return salesController.getSaleByBookingId(
      bookingId); // Assuming getBooking is the method to fetch a single booking
});

final salesControllerProvider =
    StateNotifierProvider<SalesController, bool>((ref) {
  final salesRepository = ref.watch(salesRepositoryProvider);
  return SalesController(
    salesRepository: salesRepository,
    ref: ref,
  );
});

class SalesController extends StateNotifier<bool> {
  final SalesRepository _salesRepository;
  // ignore: unused_field
  final Ref _ref;

  SalesController({
    required SalesRepository salesRepository,
    required Ref ref,
  })  : _salesRepository = salesRepository,
        _ref = ref,
        super(false);

  void addSale(BuildContext context, SaleModel sale,
      {ListingBookings? booking}) async {
    state = true;
    final result = await _salesRepository.addSale(sale);

    result.fold(
      (l) {
        // Handle the error here
        state = false;
        showSnackBar(context, l.message);
      },
      (saleUid) async {
        state = false;
        _ref
            .read(listingControllerProvider.notifier)
            .updateBooking(context, booking!.listingId, booking, "");
        if (context.mounted) {
          // showSnackBar(context, 'Sale added successfully');
        }
        // _ref.read(navBarVisibilityProvider.notifier).show();
      },
    );
  }

  void updateSale(BuildContext context, SaleModel sale,
      {ListingBookings? booking, PlanModel? trip}) {
    state = true;
    _salesRepository.updateSale(sale).then((result) {
      state = false;
      result.fold(
        (l) => showSnackBar(context, l.message),
        (r) {
          booking != null
              ? _ref
                  .read(listingControllerProvider.notifier)
                  .updateBooking(context, booking.listingId, booking, "")
              : null;
          trip != null
              ? _ref
                  .read(plansControllerProvider.notifier)
                  .updatePlan(trip, context)
              : null;

          // context.pop();
          // showSnackBar(context, '');
        },
      );
    });
  }

  // Read all sales
  Stream<List<SaleModel>> getSales() {
    return _salesRepository.readSales();
  }

  // Read sale by bookingId
  Stream<SaleModel> getSaleByBookingId(String bookingId) {
    return _salesRepository.readSaleByBookingId(bookingId);
  }
}
