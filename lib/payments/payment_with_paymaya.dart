// Calling the PayMaya API for checkout payment
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lakbay/features/listings/listing_controller.dart';
import 'package:lakbay/features/sales/sales_controller.dart';
import 'package:lakbay/models/listing_model.dart';
import 'package:lakbay/models/sale_model.dart';
import 'package:lakbay/models/subcollections/listings_bookings_model.dart';
import 'package:lakbay/payments/payment_web_view.dart';
import 'package:http/http.dart' as http;

Future<void> payWithPaymaya(ListingBookings listingBookings, ListingModel listing, WidgetRef ref, BuildContext context, String paymentOption, num amountDue, Query? query) async {
    final response = await http.post(
      Uri.parse('https://us-central1-lakbay-cd97e.cloudfunctions.net/payWithPaymayaCheckout'),
      headers: <String, String> {
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic> {
        'payment': {
          'paymentOption': paymentOption,
          'totalPrice': amountDue,
        },
        'card': {
          'cardNumber': '4123450131001381',
          'expMonth': '12',
          'expYear': '2025',
          'cvv': '123',
          'cardType': 'VISA',
          'billingAddress': {
            'line1': '6F Launchpad',
            'line2': 'Reliance Street',
            'city': 'Mandaluyong',
            'state': 'Metro Manila',
            'zipCode': '1552',
            'countryCode': 'PH'
          }
        },
        'userDetails': {
          'name': listingBookings.customerName,
          'phone': listingBookings.customerPhoneNo,
        },
        'listingDetails': {
          'listingId': listingBookings.listingId,
          'listingTitle': listingBookings.listingTitle,
        },
        'redirectUrls' : {
          'success': 'https://lakbay.com/payment-success',
          'failure': 'https://lakbay.com/payment-failure',
          'cancel': 'https://lakbay.com/payment-cancel',
        }
      }),
    );

    Map<String, dynamic> responseBody = jsonDecode(response.body);
    int statusCode = responseBody['statusCode'];
    String redirectUrl = responseBody['redirectUrl'];
    Uri uri = Uri.parse(redirectUrl);
    String? bookingId = listingBookings.id;
    String listingId = listing.uid!;

    if (statusCode == 303) {
      debugPrint('Processing checkout. This is the response: $responseBody');
      debugPrint('Redirecting to PayMaya checkout page...');
      debugPrint('this is the bookingId : $bookingId');
      debugPrint('this is the listingId : $listingId');

      // run launchUrl if want to test the payment since paymentWebView is in-progress
      // launchUrl(uri);

      // GoRouter.of(context).go('/payment-web-view', arguments: uri);
      final bool paymentResult = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PaymentWebView(uri: uri),
        ),
      );


      if (paymentResult) {
        debugPrint('The payment was successful!!!');

        if (bookingId != null) {
          final updatedBooking = listingBookings.copyWith(
            amountPaid: amountDue + listingBookings.amountPaid!,
            paymentStatus: "Fully Paid");
          final sale = await ref.read(getSaleByBookingIdProvider(listingBookings.id!).future);
          SaleModel updatedSale = sale.copyWith(transactionType: "Full Payment");
          ref
              .read(salesControllerProvider.notifier)
              // ignore: use_build_context_synchronously
              .updateSale(context, updatedSale, booking: updatedBooking);
          // ignore: use_build_context_synchronously
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Payment successful! You have paid your remaining balance...'),
              backgroundColor: Colors.green,
            ),
          );
        }
        else {

          if (query != null) {
            ref
              .read(listingControllerProvider.notifier)
              // ignore: use_build_context_synchronously
              .addBooking(ref, listingBookings, listing, context, query: query);
          }
          else {
            ref
              .read(listingControllerProvider.notifier)
              // ignore: use_build_context_synchronously
              .addBooking(ref, listingBookings, listing, context);
          }

          // ignore: use_build_context_synchronously
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Payment successful! Adding booking...'),
              backgroundColor: Colors.green,
            ),
          );
        }
        
      }
      else {
        debugPrint('Payment was unsuccessful. Either cancelled or cannot be processed. Try again later.');
        // show snackbar
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Payment was unsuccessful. Either cancelled or cannot be processed. Try again later.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
    else {
      debugPrint('Failed to process checkout. This is the response: $responseBody');
    }
  }



  // final updatedBooking = booking.copyWith(
  //       amountPaid: amountDue + booking.amountPaid!,
  //       paymentStatus: "Fully Paid");
  //   final sale = await ref.read(getSaleByBookingIdProvider(booking.id!).future);
  //   SaleModel updatedSale = sale.copyWith(transactionType: "Full Payment");
  //   ref
  //       .read(salesControllerProvider.notifier)
  //       .updateSale(context, updatedSale, booking: updatedBooking);